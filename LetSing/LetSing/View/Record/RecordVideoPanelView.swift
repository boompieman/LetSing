//
//  RecordVideoPanel.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/8.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import AVFoundation
import UIKit
import YouTubePlayer

protocol LSVideoPanelViewDelegate: class {
    func didTappedPlayer(playerView: YouTubePlayerView)
}

class RecordVideoPanelView: UIView {

    @IBOutlet weak var videoPlayerView: YouTubePlayerView!

    @IBOutlet weak var recordingProgress: UISlider!
    @IBOutlet weak var timeStartLabel: UILabel!
    @IBOutlet weak var timeEndLabel: UILabel!

    weak var delegate: LSVideoPanelViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setPlayerViewGestureRecognizer()
    }


    func updateEndTime(time: String) {

        timeEndLabel.text = time
    }

    func updateCurrentTime(time: String, proportion: Double) {
        timeStartLabel.text = time

        recordingProgress.value = Float(proportion)
    }

    func updatePlayer() {

        videoPlayerView.clear()

        videoPlayerView.isUserInteractionEnabled = true

        updateEndTime(time: LSConstants.PlayerTime.originTime)

        updateCurrentTime(time: LSConstants.PlayerTime.originTime, proportion: LSConstants.PlayerTime.originProportion)
    }

    func playerDidStopWithError(error: Error) {
        //TODO
    }

    func setPlayerViewGestureRecognizer() {

        let gesture = UITapGestureRecognizer(target: self, action: #selector(playerViewDidTapped))

        gesture.numberOfTapsRequired = 1

        // 幾根指頭觸發
        gesture.numberOfTouchesRequired = 1

        gesture.delegate = self

        videoPlayerView.addGestureRecognizer(gesture)
    }

    @objc func playerViewDidTapped() {

        self.delegate?.didTappedPlayer(playerView: videoPlayerView)
    }
}

extension RecordVideoPanelView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


