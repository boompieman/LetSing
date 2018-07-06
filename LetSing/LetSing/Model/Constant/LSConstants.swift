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

    static let dateFormat = "yyyy-MM-dd HH:mm:ss"

    static let tableViewInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)

    static let emptyString = ""

    static let tokenID = "UserID"

    static let playerVars = [
        "playsinline": 1 as AnyObject,
        "showinfo": 0 as AnyObject,
        "controls": 0 as AnyObject,
        "iv_load_policy": 3 as AnyObject,
        "modestbranding": 1 as AnyObject,
        "widget_referrer": "origin" as AnyObject
    ]

    static let songCellHeight: CGFloat = 150.0

    static let recordCellHeight: CGFloat = 80.0

    static let forwardStep = 5.0

    static let backStep = -5.0
}

extension LSConstants {
    struct Localization {

        static let edit = "LSEdit"

        static let editPlaceHolder = "LSEditPlaceHolder"

        static let editTitle = "LSEditTitle"

        static let delete = "LSDelete"

        static let alertTitle = "LSAlertTitle"

        static let confirm = "LSconfirm"

        static let cancel = "LSCancel"

        static let remind = "LSRemind"

        static let remindMessage = "LSRemindMessage"

    }

    struct InstagramAPI {

        static let SCHEMEURL = "instagram-stories://share"

        static let AUTHURL = "https://api.instagram.com/oauth/authorize/"

        static let APIURL = "https://api.instagram.com/v1/users"

        static let CLIENT_ID = "cf3b2b7402c94fbcb572a56415b0254f"

        static let CLIENTSERCRET = "ed7b9142ed8749acb66b9bd9a12e4452"

        static let REDIRECT_URI = "http://localhost"
        static let ACCESS_TOKEN = "access_token"

        static let SCOPE = "https://www.instagram.com/developer/authorization/"
    }

    struct Activity {
        static let ActivityTypeView = "com.LetSing.Sam.view"

        static let ActivitySongsKey = "songs.key"
    }
}
