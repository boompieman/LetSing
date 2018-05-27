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
import RealmSwift
import Realm


protocol SongManagerDelegate: class {

    func manager(_ manager: SongManager, didGet songs: [Song])

}

struct SongManager {

    weak var delegate: SongManagerDelegate?

    private let provider = SongProvider()

    private let queue = DispatchQueue(label: String(describing: SongManager.self) + UUID().uuidString, qos: .default, attributes: .concurrent)

    func generateRealm() -> Realm {
        let url = URL(fileURLWithPath: RLMRealmPathForFile("songData.realm"), isDirectory: false)
        var config = Realm.Configuration(fileURL: url)
        let realm = try! Realm(configuration: config)

        return realm
    }

    func getBoardFromRealm(type: LSSongType) {

        var songList = [Song]()

        // 使用concurrent thread的方式，讓程式跑起來更順暢
        queue.async {

            let realm = self.generateRealm()

            let songObjects = realm.objects(SongObject.self).filter("typeString = '\(type.rawValue)'")
            for songObject in songObjects {
                guard let song = songObject.song else { return }
                songList.append(song)
            }

            DispatchQueue.main.async(execute: {
                self.delegate?.manager(self, didGet: songList)
            })
        }
    }

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

    func getBoardSongFromYoutube(type: LSSongType) {
        let ref = Database.database().reference()

        let request = ref.child("ktv").child(type.rawValue).queryLimited(toFirst: 20)

        var songList = [Song]()

        let dispatchGroup = DispatchGroup()

        request.observeSingleEvent(of: .value) { (snapshot) in
            guard let songs = snapshot.value as? [AnyObject] else { return }

            for song in songs {

                guard let song = song as? [String: AnyObject] else {
                    return
                }

                guard let songName = song["name"] as? String, let rankString = song["rank"] as? String, let singer = song["singer"] as? String else {

                    return
                }

                guard let rank = Int(rankString) else {
                    return
                }

                dispatchGroup.enter()

                self.callYoutubeAPI(songName: songName, rank: rank, singer: singer, type: type, completion: {(song) in

                    songList.append(song)

                    dispatchGroup.leave()
                })
            }

            dispatchGroup.notify(queue: .main) {
                songList.sort(by: { (song1, song2) -> Bool in
                    return song1.rank! < song2.rank!
                })
                self.writeSongToRealm(songs: songList)
                self.delegate?.manager(self, didGet: songList)
            }
        }
    }

    private func writeSongToRealm(songs: [Song]) {

        queue.async {

            let realm = self.generateRealm()

            realm.beginWrite()

            for song in songs {
                let songObject = SongObject()
                songObject.song = song
                songObject.type = song.type
                realm.add(songObject)
            }

            try! realm.commitWrite()
        }
    }

    private func deleteAllSongsInRealm() {

        queue.async {

            let realm = self.generateRealm()

            realm.deleteAll()
        }
    }
}
