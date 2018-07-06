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

    var songData: Data? {
        get {
            return try? JSONEncoder().encode(self)
        }
    }

    public static let domainIdentifier = "com.appWorksSchool-ios6.LetSing.Song"

    public var userActivityUserInfo: [String: AnyObject] {

        return ["song" : songData as AnyObject]
    }

    public var userActivity: NSUserActivity {
        let activity = NSUserActivity(activityType: Song.domainIdentifier)
        activity.title = name
        activity.userInfo = userActivityUserInfo

        if singer != nil {
            activity.keywords = Set(arrayLiteral: name, singer!)
        } else {
            activity.keywords = Set(arrayLiteral: name)
        }
        return activity
    }
}
