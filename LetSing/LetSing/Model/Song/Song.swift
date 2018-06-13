//
//  Song.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/4.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

struct Song: Codable {
    var id: String
    var name: String
    var singer: String?
    var image: String
    var rank: Int?
    var type: LSSongType? // chinese, english, holiday ...
}

class SongObject: Object {

    @objc dynamic var typeString: String?

    var type: LSSongType? {
        get {
            guard let typeRaw = typeString else { return nil }
            return LSSongType(rawValue: typeRaw)
        }
        set(newValue) {
            guard let newValue = newValue else { return typeString = nil }
            typeString = newValue.rawValue
        }
    }

    @objc dynamic var structData: Data?

    var song: Song? {
        get {
            if let data = structData {
                return try? JSONDecoder().decode(Song.self, from: data)
            }
            return nil
        }
        set {
            structData = try? JSONEncoder().encode(newValue)
        }
    }
}

enum LSSongType: String, Codable {

    case chinese = "holiday_chinese_hot"

    case english = "holiday_english_hot"

    case guan = "holiday_guan_hot"

    case japanese = "holiday_japanese_hot"

    case taiwanese = "holiday_taiwanese_hot"

    func title() -> String {
        switch self {
        case .chinese:
            return "中文熱門"
        case .english:
            return "英文熱門"
        case .guan:
            return "粵語熱門"
        case .japanese:
            return "日語熱門"
        case .taiwanese:
            return "台語熱門"
        }
    }
}
