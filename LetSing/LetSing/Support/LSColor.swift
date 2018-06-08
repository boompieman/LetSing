//
//  LetSingColor.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/2.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

enum LSColor {

    case brand

    case type 

    func color() -> String {
        switch self {
        case .brand:
            return "Brand"
        case .type:
            return "Type"
        }
    }
}
