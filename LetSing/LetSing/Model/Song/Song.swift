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

