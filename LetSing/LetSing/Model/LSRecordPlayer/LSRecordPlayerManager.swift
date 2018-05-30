//
//  LSRecordProvider.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/14.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit
import ReplayKit

// manager protocol to notify controller when to start or end
protocol ScreenCaptureManagerDelegate: class{
    func didStartRecord() // 開始錄製
    func didFinishRecord(preview: UIViewController) // 完成錄製
    func didStopWithError(error: Error) //發生錯誤
}

class LSRecordPlayerManager: NSObject {

    let recorder = RPScreenRecorder.shared()

    weak var delegate: ScreenCaptureManagerDelegate?
    // play music using speaker
    let audioSession = AVAudioSession.sharedInstance()

    var assetWriter: AVAssetWriter!
    var videoInput: AVAssetWriterInput!

    func setLSAudioCategory(isActive flag: Bool) {

        do {
            // 需要使用者打開手機旁邊的音源鍵，不然不會有聲音...
            try self.audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            
            try self.audioSession.setActive(flag)
        } catch {
            print(error)
        }
    }

    func generateRecorder() -> RPScreenRecorder {
        return recorder
    }

    private func isSystemVersionSupport() -> Bool {

//        guard let floatSystemVersion = Float(UIDevice.current.systemVersion) else {
//            print(UIDevice.current.systemVersion)
//            return false
//        }
//
//        if floatSystemVersion < Float(9) {
//            AlertManager.shared.showAlert(with: "提醒您", message: "請升級iOS系統至9.0，否則無法錄影", completion: {
//                return false
//            })
//        }
        return true
    }

    private func isRecorderAvailable() -> Bool {
//        if !recorder.isAvailable{
//            AlertManager.shared.showAlert(with: "提醒您", message: "您的手機的錄製功能目前有問題") {
//                return false
//            }
//        }
        return true
    }

    // MARK: recorder action
//    func start() {
//
//        self.recorder.delegate = self
//
//        if isSystemVersionSupport() || isRecorderAvailable() {
//            if !self.recorder.isRecording {
//
//                self.recorder.isMicrophoneEnabled = true
//
//
//
//                self.recorder.isCameraEnabled = true
//
//
//
//                self.recorder.startRecording { (error) in
//
//                    if let error = error {
//                        self.delegate?.didStopWithError(error: error)
//                    }
//
//
//                    self.delegate?.didStartRecord()
//                }
//            }
//        }
//    }

    // using startCapture
    func start() {
        self.recorder.delegate = self

        let fileURL = URL(fileURLWithPath: LSRecordFileManager.shared.filePath("test2"))
        assetWriter = try! AVAssetWriter(outputURL: fileURL, fileType: .mp4)


        

//        if self.recorder.isAvailable || !self.recorder.isRecording {
//
//            self.recorder.isMicrophoneEnabled = true
////                self.recorder.isCameraEnabled = true
//
//            self.recorder.startCapture(handler: { (sampleBuffer, sampleBufferType, error) in
//
//
//
//            }) { (error) in
//                print("error:", error)
//            }
//        }
    }

    func stop() {

        if self.recorder.isRecording {

            recorder.stopRecording { (previewController, error) in
                
                if let previewController = previewController {

                    self.delegate?.didFinishRecord(preview: previewController)

                }
                if let error = error {
                    print(error)
                }
            }
        }
    }

    func discard() {

        recorder.stopRecording { (preViewController, error) in
            self.recorder.discardRecording {
                print("did discard")
            }
        }
    }
}

extension LSRecordPlayerManager: RPScreenRecorderDelegate {

    func screenRecorder(
        _ screenRecorder: RPScreenRecorder,
        didStopRecordingWith previewViewController: RPPreviewViewController?,
        error: Error?
        )
    {
        if let error = error {
            self.delegate?.didStopWithError(error: error)
        }
    }
}
