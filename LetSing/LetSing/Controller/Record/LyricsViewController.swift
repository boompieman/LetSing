//
//  lyricsViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/18.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import UIKit


class LyricsViewController: UIViewController {

    var manager = LyricsManager()

    var lyrics: Lyrics?

    
    @IBOutlet var lyricsView: LyricsView!

    override func viewDidLoad() {
         super.viewDidLoad()
    }

    func requestLyrics(song: Song) {

        manager.delegate = self

        self.manager.getLyricBySong(id: song.id)
    }

}

extension LyricsViewController: LyricsManagerDelegate {
    func manager(_ manager: LyricsManager, didGet lyrics: Lyrics) {

        self.lyrics = lyrics
        print(lyrics)
    }
}
