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


class userProfileViewController: UIViewController, YouTubePlayerDelegate, AVAudioRecorderDelegate {


    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var recordButton: UIButton!

    @IBOutlet weak var YoutubeView: YouTubePlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        recordingSession = AVAudioSession.sharedInstance()

        do {
            print("aaa")
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("user allows to use mic")
                        self.loadRecordingUI()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }


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

    func loadRecordingUI() {
        recordButton = UIButton(frame: CGRect(x: 64, y: 300, width: 128, height: 64))
        recordButton.setTitle("Tap to Record", for: .normal)
        recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        view.addSubview(recordButton)
    }

    @objc private func recordTapped() {

        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        print(paths[0])

        return paths[0]
    }

    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

            recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }

    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }

    func playerReady(_ videoPlayer: YouTubePlayerView) {
        YoutubeView.play()

        print(videoPlayer.getDuration())
        print("record")
        // put record
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
