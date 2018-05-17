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
import AssetsLibrary

// 自定义录屏manager协议
protocol ScreenCaptureManagerDelegate: class{
    func didStartRecord() // 開始錄製
    func didFinishRecord(preview: UIViewController) // 完成錄製
    func didStopWithError(error: Error) //發生錯誤
    func savingRecord() // 保存
    func discardingRecord() // 取消保存
}

class LSRecordManager: NSObject {

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
        self.recorder.delegate = self
        if !self.recorder.isRecording {
            self.recorder.isMicrophoneEnabled = true
            self.recorder.startRecording { (error) in

                self.delegate?.didStartRecord()

                if let error = error {
                    print(error)
                }
            }
        }
    }

    func stop() {

        if self.recorder.isRecording {

            recorder.stopRecording { (previewController, error) in
                
                if let previewController = previewController {

                    previewController.previewControllerDelegate = self

                    self.delegate?.didFinishRecord(preview: previewController)

                }
                if let error = error {
                    print(error)
                }
            }
        }
    }

    func discard() {

        print(self.recorder.isRecording)

        recorder.stopRecording { (preViewController, error) in
            self.recorder.discardRecording {
                print("did discard")
            }
        }
    }
}

extension LSRecordManager: RPScreenRecorderDelegate {

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

extension LSRecordManager: RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(previewController: RPPreviewViewController) {
        print("previewControllerDidFinish")
        DispatchQueue.main.async {
            self.delegate?.discardingRecord() // 取消保存
        }
    }

    func previewController(previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {

        print("enter to delegate 2")

        if activityTypes.contains(UIActivityType.saveToCameraRoll.rawValue) {
            DispatchQueue.main.async {

                guard let controller = UIStoryboard.mainStoryboard().instantiateViewController(
                    withIdentifier: String(describing: TabBarViewController.self)
                    ) as? TabBarViewController else { return }

                previewController.present(controller, animated: false, completion: nil)

                self.delegate?.savingRecord() // 正在保存
            }
        }
    }
}
