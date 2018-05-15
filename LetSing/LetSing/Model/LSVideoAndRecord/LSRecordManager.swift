//
//  LSRecordProvider.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/14.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import AVFoundation
import ReplayKit

// 自定义录屏manager协议
protocol ScreenCaptureManagerDelegate: class{
    func didStartRecord() // 正在录制
    func didFinishRecord(preview: UIViewController) // 完成录制
    func didStopWithError(error: NSError) //发生错误停止录制
    func savingRecord() // 保存
    func discardingRecord() // 取消保存
}

class LSRecordManager {

    let recorder = RPScreenRecorder.shared()

    weak var delegate: ScreenCaptureManagerDelegate?
    // play music using speaker
    let audioSession = AVAudioSession.sharedInstance()

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

    // MARK: recorder action
    func start() {
        if !self.recorder.isRecording {
            print("record start")
            self.recorder.isMicrophoneEnabled = true
            self.recorder.startRecording { (error) in

                if let error = error {
                    print(error)
                }
            }
        }
    }

    func stop(_ controller: RPPreviewViewControllerDelegate, present: @escaping (UIViewController) -> Void) {
        if self.recorder.isRecording {
            recorder.stopRecording { (previewController, error) in
                if let previewVC = previewController {

                    previewVC.previewControllerDelegate = controller

                    present(previewVC)
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
                print("discarding")
            }
        }
    }
}
