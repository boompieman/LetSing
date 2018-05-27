//
//  File.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/18.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import Photos
import AVFoundation
import AudioKit


class AudioTransformatter {

    func getRecoringViedoURL(completion: @escaping (URL) -> Void) {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.includeAssetSourceTypes = .typeUserLibrary

        let results = PHAsset.fetchAssets(with: .video, options: options)

        let firstObject = results.firstObject

        guard let firstAsset = firstObject else {

            return
        }

        let videoOption = PHVideoRequestOptions()
        videoOption.version = .original

        PHImageManager.default().requestAVAsset(forVideo: firstAsset, options: videoOption) { (asset, audioMix, info) in

            guard let urlAsset = asset as? AVURLAsset else {

                    return
            }

            let videoURL = urlAsset.url

            completion(videoURL)
        }
    }
}
