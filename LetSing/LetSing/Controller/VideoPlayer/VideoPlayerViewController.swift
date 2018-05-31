//
//  VideoPlayer.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/30.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

class VideoPlayerViewController: UIViewController {

    private static var observerContext = 0

    @IBOutlet weak var videoPanelView: LSVideoPanelView!

    var videoURL: URL?

    let videoProvider = LSVideoProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()

        videoProvider.play()
    }

    func setupPlayer() {
        guard let url = videoURL else {

            return }

        guard let player = videoProvider.generatePlayer(url: url) else {

            return }

        videoPanelView.updatePlayer(player: player)
    }

}
