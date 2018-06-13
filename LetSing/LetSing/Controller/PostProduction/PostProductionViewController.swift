//
//  PostProductionViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/15.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit
//import Photos
//import AVFoundation
//import AudioKit

class PostProductionViewController: UIViewController {

    let transformatter = AudioTransformatter()
    let manager = RecordManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        deleteLocalFile()

//        writeRecord()
    }

    func deleteLocalFile() {

        transformatter.getRecoringViedoURL { (url) in

            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString

            let destinationPath = documentsPath.appendingPathComponent(url.absoluteString)

            print(destinationPath)

            do {
                try FileManager.default.removeItem(atPath: destinationPath)
            } catch let error {
                print("delete failed because of \(error)")
            }
        }
    }

    func writeRecord() {

        transformatter.getRecoringViedoURL { (url) in
            self.manager.writeRecordToRealm(videoUrl: url)

            DispatchQueue.main.async {

                guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }

                delegate.window?.rootViewController = UIStoryboard.mainStoryboard().instantiateInitialViewController()
            }
        }
    }
}
