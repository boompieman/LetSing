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

    func getCurrentTime() -> String {

        dateFormatter.dateFormat = LSConstants.dateFormat
        let date = Date()
        let interval = date.timeIntervalSince1970

        let dateString = dateFormatter.string(from: date)

        return dateString
    }
}
