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

            let date = getFileCreateTime(url: url)

            guard let title = String(url.absoluteString.components(separatedBy: "/").last!).removingPercentEncoding else {
                return recordArray
            }


            let record = Record(title: title, user: nil, videoUrl: url, createdTime: date)
            print("aaaaaa:",record.createdTime)
            recordArray.append(record)
        }

        return recordArray
    }

    func updateRecordTitle(from fromPath: URL,to toPath: String) {

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
    private func getFileCreateTime(url: URL) -> Date? {

        do {

            let aFileAttributes = try FileManager.default.attributesOfItem(atPath: url.absoluteString.components(separatedBy: ".").first!) as [FileAttributeKey:Any]

            if let date = aFileAttributes[FileAttributeKey.creationDate] as? Date {

                return date
            }
        } catch let error {
            print("rrrrrr:",error)
        }

        return nil
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
}
