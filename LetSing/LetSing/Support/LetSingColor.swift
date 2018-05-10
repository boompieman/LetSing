//
//  LetSingColor.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/2.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

enum LetSingColor: String {

    case navigationBar = "D7443E"

    case gradientPurple = "7830B8"

    case gradientBlue = "33A4CC"

    case lightGray = "E7E7E7" // 231, 231, 231

    case darkGray = "CDCDCD"  // 205, 205, 205

    case loadMoreButton = "727272" // 114, 114, 114

    case pictureBackground = "D8D8D8"

    case tabBarTintColor = "7436B9"

    case textColor = "1F1F1F"

    func color() -> UIColor {

        var cString: String = self.rawValue.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 244) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 182) / 255.0,
            blue: CGFloat((rgbValue & 0x0000FF) >> 66) / 255.0,
            alpha: CGFloat(1.0)
        )

    }

}
