//
//  LSVideoPlayer.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/30.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import AVFoundation

extension Notification.Name {

    static let finishVideoDuration = Notification.Name(LSConstants.NotificationKey.finishVideoDuration)
}

class LSVideoProvider: NSObject {

    private var player: AVPlayer?

    var duration: String = LSConstants.emptyString

    @objc dynamic var currentTime: String = LSConstants.emptyString

    private static var observerContext = 0

    private let timeTransformer = LSTimeTransFormer()

    func generatePlayer(url: URL) -> AVPlayer? {

        let item = AVPlayerItem(asset: generateAsset(url: url))

        player = AVPlayer(playerItem: item)

        player!.addPeriodicTimeObserver(
            forInterval: CMTime(
                seconds: 1,
                preferredTimescale: CMTimeScale(NSEC_PER_SEC)
            ),
            queue: DispatchQueue.main) { [weak self] cmTime in

                guard let strongSelf = self else { return }

                strongSelf.currentTime = strongSelf.timeTransformer.time(cmTime)
        }

        return player!
    }

    func shouldEnd() -> Bool {

        guard let player = player else {
            return false
        }

        if player.currentTime() >= (player.currentItem?.asset.duration)! {
            return true
        }

        return false

    }

    func generatePlayerAndObserveStatus(
        url: URL,
        observer: NSObject,
        context: UnsafeMutableRawPointer?
        ) -> AVPlayer?
    {

        guard let player = generatePlayer(url: url),
            let item = player.currentItem
            else { return nil }

        item.addObserver(observer, forKeyPath: #keyPath(AVPlayerItem.status), options: NSKeyValueObservingOptions.new, context: context)

        return player
    }

    private func generateAsset(url: URL) -> AVAsset {

        let asset = AVAsset(url: url)

        let durationKey = LSConstants.duration

        asset.loadValuesAsynchronously(forKeys: [durationKey]) { [weak self] in

            guard let strongSelf = self else { return }

            strongSelf.duration = strongSelf.timeTransformer.time(asset.duration)

            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: NSNotification.Name.finishVideoDuration,
                    object: self
                )
            }
        }
        return asset
    }

    func removeAllObserver (
        observer: NSObject,
        context: UnsafeMutableRawPointer?
        ) {

        guard let player = player,
            let item = player.currentItem
            else { return }

        pause()

        item.removeObserver(observer, forKeyPath: #keyPath(AVPlayerItem.status), context: context)
        self.removeObserver(observer, forKeyPath: #keyPath(LSVideoProvider.currentTime), context: context)
    }


    // MARK: - Player Action
    func play() {

        guard let player = player else { return }

        player.play()
    }

    func pause() {

        guard let player = player else { return }

        player.pause()
    }

    func changePlayerStep(_ step: Double) {

        guard let player = player else { return }

        let time = Double(CMTimeGetSeconds(player.currentTime())) + step

        seekTo(portion: time)
    }

    //MRAK: private func
    private func seekTo(portion: Double) {

        guard let player = player else { return }

        player.seek(
            to: CMTime(seconds: portion, preferredTimescale: 1),
            completionHandler: { _ in }
        )
    }
}
