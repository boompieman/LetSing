//
//  SongSearch.swift
//  LetSing
//
//  Created by MACBOOK on 2018/7/5.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import CoreSpotlight
import MobileCoreServices
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

    func loadPicture() -> UIImage {

        guard let imageData = try? Data(contentsOf: URL(string: image)!) else { return UIImage() }

        print(imageData)

        return UIImage(data: imageData)!


    }
}
