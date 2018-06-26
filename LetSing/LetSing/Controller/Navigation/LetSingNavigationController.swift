//
//  LetSingNavigationController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/2.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

class LetSingNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = .init(rawValue: 0)
        setupShadow()
    }

    private func setupShadow() {

        self.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        self.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.navigationBar.layer.shadowRadius = 5
        self.navigationBar.layer.shadowOpacity = 1

    }
}
