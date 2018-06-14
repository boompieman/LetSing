//
//  LSDateFormatter.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/30.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation


// 測format是不是我要的format
// 測getCurrentTime是否回傳正確的值
//protocol LSDateFormatterUsable {
//    var format: String { get }
//    func getCurrentTime()


class LSDateFormatter {

    private let dateFormatter = DateFormatter()

    let format: String

    //Dependency Injection
    init(format: String = LSConstants.dateFormat) {

        self.format = format

    }

    func getCurrentTime() -> String {

        self.dateFormatter.dateFormat = format

        let date = Date()

        let interval = date.timeIntervalSince1970

        let dateString = self.dateFormatter.string(from: date)

        return dateString
    }
}
