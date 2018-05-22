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

                DispatchQueue.main.async {
                    self.delegate?.manager(self, didGet: songs)
                }
        },
            failure: { (error) in
            print(error)
        })
    }

    private func callYoutubeAPI(songName: String, rank: Int, singer: String, type: LSSongType, completion: @escaping (Song) -> Void) { // 需要call 20次api

        provider.getDiscoverSong(songName: songName, success: { (song) in

            var songVar = song

            songVar.rank = rank
            songVar.singer = singer
            songVar.type = type

            completion(songVar)

        }) { (error) in
            print(error)
        }
    }

    func getDiscoverBoard(type: LSSongType) {
        let ref = Database.database().reference()

        let request = ref.child("ktv")

        var songList = [Song]()

        let dispatchGroup = DispatchGroup()

        request.observeSingleEvent(of: .value) { (snapshot) in
            guard let types = snapshot.value as? [String: AnyObject] else { return }

            guard let typeValue = types[type.rawValue] as? [AnyObject] else {
                print("No~~")
                return
            }

            for value in typeValue {

                guard let songName = value["name"] as? String, let rankString = value["rank"] as? String, let singer = value["singer"] as? String else {

                    return
                }

                guard let rank = Int(rankString) else {
                    return
                }

                dispatchGroup.enter()

                self.callYoutubeAPI(songName: songName, rank: rank, singer: singer, type: type, completion: {(song) in

//                    print("song:", song)
                    songList.append(song)

                    //都append完才能傳回去

                    dispatchGroup.leave()
                })
            }

            dispatchGroup.notify(queue: .main) {
                self.delegate?.manager(self, didGet: songList)
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
