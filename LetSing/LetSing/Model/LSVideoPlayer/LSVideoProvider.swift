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

        let item = AVPlayerItem(asset: generateAsset(url: URL(string: "/private/var/mobile/Containers/Data/Application/13823AE1-3C87-446E-BD5F-274073A582B0/Documents/Records/2018-05-30-12:24:00.mp4")!))



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

        print("asset:", asset)

        return asset
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
}
