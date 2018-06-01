//
//  LSYoutubeVideoProvider.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/10.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import YouTubePlayer

extension Notification.Name {

    static let currentTimeChanged = Notification.Name(LSConstants.NotificationKey.currentTimeChanged)
}


class LSYoutubeVideoProvider: NSObject {

    private var player: YouTubePlayerView?

    private let timeTransformer = LSTimeTransFormer()

    private static var observerContext = 0

    var duration: String = LSConstants.emptyString

    //kvo
    @objc dynamic var currentTime: String = LSConstants.emptyString

    @objc dynamic var floatCurrentTime: Float = 0.0

    var timer: Timer?

    func generatePlayer(player: YouTubePlayerView,
                        _ videoID: String,
                        observer: NSObject,
                        context: UnsafeMutableRawPointer?
        ) -> YouTubePlayerView? {

        player.playerVars = LSConstants.playerVars

        player.loadVideoID(videoID)

        self.player = player

        return player
    }

    func startTimer() {

        timer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(setCurrentTime),
            userInfo:nil,
            repeats:true
        )
    }

    func removeObserverAndPlayer (
        observer: NSObject,
        context: UnsafeMutableRawPointer?
        ) {

        pause()
        clear()
        invalidateTimer()
        removeObserver(observer, forKeyPath:  #keyPath(LSYoutubeVideoProvider.floatCurrentTime), context: context)
        removeObserver(observer, forKeyPath:  #keyPath(LSYoutubeVideoProvider.currentTime), context: context)
    }


    func invalidateTimer() {

        guard let timer = timer else { return }

        timer.invalidate()
        
    }

    func isPlaying() -> Bool {

        if player?.playerState == .Playing {
            return true
        }

        return false

    }


    @objc func setCurrentTime() {

        guard let player = player, let currentTime = player.getCurrentTime(), let floatCurrentTime = Float(currentTime) else { return }

        self.floatCurrentTime = floatCurrentTime

        self.currentTime = self.timeTransformer.time(currentTime)
    }

    func currentProportion() -> Double {

        guard let player = player, let currentTime = player.getCurrentTime(), let duration = player.getDuration() else { return 0.0}

        let proportion: Double = Double(currentTime)! / Double(duration)!

        return proportion
    }

    func getDurationString() -> String {

        guard let player = player, let duration = player.getDuration() else {
            return LSConstants.PlayerTime.originTime
        }
        
        return self.timeTransformer.time(duration)
    }

    // MARK: player action
    func play() {

        guard let player = player else { return }

        player.play()
    }

    func pause() {

        guard let player = player else { return }

        player.pause()
    }

    func clear() {
        
        guard let player = player else { return }

        player.clear()
    }

    func seekTo(percentage: Float) {

        guard let player = player, let duration = player.getDuration() else {
            return
        }

        guard let floatDuration = Float(duration) else {
            return
        }

        player.seekTo(percentage * floatDuration, seekAhead: true)
    }
}
