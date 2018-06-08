//
//  RecordManager.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/25.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class RecordManager {

    private let queue = DispatchQueue(label: String(describing: RecordManager.self) + UUID().uuidString, qos: .default, attributes: .concurrent)

    func generateRealm() -> Realm {
        let url = URL(fileURLWithPath: RLMRealmPathForFile("recordData.realm"), isDirectory: false)
        var config = Realm.Configuration(fileURL: url)
        let realm = try! Realm(configuration: config)

        return realm
    }

    func writeRecordToRealm(videoUrl: URL) {

        queue.async {

            let realm = self.generateRealm()

            let recordObject = RecoedObject()
            recordObject.userId = UserManager.shared.getUserToken()
            recordObject.videoUrl = videoUrl
            print("write: ", recordObject)

            try! realm.write {
                realm.add(recordObject)
            }
        }
    }

    func getRecordFromRealm() {

        queue.async {

            let realm = self.generateRealm()
            let recordObjects = realm.objects(RecoedObject.self)

            for recordObject in recordObjects {
                print("record:", recordObject)
            }
        }
    }

}
