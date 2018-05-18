//
//  lyricsViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/18.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import UIKit


class lyricsViewController: UIViewController {

    var manager = LyricsManager()

    var lyrics: Lyrics?

    var song: Song?

    override func viewDidLoad() {
         super.viewDidLoad()

        requestLyrics()
        
    }

    func requestLyrics() {

        manager.delegate = self

        guard let song = song else {
            return
        }

        self.manager.getLyricBySong(id: song.id)


    }

}

extension lyricsViewController: LyricsManagerDelegate {
    func manager(_ manager: LyricsManager, didGet lyrics: Lyrics) {

        self.lyrics = lyrics
    }


}
