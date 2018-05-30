//
//  UIStoryboard+Sam.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/2.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

extension UIStoryboard {

    static func discoverStoryboard() -> UIStoryboard {

        return UIStoryboard(name: "Discover", bundle: nil)
    }

    static func loginStoryboard() -> UIStoryboard {

        return UIStoryboard(name: "Login", bundle: nil)
    }

    static func searchStoryboard() -> UIStoryboard {

        return UIStoryboard(name: "Search", bundle: nil)
    }

    static func mainStoryboard() -> UIStoryboard {

        return UIStoryboard(name: "Main", bundle: nil)
    }

    static func userProfileStoryboard() -> UIStoryboard {

        return UIStoryboard(name: "UserProfile", bundle: nil)
    }

    static func recordStoryboard() -> UIStoryboard {

        return UIStoryboard(name: "Record", bundle: nil)
    }

    static func postProductionStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "PostProduction", bundle: nil)
    }
}
