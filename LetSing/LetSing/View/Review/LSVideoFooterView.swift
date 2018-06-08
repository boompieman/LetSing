//
//  LSVideoFooterView.swift
//  LetSing
//
//  Created by MACBOOK on 2018/6/7.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

class LSVideoFooterView: UIView {

    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var rewindBtn: UIButton!
    @IBOutlet weak var fastForwardBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func playerDidPlay() {

        playBtn.isSelected = true

    }

    func isHidden(_ active: Bool) {

        self.playBtn.isHidden = active
        self.rewindBtn.isHidden = active
        self.fastForwardBtn.isHidden = active
        self.isHidden = active
    }
}
