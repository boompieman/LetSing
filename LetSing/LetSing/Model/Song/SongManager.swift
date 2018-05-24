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


protocol SongManagerDelegate: class {

    func manager(_ manager: SongManager, didGet songs: [Song])

}

struct SongManager {

    weak var delegate: SongManagerDelegate?

    private let provider = SongProvider()

    private let realm = try! Realm()

    func getSongFromRealm(type: LSSongType) {

        var songList = [Song]()

        let songObjects = realm.objects(SongObject.self).filter("typeString = '\(type.rawValue)'")

        for songObject in songObjects {
            guard let song = songObject.song else { return }
            songList.append(song)
        }

        self.delegate?.manager(self, didGet: songList)
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
                self.delegate?.manager(self, didGet: songList)
                self.writeSongToRealm(songs: songList)
            }
        }
    }

    private func writeSongToRealm(songs: [Song]) {

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
