//
//  EndRecordButton.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/24.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import UIKit

class EndRecordButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()

        setupButton()
    }

    func setupButton() {

        self.layer.cornerRadius = 5

    }

}
