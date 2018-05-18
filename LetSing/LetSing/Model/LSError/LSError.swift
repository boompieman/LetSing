//
//  LSError.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/4.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation

enum LSError: String, Error {
    case youtubeError = "Get data from youtube failed"

    case LSFirebaseError = "Get data from Let Sing firebase failed"

    case LSFirstAssetError = "Could not get first asset"

    case timedTextError = "Get captions from timedtext failed: See: http://video.google.com/timedtext?lang={lang, ex: zh-TW}}&v={VideoID}}"
}
