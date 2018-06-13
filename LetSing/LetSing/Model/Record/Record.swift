//
//  Record.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/25.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import RealmSwift

struct Record: Codable {

    var title: String

    var user: User?

    let videoUrl: URL

    let createdTime: Date?

}

class RecoedObject: Object {

    @objc dynamic var userId: String?

    @objc dynamic var videoUrlString: String?

    var videoUrl: URL? {
        get {
            if let urlString = videoUrlString {
                return URL(string: urlString)
            }
            return nil
        }
        set {
            videoUrlString = newValue?.absoluteString
        }
    }
}
