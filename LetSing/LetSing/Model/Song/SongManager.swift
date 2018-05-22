//
//  SongManager.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/5.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


protocol SongManagerDelegate: class {

    func manager(_ manager: SongManager, didGet songs: [Song])

}

struct SongManager {

    weak var delegate: SongManagerDelegate?

    private let provider = SongProvider()

    func getSearchResult(searchText: String) {

        provider.getSearchSongs(
            searchText: searchText,
            success: { (songs) in
//            var songArray = songs



                DispatchQueue.main.async {
                    self.delegate?.manager(self, didGet: songs)
                }

        },
            failure: { (error) in
            print(error)
        })
    }

    private func callYoutubeAPI(songName: String) { // 需要call 20次api

        print(songName)

        

//        DispatchQueue.main.async {
//            self.delegate?.manager(self, didGet: [Song(id: "1", name: "2", singer: "3", image: "4", rank: 5, type: "6")])
//        }

//        provider.getDiscoverSongs(songName: songName, success: { (song) in
//            
//        }) { (error) in
//            print(error)
//        }
    }

    func getDiscoverBoard(type: LSSongType) {
        let ref = Database.database().reference()

        let request = ref.child("ktv")

        request.observeSingleEvent(of: .value) { (snapshot) in
            guard let types = snapshot.value as? [String: AnyObject] else { return }

            guard let typeValue = types[type.rawValue] as? [AnyObject] else {
                print("No~~")
                return
            }

            for value in typeValue {

                guard let songName = value["name"] as? String else {
                    return
                }

                self.callYoutubeAPI(songName: songName)
            }
        }
    }
}

enum LSSongType: String {

    case chinese = "holiday_chinese_hot"

    case english = "holiday_english_hot"

    case guan = "holiday_guan_hot"

    case japanese = "holiday_japanese_hot"

    case taiwanese = "holiday_taiwanese_hot"

}
