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

    func fetchAllRecords() -> [Record] {

        createFolder()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        let recordPath = documentsDirectory?.appendingPathComponent("/Records")

        let directoryContents = try! FileManager.default.contentsOfDirectory(at: recordPath!, includingPropertiesForKeys: nil, options: [])

        var recordArray = [Record]()

        for url in directoryContents {
            let record = Record(title: String(url.absoluteString.components(separatedBy: "/").last!), user: nil, videoUrl: url, createdTime: "not yet done")
            recordArray.append(record)
        }

        return recordArray
    }

    func updateRecordTitle(from fromPath: URL,to toPath: String) {

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        let recordPath = documentsDirectory?.appendingPathComponent("/Records")

        print("rrrrr:", recordPath)

        let pathString = (recordPath?.absoluteString)! + toPath

        let newURL = URL(string: pathString)



        try? FileManager.default.moveItem(at: fromPath, to: newURL!)
    }



    func deleteRecord(at filePath: URL) {

        try? FileManager.default.removeItem(at: filePath)
    }

}
