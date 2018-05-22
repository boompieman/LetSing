//
//  Song.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/4.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation


struct Song {
    let id: String
    let name: String
    var singer: String?
    let image: String
    var rank: Int?
    var type: LSSongType? // chinese, english, holiday ...
}

enum LSSongType: String {

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
