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

    // anamation
    func startRecording() {

        DispatchQueue.main.async {

            self.isSelected = true
            UIView.animate(withDuration: 0.85, delay: 0, options: [.autoreverse, .repeat], animations: { () in
                self.titleLabel?.alpha = 0
            })
        }
    }

    func stopRecording() {

        DispatchQueue.main.async {
            self.layer.removeAllAnimations()
            self.isSelected = false
            self.titleLabel?.alpha = 1
            
        }
    }

}
