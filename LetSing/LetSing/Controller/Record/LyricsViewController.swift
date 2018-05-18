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

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
         super.viewDidLoad()

        setupTableView()

    }



    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        print("view will disappear")
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        let nib = UINib (
            nibName: String(describing: LyricsTableViewCell.self),
            bundle: nil
        )

        tableView.register(nib, forCellReuseIdentifier: String(describing: LyricsTableViewCell.self))

        tableView.separatorStyle = .none

    }

    func requestLyrics(song: Song) {

        manager.delegate = self
        self.manager.getLyricBySong(id: song.id)
    }

}

extension LyricsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let lyrics = lyrics else{
            return 0
        }

        return lyrics.lines.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 50.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: LyricsTableViewCell.self),
            for: indexPath
        ) as! LyricsTableViewCell


        if let lyrics = lyrics {
            guard indexPath.row < lyrics.lines.count else {
                return cell
            }

            cell.updatelineWith(line: lyrics.lines[indexPath.row].words)

            return cell
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
}

extension LyricsViewController: LyricsManagerDelegate {
    func manager(_ manager: LyricsManager, didGet lyrics: Lyrics) {

        self.lyrics = lyrics
        self.tableView.reloadData()
    }
}
