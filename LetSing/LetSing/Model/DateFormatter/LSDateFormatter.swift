//
//  LSDateFormatter.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/30.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation

//protocol  {
//
//    func getCurrentTime(date: Date) -> String
//}

class LSDateFormatter {

    private let dateFormatter = DateFormatter()

    init(format: String = LSConstants.dateFormat) {

        self.dateFormatter.dateFormat = format
    }

    func getCurrentTime() -> String {

//        dateFormatter.dateFormat = LSConstants.dateFormat

        let date = Date()
        let interval = date.timeIntervalSince1970

        let dateString = self.dateFormatter.string(from: date)

        return dateString
    }
}
