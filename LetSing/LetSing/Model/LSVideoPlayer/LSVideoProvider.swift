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

    func play() {

        guard let player = player else { return }

        player.play()
    }
}
