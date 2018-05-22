//
//  SongManager.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/5.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import Firebase


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

    func getDiscoverSong(songName: String) {

        provider.getDiscoverSongs(songName: songName, success: { (songs) in

            DispatchQueue.main.async {
                self.delegate?.manager(self, didGet: songs)
            }

        }) { (error) in
            print(error)
        }
    }

    func getBoardFromFireBase() -> String {
        let ref = Database.database()

        return ""
    }

}
