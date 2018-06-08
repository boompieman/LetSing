//
//  VideoPlayer.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/30.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit
import AVFoundation

class ReviewViewController: UIViewController {

    private static var observerContext = 0

    @IBOutlet weak var videoPanelView: LSVideoPanelView!
    @IBOutlet weak var footerView: LSVideoFooterView!

    var videoURL: URL?

    let videoProvider = LSVideoProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPlayer()

        registerNotification()

        observePlayerCurrentTime()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        videoProvider.removeAllObserver(observer: self, context: &ReviewViewController.observerContext)

        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        UIApplication.shared.setStatusBarHidden(false, with: .none)
    }

    func setBar() {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        UIApplication.shared.setStatusBarHidden(true, with: .none)
    }

    

    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didCompleteDuration(notification:)), name: .finishVideoDuration, object: self.videoProvider)
    }

    // MARK: - Notification
    @objc private func didCompleteDuration(notification: NSNotification) {

    }

    func setupPlayer() {

        guard let url = videoURL else {

            return }

        guard let player = videoProvider.generatePlayerAndObserveStatus(
            url: url,
            observer: self,
            context: &ReviewViewController.observerContext
        ) else { return }

        videoPanelView.updatePlayer(player: player)

        videoPanelView.delegate = self
    }

    @IBAction func didTappedBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: - player action


    @IBAction func rewindBtnDidTapped(_ sender: UIButton) {

        videoProvider.changePlayerStep(LSConstants.backStep)

    }

    @IBAction func playBtnDidTapped(_ sender: UIButton) {

        sender.isSelected = !sender.isSelected

        sender.isSelected ? videoProvider.play() : videoProvider.pause()

    }


    @IBAction func fastFowardBtnDidTapped(_ sender: UIButton) {

        videoProvider.changePlayerStep(LSConstants.forwardStep)

    }

    // MARK: - KVO
    private func observePlayerCurrentTime() {

        videoProvider.addObserver(
            self,
            forKeyPath: #keyPath(LSVideoProvider.currentTime),
            options: NSKeyValueObservingOptions.new,
            context: &ReviewViewController.observerContext
        )
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        guard context == &ReviewViewController.observerContext else {

            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)

            return
        }

        guard let path = keyPath,
            let change = change
            else { return }

        if path == #keyPath(AVPlayerItem.status) {

            playerStatusHandler(change: change)

        } else if path == #keyPath(LSVideoProvider.currentTime) {

            playerCurrentTimeHandler(change: change)
        }
    }

    private func playerStatusHandler(change: [NSKeyValueChangeKey : Any]) {

        guard let status = change[NSKeyValueChangeKey.newKey] as? Int,
            let itemStatus = AVPlayerItemStatus(rawValue: status)
            else { return }

        switch itemStatus {

        case .unknown: break

        case .failed: break

        case .readyToPlay:

            videoProvider.play()
            footerView.playerDidPlay()
            
        }
    }

    private func playerCurrentTimeHandler(change: [NSKeyValueChangeKey : Any]) {
        guard let newValue = change[NSKeyValueChangeKey.newKey] as? String else { return }

        if videoProvider.shouldEnd() {
            self.navigationController?.popViewController(animated: true)
        }

//        videoPanelView.updateCurrentTime(
//            newValue,
//            proportion: videoProvider.currentProportion()
//        )
    }
}

extension ReviewViewController: LSVideoPanelViewDelegate {
    func didSwipePlayer(_ playerView: LSVideoPanelView) {
        self.navigationController?.popViewController(animated: true)
    }

    func didTappedPlayer(_ playerView: LSVideoPanelView) {

        playerView.isSelected = !playerView.isSelected

        playerView.isSelected ? footerView.isHidden(false) : footerView.isHidden(true)
    }
}
