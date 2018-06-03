//
//  UIDevice+Sam.swift
//  LetSing
//
//  Created by MACBOOK on 2018/6/3.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

extension UIDevice {
    public func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }

        return false
    }
}
