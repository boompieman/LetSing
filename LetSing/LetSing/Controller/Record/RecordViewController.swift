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
import Firebase

class RecordViewController: UIViewController {

    private static var observerContext = 0

    @IBOutlet weak var endRecordButton: EndRecordButton!
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

        videoProvider.addObserver(
            self,
            forKeyPath: #keyPath(LSYoutubeVideoProvider.floatCurrentTime),
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

    // MARK: Btn Action

    @IBAction func didMoveSlider(_ sender: UISlider) {
        videoProvider.seekTo(percentage: sender.value)
    }

    @IBAction func startRecordBtnTapped(_ sender: EndRecordButton) {

        sender.isSelected = !sender.isSelected

        if sender.isSelected {
            recordManager.start()

        } else {
            Analytics.logEvent("record_button_tapped", parameters: nil)
            recordManager.stop()
        }
    }

    @IBAction func didTappedBackButton(_ sender: Any) {
        recordManager.discard()
        self.navigationController?.popViewController(animated: true)
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

        if path == #keyPath(LSYoutubeVideoProvider.floatCurrentTime) {

            playerCurrentLyricsHandler(change: change)
        }
    }

    // 需要解決若此首歌沒有歌詞就不要追蹤的問題
    private func playerCurrentLyricsHandler(change: [NSKeyValueChangeKey : Any]) {

        guard let newValue = change[NSKeyValueChangeKey.newKey] as? Float else { return }

        let lyricsVC = childViewControllers[0] as? LyricsViewController

        lyricsVC?.moveLyrics(currentTime: newValue)
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

        loadingView.removeView()

        print("player Ready")
    }

    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {

        switch playerState {

        case .Playing:

            videoProvider.startTimer()

            print("playing")

        case .Ended:
            print("Ended")

            recordManager.stop()

        case .Paused:
            print("Pause")

        default:
            break
        }
    }
}

extension RecordViewController: ScreenCaptureManagerDelegate {
    func didStartRecord() {

        print("didStartRecord")

        endRecordButton.startRecording()
    }

    func didFinishRecord(preview: UIViewController) {

        print("Record did finish")

        endRecordButton.stopRecording()

        let previewController = preview as! RPPreviewViewController

        previewController.previewControllerDelegate = self

        self.present(previewController, animated: true, completion: nil)
    }

    func didStopWithError(error: Error) {

        endRecordButton.stopRecording()

        let alert = AlertManager.shared.showAlert(
            with: "好像出現什麼問題",
            message: error.localizedDescription,
            completion: { }
        )

        self.present(alert, animated: true, completion: { [unowned self] in

            guard let tabbarController = UIStoryboard.mainStoryboard().instantiateViewController(
                withIdentifier: String(describing: TabBarViewController.self)
                ) as? TabBarViewController else { return }

            self.present(tabbarController, animated: false, completion: { [unowned self] in
                self.removeFromParentViewController()
            })
        })
    }
}

extension RecordViewController: RPPreviewViewControllerDelegate {

    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        DispatchQueue.main.async {

            guard let tabbarController = UIStoryboard.mainStoryboard().instantiateViewController(
                withIdentifier: String(describing: TabBarViewController.self)
                ) as? TabBarViewController else { return }

            previewController.present(tabbarController, animated: false, completion: {[unowned self] in
                self.removeFromParentViewController()
            })
        }
    }

    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        
        if activityTypes.contains(UIActivityType.saveToCameraRoll.rawValue) {
            DispatchQueue.main.async {

                let alert = AlertManager.shared.showAlert(
                    with: "提醒您",
                    message: "你的影片已儲存在手機相簿內",
                    completion: { [unowned self] in
                        guard let tabbarController = UIStoryboard.mainStoryboard().instantiateViewController(
                            withIdentifier: String(describing: TabBarViewController.self)
                            ) as? TabBarViewController else { return }

                        previewController.present(tabbarController, animated: false, completion: { [unowned self] in
                            self.removeFromParentViewController()
                        })
                    }
                )

                previewController.present(alert, animated: false, completion: nil)

//                guard let tabbarController = UIStoryboard.mainStoryboard().instantiateViewController(
//                    withIdentifier: String(describing: TabBarViewController.self)
//                    ) as? TabBarViewController else { return }
//
//                previewController.present(tabbarController, animated: false, completion: {[unowned self] in
//                    self.removeFromParentViewController()
//                })
//                previewController.present((PostProductionViewController()), animated: false, completion: {[unowned self] in
//                    self.removeFromParentViewController()
//                })
            }
        }
    }
}

