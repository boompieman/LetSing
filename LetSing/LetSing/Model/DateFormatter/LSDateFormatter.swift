//
//  LSDateFormatter.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/30.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation


// 測format是不是我要的format
protocol LSDateFormatterUsable {
    var format: String { get }
}

struct LSDateFormat: LSDateFormatterUsable {
    var format: String {
        return LSConstants.dateFormat
    }
}

class LSDateFormatter {

    private let dateFormatter = DateFormatter()

    private let format: String

    //Dependency Injection
    init(with usable: LSDateFormatterUsable) {
        self.format = usable.format
    }

    func getCurrentTime() -> String {

        self.dateFormatter.dateFormat = format

        let date = Date()

        let dateString = self.dateFormatter.string(from: date)

        return dateString
    }

    func getDateTime(date: Date) -> String {
        self.dateFormatter.dateFormat = format

        let dateString = self.dateFormatter.string(from: date)

        return dateString

    }
}
