//
//  UserProfileViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/2.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import AVFoundation
import UIKit
import YouTubePlayer
import ReplayKit


class userProfileViewController: UIViewController, YouTubePlayerDelegate {

    let recorder = RPScreenRecorder.shared()




    

    @IBOutlet weak var YoutubeView: YouTubePlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()





//        YoutubeView.isUserInteractionEnabled = false

        YoutubeView.delegate = self










        YoutubeView.playerVars = ["playsinline": 1 as AnyObject,
                                  "showinfo": 0 as AnyObject,
                                  "controls": 1 as AnyObject,

//                                  "start": 120 as AnyObject, // 單位：sec
//                                  "autoplay": 1 as AnyObject,
                                  "iv_load_policy": 3 as AnyObject,
                                  "modestbranding": 1 as AnyObject,
                                  "enablejsapi": 1 as AnyObject,
//                                  "end": 5 as AnyObject   // end in 5th second
        ]

        YoutubeView.loadVideoID("T0LfHEwEXXw")

    }

    @IBAction func recordBtnTapped(_ sender: UIButton) {

        recorder.isMicrophoneEnabled = true

        recorder.startRecording { (error) in
            if let error = error {
                print(error)
            }
        }
    }

    @IBAction func stopBtnTapped(_ sender: Any) {

        recorder.stopRecording { (previewVC, error) in
            if let previewVC = previewVC {
                previewVC.previewControllerDelegate = self
                self.present(previewVC, animated: true, completion: nil)
            }
            if let error = error {
                print(error)
            }
        }
    }
    var timer: Timer?
    var duration: Int?

    func startTimer() {

        timer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(observeIfLoaded),
            userInfo:nil,
            repeats:true
        )
    }

    @objc func observeIfLoaded() {



    }

    func playerReady(_ videoPlayer: YouTubePlayerView) {

//        videoPlayer.play()

        duration = Int(videoPlayer.getDuration()!)

        print("ready to play")
        // put record
    }

    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {


        print("aaaaaa",playerState)
        switch playerState {

        case .Unstarted:
            break
//            videoPlayer.play()
//            videoPlayer.pause()

        case .Buffering:
            break
        case .Playing:
            break
        case .Ended:
            // record end
            break
        default:
            break
        }
    }


    func playerQualityChanged(_ videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {

        print("bbbbb", playbackQuality)

    }
}

extension userProfileViewController: RPPreviewViewControllerDelegate {

    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true, completion: nil)
    }
}
