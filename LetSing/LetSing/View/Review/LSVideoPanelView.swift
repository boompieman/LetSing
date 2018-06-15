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

    func didSwipePlayer(_ playerView: LSVideoPanelView)
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

        let tappedGesture = generateTappedGesture()
        let swipeRightGesture = generateSwipeGuesture(direction: .right)

        playerView.addGestureRecognizer(swipeRightGesture)
        playerView.addGestureRecognizer(tappedGesture)
    }

    // MARK: - private func
    private func generateSwipeGuesture(direction: UISwipeGestureRecognizerDirection) -> UISwipeGestureRecognizer {

        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(playerViewDidSwipeLeft))

        gesture.delegate = self

        gesture.direction = direction

        return gesture
    }

    @objc func playerViewDidSwipeLeft() {
        self.delegate?.didSwipePlayer(self)
    }

    private func generateTappedGesture() -> UITapGestureRecognizer {

        let gesture = UITapGestureRecognizer(target: self, action: #selector(playerViewDidTapped))

        gesture.numberOfTapsRequired = 1

        gesture.numberOfTouchesRequired = 1

        gesture.delegate = self

        return gesture

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
