//
//  VideoPlayer.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/30.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import AVFoundation
import UIKit

class VideoPlayerViewController: UIViewController {

    private static var observerContext = 0

    @IBOutlet weak var videoPanelView: LSVideoPanelView!

    override func viewDidLoad() {
         super.viewDidLoad()

        videoPanelView.backgroundColor = UIColor.blue
    }

}
