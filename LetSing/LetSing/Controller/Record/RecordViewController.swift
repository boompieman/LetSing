//
//  ViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/1.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit
import AVFoundation
import YouTubePlayer
import ReplayKit

class RecordViewController: UIViewController {

    private static var observerContext = 0

    @IBOutlet weak var recordNavigationView: RecordNavigationView!
    @IBOutlet weak var recordVideoPanelView: RecordVideoPanelView!

    var song: Song?

    let videoProvider = LSYoutubeVideoProvider()

    let recorder = RPScreenRecorder.shared()

    var isRecording: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setBar()
        setupRecordNavigationView()

        observePlayerCurrentTime()

        generatePlayer(videoID: (song?.youtube_url)!)
    }

    private func observePlayerCurrentTime() {

        videoProvider.addObserver(
            self,
            forKeyPath: #keyPath(LSYoutubeVideoProvider.currentTime),
            options: NSKeyValueObservingOptions.new,
            context: &RecordViewController.observerContext
        )
    }

    func generatePlayer(videoID: String) {

        recordVideoPanelView.videoPlayerView.clear()

        recordVideoPanelView.videoPlayerView.isUserInteractionEnabled = false

        recordVideoPanelView.playBtn.isSelected = true

        recordVideoPanelView.updateEndTime(time: LSConstants.PlayerTime.originTime)

        recordVideoPanelView.updateCurrentTime(time: LSConstants.PlayerTime.originTime, proportion: LSConstants.PlayerTime.originProportion)

        recordVideoPanelView.videoPlayerView.delegate = self

        videoProvider.generatePlayer(player: recordVideoPanelView.videoPlayerView, videoID, observer: self, context: &RecordViewController.observerContext)
    }

    // MARK: Action
    @IBAction func startRecordBtnTapped(_ sender: UIButton) {

        if !sender.isSelected {
            self.recorder.isMicrophoneEnabled = true
            self.recorder.startRecording { (error) in
                if let error = error {
                    print(error)
                }
            }
            videoProvider.play()
            sender.isSelected = !sender.isSelected
            sender.setTitle("停止錄製", for: .selected)
        }

        else {
            sender.isSelected = !sender.isSelected

            self.recorder.stopRecording { (previewVC, error) in
                if let previewVC = previewVC {
                    previewVC.previewControllerDelegate = self
                    self.present(previewVC, animated: true, completion: nil)
                }
                if let error = error {
                    print(error)
                }
            }
        }
    }

    func removeObserverAndPlayer() {
        videoProvider.pause()
        videoProvider.clear()
        videoProvider.invalidateTimer()
        videoProvider.removeObserver(self, forKeyPath: #keyPath(LSYoutubeVideoProvider.currentTime))
    }

    @IBAction func playBtnDidTouched(_ sender: UIButton) {

        sender.isSelected = !sender.isSelected

        sender.isSelected ? videoProvider.play() : videoProvider.pause()
    }

//    // MARK: - KVO

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        guard context == &RecordViewController.observerContext else {

            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)

            return
        }

        guard let path = keyPath,
            let change = change
            else { return }

        if path == #keyPath(LSYoutubeVideoProvider.currentTime) {

            playerCurrentTimeHandler(change: change)
        }
    }

    private func playerCurrentTimeHandler(change: [NSKeyValueChangeKey : Any]) {

        guard let newValue = change[NSKeyValueChangeKey.newKey] as? String else { return }

        recordVideoPanelView.updateCurrentTime(
            time: newValue,
            proportion: videoProvider.currentProportion()
        )
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // set Navigation
    func setupRecordNavigationView() {
        recordNavigationView.titleLabel.text = song?.name
    }

    @IBAction func didTappedBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    // set Bar hidden
    func setBar() {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeObserverAndPlayer()

        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension RecordViewController: YouTubePlayerDelegate {
    func playerReady(_ videoPlayer: YouTubePlayerView) {

        recordVideoPanelView.updateEndTime(time: videoProvider.getDurationString())

        print("record")
    }


    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {


        print("aaaaaa",playerState)
        switch playerState {
        case .Playing:

            videoProvider.startTimer()

            print("playing")

        case .Ended:
            // record end
            print("Ended")
//            videoProvider.invalidateTimer()
            // go to next page
        default:
            print("done")
        }
    }
    func playerQualityChanged(_ videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {

    }
}

extension RecordViewController: RPPreviewViewControllerDelegate {

    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true, completion: nil)
    }

}

