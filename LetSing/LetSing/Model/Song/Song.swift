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
    let singer: String?
    let image: String
    var hasCaption: Bool
    let rank: Int?
    var type: String? // chinese, english, holiday ...
}

