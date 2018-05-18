//
//  PostProductionViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/15.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import AudioKit


class PostProductionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    func getRecordingVideo() {

        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.includeAssetSourceTypes = .typeUserLibrary


        let results = PHAsset.fetchAssets(with: .video, options: options)

        let firstObject = results.firstObject

        guard let firstAsset = firstObject else {
            return
        }

//        let resources = PHAssetResource.assetResources(for: firstAsset)
//
//
        let videoOption = PHVideoRequestOptions()
        videoOption.version = .original

        PHImageManager.default().requestAVAsset(forVideo: firstAsset, options: videoOption) { (asset, audioMix, info) in
            print("assets", asset)

            print("audioMix", audioMix)

            print("info", info?.keys)

            if let urlAsset = asset as? AVURLAsset {
                let localVideoURL = urlAsset.url

                print(localVideoURL)
            }
        }
    }
}
