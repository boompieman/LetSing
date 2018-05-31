//
//  FileUtli.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/30.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation

class LSRecordFileManager {

    static let shared = LSRecordFileManager()

    private func createFolder() {

        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        if let documentDirectoryPath = documentDirectoryPath {
            // create the custom folder path
            let recordDirectoryPath = documentDirectoryPath.appending("/Records")
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: recordDirectoryPath) {
                do {
                    try fileManager.createDirectory(atPath: recordDirectoryPath,
                                                    withIntermediateDirectories: false,
                                                    attributes: nil)
                } catch {
                    print("Error creating record folder in documents dir: \(error)")
                }
            }
        }
    }

    func newRecordFilePath() -> String {
        createFolder()

        let dateFormatter = LSDateFormatter()


        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = path[0]

        let filePath: String = "\(documentsDirectory)/Records/\(dateFormatter.getCurrentTime()).mp4"
        return filePath
    }

    func fetchAllRecords() -> [URL] {

        createFolder()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        let recordPath = documentsDirectory?.appendingPathComponent("/Records")

        let directoryContents = try! FileManager.default.contentsOfDirectory(at: recordPath!, includingPropertiesForKeys: nil, options: [])

        return directoryContents
    }

    func deleteRecord(at filePath: URL) {
        if FileManager.default.fileExists(atPath: filePath.absoluteString) {
            try? FileManager.default.removeItem(at: filePath)
        }
    }

}
