//
//  LyricManager.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/18.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation

protocol LyricsManagerDelegate: class {

    func manager(_ manager: LyricsManager, didGet lyrics: Lyrics)

}

struct LyricsManager {

    weak var delegate: LyricsManagerDelegate?

    private let provider = LyricsProvider()

    func getLyricBySong(id songId: String) {

        provider.getLyrics(songId: songId, success: { (lyrics) in

            DispatchQueue.main.async {
                self.delegate?.manager(self, didGet: lyrics)
            }

        }) { (error) in
            print(error)
        }
    }

}
