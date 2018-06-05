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
    func didFinishRecord() // 完成錄製
    func didStopWithError(error: Error) //發生錯誤
}

class LSRecordPlayerManager: NSObject {

    let recorder = RPScreenRecorder.shared()

    weak var delegate: ScreenCaptureManagerDelegate?
    // play music using speaker
    let audioSession = AVAudioSession.sharedInstance()

    var assetWriter: AVAssetWriter!
    var videoInput: AVAssetWriterInput!
    var audioInput: AVAssetWriterInput!
    var microInput: AVAssetWriterInput!

    private var queue = DispatchQueue(label: "audio")

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

    // start recording
    func start() {

        self.recorder.delegate = self

        let fileURL = URL(fileURLWithPath: LSRecordFileManager.shared.newRecordFilePath())

        assetWriter = try! AVAssetWriter(outputURL: fileURL, fileType: .mp4)

        let videoOutputSettings: [String : Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: UIScreen.main.bounds.width,
            AVVideoHeightKey: UIScreen.main.bounds.height
        ]

        var acl:AudioChannelLayout!
        bzero(&acl, MemoryLayout.size(ofValue: acl))
        acl.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo

        let audioOutputSettings: [String : Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100,
            AVChannelLayoutKey: NSData(bytes: &acl, length: MemoryLayout.size(ofValue: acl))
        ]

        audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioOutputSettings)
        microInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioOutputSettings)
        videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoOutputSettings)

        videoInput.expectsMediaDataInRealTime = true
        audioInput.expectsMediaDataInRealTime = true
        microInput.expectsMediaDataInRealTime = true

        self.assetWriter.add(videoInput)
        self.assetWriter.add(audioInput)
        self.assetWriter.add(microInput)

        if self.recorder.isAvailable && !self.recorder.isRecording {

            self.recorder.isMicrophoneEnabled = true
//            self.recorder.isCameraEnabled = true
            self.delegate?.didStartRecord()

            self.recorder.startCapture(handler: { (sampleBuffer, sampleBufferType, error) in

                if let error = error {
                    self.delegate?.didStopWithError(error: error)
                    return
                }

                if CMSampleBufferDataIsReady(sampleBuffer) {

                    self.queue.async { [weak self] in

                        guard let strongSelf = self else { return }

                        if strongSelf.assetWriter.status == AVAssetWriterStatus.failed {

                            print("Error occured, status = \(strongSelf.assetWriter.status.rawValue), \(strongSelf.assetWriter.error!.localizedDescription) \(String(describing: strongSelf.assetWriter.error))")
                            return
                        }

                        if strongSelf.assetWriter.status == AVAssetWriterStatus.unknown {

//                            if !strongSelf.assetWriter.startWriting() {
//                                return
//                            }

                            strongSelf.assetWriter.startWriting()

                            strongSelf.assetWriter.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
                        }

                        switch sampleBufferType {
                        case .video:
                            if strongSelf.videoInput.isReadyForMoreMediaData {
                                print("videoInput")
                                strongSelf.videoInput.append(sampleBuffer)
                            }
                        case .audioApp:
                            if strongSelf.audioInput.isReadyForMoreMediaData {
                                print("audioInput")
                                strongSelf.audioInput.append(sampleBuffer)
                            }
                        case .audioMic:
                            if strongSelf.recorder.isMicrophoneEnabled && strongSelf.microInput.isReadyForMoreMediaData {
                                print("microInput")
                                strongSelf.microInput.append(sampleBuffer)
                            }
                        }
                    }
                }
            })
            { (error) in
                if let error = error {
                    self.delegate?.didStopWithError(error: error)
                }
            }
        }
    }

    func stop() {

        if self.recorder.isRecording {

            self.recorder.stopCapture { (error) in

                if let error = error {
                    self.delegate?.didStopWithError(error: error)
                }

                self.queue.async {
                    self.assetWriter.finishWriting {

                        self.delegate?.didFinishRecord()

                    }
                }
            }
        }
    }

//    func stop() {
//
//        if self.recorder.isRecording {
//
//            recorder.stopRecording { (previewController, error) in
//
//                if let previewController = previewController {
//
//                    self.delegate?.didFinishRecord(preview: previewController)
//
//                }
//                if let error = error {
//                    print(error)
//                }
//            }
//        }
//    }

    func discard() {

        self.recorder.stopCapture { (error) in

            if let error = error {
                self.delegate?.didStopWithError(error: error)
            }

            self.queue.async {
                self.assetWriter.cancelWriting()
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
