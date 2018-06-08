//
//  UIViewController+Sam.swift
//  LetSing
//
//  Created by MACBOOK on 2018/6/6.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

extension UIViewController {

    func add(_ child: UIViewController) {
        addChildViewController(child)
        child.didMove(toParentViewController: self)
    }

    func remove() {
        guard parent != nil else {
            return
        }

        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}
