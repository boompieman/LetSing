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
    let videoProvider = LSYoutubeVideoProvider()
    var song: Song?
    var recordPlayerManager = LSRecordPlayerManager()


    @IBOutlet weak var endRecordButton: EndRecordButton!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var recordNavigationView: RecordNavigationView!
    @IBOutlet weak var recordVideoPanelView: RecordVideoPanelView!

    @IBOutlet weak var notIphoneXConstraint: NSLayoutConstraint!
    @IBOutlet weak var iphoneXConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()


//        sendData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


        // 先讓畫面跑Loading，在做其他事情，增加使用者體驗
        setupRecordPlayerManager()
        observePlayerCurrentTime()
        generatePlayer()
        //
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setBar()
        setupRecordNavigationView()
    }

    // set IphoneX layout
    override func viewWillLayoutSubviews() {
        if UIDevice.current.isX() {
            iphoneXConstraint.isActive = true
            notIphoneXConstraint.isActive = false
        }
    }


    func sendData() {
        let lyricsVC = childViewControllers[0] as? LyricsViewController

        guard let song = song else {
            return
        }

        lyricsVC?.requestLyrics(song: song)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        videoProvider.removeObserverAndPlayer(observer: self, context: &RecordViewController.observerContext)

        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        UIApplication.shared.setStatusBarHidden(false, with: .none)
    }

    func setupRecordPlayerManager() {
        recordPlayerManager.setLSAudioCategory(isActive: true)
        recordPlayerManager.delegate = self
    }

    // MARK: Navigation and Bar
    func setupRecordNavigationView() {
        recordNavigationView.titleLabel.text = song?.name
    }

    func setBar() {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        UIApplication.shared.setStatusBarHidden(true, with: .none)
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
        recordVideoPanelView.delegate = self

        videoProvider.generatePlayer(player: recordVideoPanelView.videoPlayerView, song.id, observer: self, context: &RecordViewController.observerContext)
    }

    // MARK: Btn Action

    @IBAction func didMoveSlider(_ sender: UISlider) {
        videoProvider.seekTo(percentage: sender.value)
    }

    @IBAction func startRecordBtnTapped(_ sender: EndRecordButton) {

        sender.isSelected = !sender.isSelected

        if sender.isSelected {
            recordPlayerManager.start()

        } else {
            LSAnalytics.shared.logEvent("record_button_tapped", parameters: nil)
            recordPlayerManager.stop()
        }
    }

    @IBAction func didTappedBackButton(_ sender: Any) {
        recordPlayerManager.discard()
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

//        guard let newValue = change[NSKeyValueChangeKey.newKey] as? Float else { return }

//        let lyricsVC = childViewControllers[0] as? LyricsViewController

//        lyricsVC?.moveLyrics(currentTime: newValue)
    }

    private func playerCurrentTimeHandler(change: [NSKeyValueChangeKey : Any]) {

        guard let newValue = change[NSKeyValueChangeKey.newKey] as? String else { return }

        recordVideoPanelView.updateCurrentTime (
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
    }

    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {

        switch playerState {

        case .Playing:

            videoProvider.startTimer()

        case .Ended:

            recordPlayerManager.stop()

        default:

            break

        }
    }
}

extension RecordViewController: ScreenCaptureManagerDelegate {
    func didStartRecord() {

        endRecordButton.startRecording()

//        guard let cameraView = recordPlayerManager.generateCamaraPreView() else {
//
//            print("cameraView did not generate")
//            return
//        }
//
//        let cameraHeight = UIScreen.main.bounds.height - (self.recordNavigationView.frame.origin.y + self.recordNavigationView.frame.height + self.endRecordButton.frame.height + 25)
//
//        cameraView.frame = CGRect(x: 0, y: self.recordNavigationView.frame.origin.y + self.recordNavigationView.frame.height, width: UIScreen.main.bounds.width, height: cameraHeight)
//
//        print(cameraView.frame)
//
//        self.view.addSubview(cameraView)
    }

    func didFinishRecord() {

        endRecordButton.stopRecording()

        let alert = AlertManager.shared.showAlert(
            with: NSLocalizedString(
                LSConstants.Localization.remind,
                comment: LSConstants.emptyString
            ),
            message: NSLocalizedString(
                LSConstants.Localization.remindMessage,
                comment: LSConstants.emptyString
            ),
            completion: { [unowned self] in
                self.navigationController?.popViewController(animated: true)
            }
        )

        self.present(alert, animated: false, completion: nil)
    }

    func didStopWithError(error: Error) {

        endRecordButton.stopRecording()

        let alert = generateAlert(with: error)

        self.present(alert, animated: true, completion: { [unowned self] in

            guard let tabbarController = self.generateTabBarController() else { return }

            self.present(tabbarController, animated: false, completion: { [unowned self] in
                self.removeFromParentViewController()
            })
        })
    }

    // MARK: private func
    private func generateAlert(with error: Error) -> UIAlertController {

        let alert =
            AlertManager.shared.showAlert (
                with: NSLocalizedString(
                    LSConstants.Localization.alertTitle,
                    comment: LSConstants.emptyString),
                message: error.localizedDescription,
                completion: { }
        )

        return alert
    }

    private func generateTabBarController() -> TabBarViewController? {
        guard let tabbarController = UIStoryboard.mainStoryboard().instantiateViewController(
            withIdentifier: String(describing: TabBarViewController.self)
            ) as? TabBarViewController else { return nil}

        return tabbarController
    }

}

extension RecordViewController: RecordVideoPanelViewDelegate {
    func didTappedPlayer(playerView: YouTubePlayerView) {
        if videoProvider.isPlaying() {
            videoProvider.pause()
        } else {
            videoProvider.play()
        }
    }
}

//extension RecordViewController: RPPreviewViewControllerDelegate {
//
//    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
//        DispatchQueue.main.async {
//
//            guard let tabbarController = UIStoryboard.mainStoryboard().instantiateViewController(
//                withIdentifier: String(describing: TabBarViewController.self)
//                ) as? TabBarViewController else { return }
//
//            previewController.present(tabbarController, animated: false, completion: {[unowned self] in
//                self.removeFromParentViewController()
//            })
//        }
//    }
//
//    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
//
//        if activityTypes.contains(UIActivityType.saveToCameraRoll.rawValue) {
//            DispatchQueue.main.async {
//
//                let alert = AlertManager.shared.showAlert(
//                    with: "提醒您",
//                    message: "你的影片已儲存在手機相簿內",
//                    completion: { [unowned self] in
//                        guard let tabbarController = UIStoryboard.mainStoryboard().instantiateViewController(
//                            withIdentifier: String(describing: TabBarViewController.self)
//                            ) as? TabBarViewController else { return }
//
//                        previewController.present(tabbarController, animated: false, completion: { [unowned self] in
//                            self.removeFromParentViewController()
//                        })
//                    }
//                )
//
//                previewController.present(alert, animated: false, completion: nil)
////
////                guard let tabbarController = UIStoryboard.mainStoryboard().instantiateViewController(
////                    withIdentifier: String(describing: TabBarViewController.self)
////                    ) as? TabBarViewController else { return }
////
////                previewController.present(tabbarController, animated: false, completion: {[unowned self] in
////                    self.removeFromParentViewController()
////                })
////                previewController.present((PostProductionViewController()), animated: false, completion: {[unowned self] in
////                    self.removeFromParentViewController()
////                })
//            }
//        }
//    }
//}


