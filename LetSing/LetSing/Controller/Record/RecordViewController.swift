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

    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var recordNavigationView: RecordNavigationView!
    @IBOutlet weak var recordVideoPanelView: RecordVideoPanelView!
    let videoProvider = LSYoutubeVideoProvider()
    var song: Song?

    var recordManager = LSRecordManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRecordManager()
        observePlayerCurrentTime()
        generatePlayer()
        sendData()
    }

    func sendData() {
        let lyricsVC = childViewControllers[0] as? LyricsViewController

        guard let song = song else {
            return
        }

        lyricsVC?.videoProvider = videoProvider

        lyricsVC?.requestLyrics(song: song)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setBar()
        setupRecordNavigationView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        videoProvider.removeObserverAndPlayer(self)

        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func setupRecordManager() {
        recordManager.setLSAudioCategory(isActive: true)
        recordManager.delegate = self
    }

    // MARK: Navigation and Bar
    func setupRecordNavigationView() {
        recordNavigationView.titleLabel.text = song?.name
    }

    @IBAction func didTappedBackButton(_ sender: Any) {
        recordManager.discard()
        self.navigationController?.popViewController(animated: true)
    }

    func setBar() {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }


    // MARK: vedioProvider
    private func observePlayerCurrentTime() {

        videoProvider.addObserver(
            self,
            forKeyPath: #keyPath(LSYoutubeVideoProvider.currentTime),
            options: NSKeyValueObservingOptions.new,
            context: &RecordViewController.observerContext
        )
    }

    func generatePlayer() {

        guard let song = song else {
            return
        }

        recordVideoPanelView.updatePlayer()
        recordVideoPanelView.videoPlayerView.delegate = self
        videoProvider.generatePlayer(player: recordVideoPanelView.videoPlayerView, song.id, observer: self, context: &RecordViewController.observerContext)
    }

    // MARK: record Action
    @IBAction func startRecordBtnTapped(_ sender: UIButton) {

        recordManager.stop()

    }

    // MARK: - KVO

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
}

extension RecordViewController: YouTubePlayerDelegate {
    func playerReady(_ videoPlayer: YouTubePlayerView) {

        recordVideoPanelView.updateEndTime(time: videoProvider.getDurationString())

        videoProvider.play()

        print("player Ready")
    }

    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {

        switch playerState {

        case .Playing:

            
            videoProvider.startTimer()

            loadingView.removeView(recordManager.start)

            print("playing")

        case .Ended:
            print("Ended")
            videoProvider.removeObserverAndPlayer(self)
            // go to next page

        case .Paused:
            print("Pause")

        default:
            break
        }
    }
}

extension RecordViewController: ScreenCaptureManagerDelegate {
    func didStartRecord() {
        print("Record did Start")
    }

    func didFinishRecord(preview: UIViewController) {
        print("Record did finish")

        let previewController = preview as! RPPreviewViewController

        previewController.previewControllerDelegate = self

        self.present(previewController, animated: true, completion: nil)
    }

    func didStopWithError(error: Error) {
        print("Record did Stop with Error: ", error)
    }
}

extension RecordViewController: RPPreviewViewControllerDelegate {

    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        DispatchQueue.main.async {

            guard let controller = UIStoryboard.mainStoryboard().instantiateViewController(
                withIdentifier: String(describing: TabBarViewController.self)
                ) as? TabBarViewController else { return }

            previewController.present(controller, animated: false, completion: nil)

        }
    }

    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        
        if activityTypes.contains(UIActivityType.saveToCameraRoll.rawValue) {
            DispatchQueue.main.async {

                previewController.present((PostProductionViewController()), animated: false, completion: nil)
            }
        }
    }
}

