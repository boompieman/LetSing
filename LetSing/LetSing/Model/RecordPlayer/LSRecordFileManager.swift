//
//  FileUtli.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/30.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import AVFoundation
import Foundation

class LSRecordFileManager {

    static let shared = LSRecordFileManager()

    func newRecordFilePath() -> String {
        createFolder()

        let format = LSDateFormat()

        let dateFormatter = LSDateFormatter(with: format)

        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = path[0]

        let filePath: String = "\(documentsDirectory)/Records/\(dateFormatter.getCurrentTime()).mp4"
        return filePath
    }

    func fetchAllRecords() -> [Record] {

        createFolder()

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        let recordPath = documentsDirectory?.appendingPathComponent("/Records")

        guard let directoryContents =
            try? FileManager.default.contentsOfDirectory(
                at: recordPath!,
                includingPropertiesForKeys:[.contentModificationDateKey],
                options: .skipsHiddenFiles
            ) else { return [Record]()}

        var recordArray = [Record]()

        for url in directoryContents {

            let date = getFileCreateTime(url: url)

            guard let title = String(url.absoluteString.components(separatedBy: "/").last!.components(separatedBy: ".").first!).removingPercentEncoding else {
                return recordArray
            }

            let format = LSDateFormat()

            let dateFormatter = LSDateFormatter(with: format)

            let dateString = dateFormatter.getDateTime(date: date)

            let record = Record(title: title, user: nil, videoUrl: url, createdTime: date, createdTimeString: dateString)

            recordArray.append(record)
        }

        return recordArray.sorted(by: { (record1, record2) -> Bool in
            return record1.createdTime > record2.createdTime
        })
    }

    func updateRecordTitle(from fromPath: URL, to toPath: String) {

        if isBlankString(str: toPath) {
            return
        }

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        let recordPath = documentsDirectory?.appendingPathComponent("/Records")

        guard let encodeToPath = toPath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return
        }

        let pathString = (recordPath?.absoluteString)! + encodeToPath + ".mp4"

        let newURL = URL(string: pathString)

        do {
            try FileManager.default.moveItem(at: fromPath, to: newURL!)
        } catch(let error) {
            print(error)
        }
    }

    func deleteRecord(at filePath: URL) {

        do {
            try FileManager.default.removeItem(at: filePath)
        } catch(let error) {
            print(error)
        }
    }

    // MARK: private func
    private func getFileCreateTime(url: URL) -> Date {

        do {
            let date = try url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate ?? Date.distantPast

            return date

        } catch let error {

            print("error:", error)
        }

        return Date()
    }

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

    private func isBlankString(str: String) -> Bool {

        if str == nil {
            return true
        }

        if str.trimmingCharacters(in: .whitespaces).count == 0 {
            return true
        }

        return false

    }
}
