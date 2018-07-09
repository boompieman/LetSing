//
//  SongSpotlight.swift
//  LetSing
//
//  Created by MACBOOK on 2018/7/5.
//  Copyright © 2018年 MACBOOK. All rights reserved.


import CoreSpotlight
import MobileCoreServices // 使用統一的type id，如此可以在app與app間傳遞資訊
import UIKit

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

    public var attributeSet: CSSearchableItemAttributeSet {

        let attributeSet = CSSearchableItemAttributeSet(
            itemContentType: kUTTypeContact as String)

        attributeSet.title = name

        attributeSet.authorEmailAddresses = ["aaaaa@gmail.com"]

        attributeSet.thumbnailData = UIImageJPEGRepresentation(
            loadPicture(), 0.9)

        if singer != nil {
            attributeSet.keywords = [singer!, name]
        } else {
            attributeSet.keywords = [name]
        }

        return attributeSet
    }

    public var userActivity: NSUserActivity {
        let activity = NSUserActivity(activityType: Song.domainIdentifier)
        activity.userInfo = userActivityUserInfo

        activity.contentAttributeSet = attributeSet
        return activity
    }


    // 可用 extension
    func loadPicture() -> UIImage {

        guard let imageData = try? Data(contentsOf: URL(string: image)!) else { return UIImage() }

        return UIImage(data: imageData)!
    }
}
