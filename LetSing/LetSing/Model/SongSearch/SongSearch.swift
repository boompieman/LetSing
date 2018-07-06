//
//  SongSearch.swift
//  LetSing
//
//  Created by MACBOOK on 2018/7/5.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import CoreSpotlight
import Foundation

extension Song {
    public static let domainIdentifier = "com.appWorksSchool-ios6.LetSing"

    public var userActivityUserInfo: [String: AnyObject] {
        return ["id" : id as AnyObject]
    }

    public var userActivity: NSUserActivity {
        let activity = NSUserActivity(activityType: Song.domainIdentifier)
        activity.title = name
        activity.userInfo = userActivityUserInfo

        activity.keywords = Set(arrayLiteral: name)
        return activity
    }
}
