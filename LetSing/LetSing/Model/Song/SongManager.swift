//
//  SongManager.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/5.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation

protocol SongManagerDelegate: class {

    func manager(_ manager: SongManager, didGet songs: [Song])

}

struct SongManager {

    weak var delegate: SongManagerDelegate?

    private let provider = SongProvider()

    func getSearchResult(songName: String) {

        provider.getSearchSongs(songName: songName, success: { (songs) in
            var songArray = songs

            DispatchQueue.main.async {
                self.delegate?.manager(self, didGet: songArray)
            }

        }, failure: { (error) in
            print(error)
        })
    }

}
