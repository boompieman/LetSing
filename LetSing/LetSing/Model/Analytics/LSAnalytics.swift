
//
//  LSAnalytics.swift
//  LetSing
//
//  Created by MACBOOK on 2018/6/4.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import FirebaseAnalytics

class LSAnalytics {

    static let shared = LSAnalytics()

    func logEvent(_ name: String, parameters: [String: Any]?) {
        Analytics.logEvent(name, parameters: parameters)
    }
}
