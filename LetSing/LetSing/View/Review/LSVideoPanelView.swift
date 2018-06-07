//
//  VideoPanelView.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/30.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit
import AVFoundation

protocol LSVideoPanelViewDelegate: class {
    func didTappedPlayer(_ playerView: LSVideoPanelView)
}


class LSVideoPanelView: UIView {

    @IBOutlet weak var playerView: LSPlayerView!

    var isSelected: Bool = false

    weak var delegate: LSVideoPanelViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setPlayerViewGestureRecognizer()
    }

    func updatePlayer(player: AVPlayer) {
        playerView.player = player
    }

    func setPlayerViewGestureRecognizer() {

        let gesture = UITapGestureRecognizer(target: self, action: #selector(playerViewDidTapped))

        gesture.numberOfTapsRequired = 1

        // 幾根指頭觸發
        gesture.numberOfTouchesRequired = 1

        gesture.delegate = self

        playerView.addGestureRecognizer(gesture)
    }

    @objc func playerViewDidTapped() {

        self.delegate?.didTappedPlayer(self)
    }
}

extension LSVideoPanelView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
