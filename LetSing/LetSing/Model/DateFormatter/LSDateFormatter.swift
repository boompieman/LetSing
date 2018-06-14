//
//  LSDateFormatter.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/30.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation

class LSDateFormatter {

    private let dateFormatter = DateFormatter()

    let formate: String

    //Dependency Injection
    init(format: String = LSConstants.dateFormat) {

        self.formate = LSConstants.dateFormat
    }

    func getCurrentTime() -> String {

        dateFormatter.dateFormat = self.formate

        let date = Date()

        let interval = date.timeIntervalSince1970

        let dateString = dateFormatter.string(from: date)

        return dateString
    }
}
