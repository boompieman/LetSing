//
//  VideoPlayer.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/30.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

class VideoPlayerViewController: UIViewController {

    private static var observerContext = 0

    @IBOutlet weak var videoPanelView: LSVideoPanelView!

    var videoURL: URL?

    let videoProvider = LSVideoProvider()

    override func viewDidLoad() {
        super.viewDidLoad()


        setupPlayer()

        videoProvider.play()
    }

    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didCompleteDuration(notification:)), name: .finishVideoDuration, object: self.videoProvider)
    }

    // MARK: - Notification
    @objc private func didCompleteDuration(notification: NSNotification) {


    }

    func setupPlayer() {

        videoProvider.pause()

        guard let url = videoURL else {

            return }

        guard let player = videoProvider.generatePlayerAndObserveStatus(
            url: url,
            observer: self,
            context: &VideoPlayerViewController.observerContext
        ) else { return }

        videoPanelView.updatePlayer(player: player)

        print("dddddd: ",videoProvider.duration)

        videoProvider.play()
    }

    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        guard context == &VideoPlayerViewController.observerContext else {

            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)

            return
        }

        guard let path = keyPath,
            let change = change
            else { return }

        if path == #keyPath(LSVideoProvider.currentTime) {

            playerCurrentTimeHandler(change: change)
        }
    }

    private func playerCurrentTimeHandler(change: [NSKeyValueChangeKey : Any]) {

        guard let newValue = change[NSKeyValueChangeKey.newKey] as? String else { return }

//        videoPanelView.updateCurrentTime(
//            newValue,
//            proportion: videoProvider.currentProportion()
//        )
    }

}
