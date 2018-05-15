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
import AudioKit


class userProfileViewController: UIViewController, YouTubePlayerDelegate {

    let recorder = RPScreenRecorder.shared()

    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    fileprivate var silence: AKBooster!
    var timer: Timer?
    var waitTimer: Timer?

    var oscillator: AKOscillator!
    var filter: AKLowPassFilter!
    var envelope: AKAmplitudeEnvelope!

    @IBOutlet weak var YoutubeView: YouTubePlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
//
//        waitTimer = Timer.scheduledTimer(
//            timeInterval: 1,
//            target: self,
//            selector: #selector(updateProgressLinear),
//            userInfo: nil,
//            repeats: true
//        )


        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        tracker = AKFrequencyTracker(mic)
        silence = AKBooster(tracker, gain: 0)




//        YoutubeView.isUserInteractionEnabled = false
//
//        YoutubeView.delegate = self
//
//
//
//
//
//
//
//
//
//
//        YoutubeView.playerVars = ["playsinline": 1 as AnyObject,
//                                  "showinfo": 0 as AnyObject,
//                                  "controls": 1 as AnyObject,
//
////                                  "start": 120 as AnyObject, // 單位：sec
////                                  "autoplay": 1 as AnyObject,
//                                  "iv_load_policy": 3 as AnyObject,
//                                  "modestbranding": 1 as AnyObject,
//                                  "enablejsapi": 1 as AnyObject,
////                                  "end": 5 as AnyObject   // end in 5th second
//        ]
//
//        YoutubeView.loadVideoID("T0LfHEwEXXw")

    }

    @objc func updateProgressLinear() {

        print(tracker.frequency)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        AudioKit.output = silence
        try! AudioKit.start()
    }

    @IBAction func recordBtnTapped(_ sender: UIButton) {

        tracker.start()
        print(tracker.frequency)

//        recorder.isMicrophoneEnabled = true
//
//        recorder.startRecording { (error) in
//            if let error = error {
//                print(error)
//            }
//        }
    }

    @IBAction func stopBtnTapped(_ sender: Any) {

        mic.stop()

//        recorder.stopRecording { (previewVC, error) in
//            if let previewVC = previewVC {
//                previewVC.previewControllerDelegate = self
//                self.present(previewVC, animated: true, completion: nil)
//            }
//            if let error = error {
//                print(error)
//            }
//        }
    }


    func playerReady(_ videoPlayer: YouTubePlayerView) {

//        videoPlayer.play()

//        duration = Int(videoPlayer.getDuration()!)

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
