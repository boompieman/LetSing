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


protocol ScreenCaptureManagerDelegate: class {
    func didStartRecord()
    func didFinishRecord()
    func didStopWithError(error: Error)
}

class LSRecordPlayerManager: NSObject {

    weak var delegate: ScreenCaptureManagerDelegate?

    private let recorder = RPScreenRecorder.shared()
    private var song: Song?

    private let audioSession = AVAudioSession.sharedInstance()
    private var assetWriter: AVAssetWriter!
    private var videoInput: AVAssetWriterInput!
    private var audioInput: AVAssetWriterInput!
    private var microInput: AVAssetWriterInput!

    private var queue = DispatchQueue(label: String(describing: LSRecordPlayerManager.self))

    func setLSAudioCategory(isActive flag: Bool) {

        do {
            // 需要使用者打開手機旁邊的音源鍵，不然不會有聲音...
            try self.audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)

            try self.audioSession.setActive(flag)
        } catch {
            self.delegate?.didStopWithError(error: error)
        }
    }

    func updateSong(song: Song) {
        self.song = song
    }

    // start recording
    func start() {

        setupAssetWriter()

        self.recorder.delegate = self

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
                            return
                        }

                        if strongSelf.assetWriter.status == AVAssetWriterStatus.unknown {

                            strongSelf.assetWriter.startWriting()
                            strongSelf.assetWriter.startSession(
                                atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
                        }

                        switch sampleBufferType {
                        case .video:
                            if strongSelf.videoInput.isReadyForMoreMediaData {
                                print("videoInput")
                                strongSelf.videoInput.append(sampleBuffer)
                            }
                        case .audioApp:
                            if strongSelf.audioInput.isReadyForMoreMediaData {
                                print("audioInput:", strongSelf.audioInput.preferredVolume)
                                strongSelf.audioInput.append(sampleBuffer)
                            }
                        case .audioMic:
                            if strongSelf.recorder.isMicrophoneEnabled && strongSelf.microInput.isReadyForMoreMediaData {
                                print("microInput:", strongSelf.microInput.preferredVolume)
                                strongSelf.microInput.append(sampleBuffer)
                            }
                        }
                    }
                }
            }) { (error) in
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
                        DispatchQueue.main.async {
                            self.delegate?.didFinishRecord()
                        }
                    }
                }
            }
        }
    }

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

    // MARK: private func
    private func setupAssetWriter() {

        let fileURL = URL(fileURLWithPath: LSRecordFileManager.shared.newRecordFilePath())
        
        do {
            assetWriter = try AVAssetWriter(outputURL: fileURL, fileType: .mp4)
        } catch {
            return
        }

        let videoOutputSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: UIScreen.main.bounds.width,
            AVVideoHeightKey: UIScreen.main.bounds.height
        ]

        var acl: AudioChannelLayout!
        bzero(&acl, MemoryLayout.size(ofValue: acl))
        acl.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo

        let audioOutputSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100,
            AVChannelLayoutKey: NSData(bytes: &acl, length: MemoryLayout.size(ofValue: acl))
        ]

        let microOutputSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100,
            AVChannelLayoutKey: NSData(bytes: &acl, length: MemoryLayout.size(ofValue: acl))
        ]

        audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioOutputSettings)
        audioInput.preferredVolume = 0
        microInput = AVAssetWriterInput(mediaType: .audio, outputSettings: microOutputSettings)
        microInput.preferredVolume = 1.0

        videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoOutputSettings)

        videoInput.preferredVolume = 0

        videoInput.expectsMediaDataInRealTime = true
        audioInput.expectsMediaDataInRealTime = true
        microInput.expectsMediaDataInRealTime = true

        assetWriter.add(videoInput)
        assetWriter.add(audioInput)
        assetWriter.add(microInput)
    }
}

extension LSRecordPlayerManager: RPScreenRecorderDelegate {

    func screenRecorderDidChangeAvailability(_ screenRecorder: RPScreenRecorder) {

    }

    func screenRecorder(
        _ screenRecorder: RPScreenRecorder,
        didStopRecordingWith previewViewController: RPPreviewViewController?,
        error: Error?
        ) {
        if let error = error {
            self.delegate?.didStopWithError(error: error)
        }
    }
}
