//
//  lyrics.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/18.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation

struct Lyrics {
    let songId: String
    var lines: [Line]
}

struct Line {
    let words: String
    let start: Float
    let duration: Float
}
