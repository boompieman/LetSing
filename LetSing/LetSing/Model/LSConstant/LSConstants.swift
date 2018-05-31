//
//  LSConstant.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/4.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import UIKit

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

    static let duration = "duration"

    static let tableViewInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)

    static let emptyString = ""

    static let playerVars = [
        "playsinline": 1 as AnyObject,
        "showinfo": 0 as AnyObject,
        "controls": 0 as AnyObject,
        "iv_load_policy": 3 as AnyObject,
        "modestbranding": 1 as AnyObject,
        "widget_referrer": "origin" as AnyObject
    ]
}
