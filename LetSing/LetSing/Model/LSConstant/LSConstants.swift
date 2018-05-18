//
//  LSConstant.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/4.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation

struct LSConstants {
    static let youtubeUrl = "https://www.googleapis.com/youtube/v3"

    static let youtubeKey = "AIzaSyBNMdTRxwA1waBGk_qFxUSRadSAw_dg3Bc"

    static let captionsUrl = "http://video.google.com/timedtext"

    struct NotificationKey {

        static let finishVideoDuration = "finishVideoDuration"

        static let currentTimeChanged =  "currentTimeChanged"
    }

    struct PlayerTime {
        
        static let originTime = "00:00"

        static let originProportion = 0.0
    }

    static let emptyString = ""

    static let duration = "duration"

    static let playerVars = [
        "playsinline": 1 as AnyObject,
        "showinfo": 0 as AnyObject,
        "controls": 0 as AnyObject,
        "iv_load_policy": 3 as AnyObject,
        "modestbranding": 1 as AnyObject,
        "widget_referrer": "origin" as AnyObject
    ]

//    static let firebaseUrl = "https://letsing.firebaseio.com/"
}
