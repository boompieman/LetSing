//
//  LoadingView.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/14.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import UIKit


class LoadingView: UIView {

    @IBOutlet weak var loadingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setLoadingAnimation()
    }

//    func removeView() {
//
//        UIView.animate(withDuration: 0.5, animations: { () in
//            self.alpha = 0
//        })
//
//        self.removeFromSuperview()
//    }

    func setLoadingAnimation() {

        UIView.animate(withDuration: 0.85, delay: 0, options: [.autoreverse, .repeat], animations: { () in
            self.loadingLabel.alpha = 0
        })
    }
}

