//
//  VideoPanelView.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/30.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit
import AVFoundation

class LSVideoPanelView: UIView {

    @IBOutlet weak var playerView: LSPlayerView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updatePlayer(player: AVPlayer) {
        playerView.player = player
    }
}
