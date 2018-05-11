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
                                  "origin": "https://www.example.com" as AnyObject
//                                  "end": 5 as AnyObject   // end in 5th second
        ]

        YoutubeView.loadVideoID("T0LfHEwEXXw")

    }

    func playerReady(_ videoPlayer: YouTubePlayerView) {
        YoutubeView.play()

        print(videoPlayer.getDuration())
        print("record")
        // put record
    }

    @IBAction func recordBtnTapped(_ sender: UIButton) {

        recorder.isMicrophoneEnabled = true

        recorder.startCapture(handler: { (cmSampleBuffer, rpSampleType, error) in
            switch rpSampleType {
            case .audioApp:
                print("audio")
            case .audioMic:
                print("mic")
            case .video:
                print("video")

            }
        }) { (error) in
            print(error)
        }

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
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {


        print("aaaaaa",playerState)
        switch playerState {
        case .Playing:
            print("playing")
        case .Ended:
            // record end
            print("Ended")
        default:
            print("nothing")
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
