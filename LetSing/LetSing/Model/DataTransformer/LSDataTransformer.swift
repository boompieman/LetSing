//
//  DataFormatter.swift
//  LetSing
//
//  Created by MACBOOK on 2018/6/29.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import AVFoundation
import Foundation

class LSDataTransformer {

    func videoToData(url: URL) -> Data? {

        guard let videoData = try? Data(contentsOf: url) else {
            return nil
        }

        return videoData
    }
}
