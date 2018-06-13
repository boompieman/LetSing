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

    var currentIndex = 0

    var videoProvider: LSYoutubeVideoProvider?

    @IBOutlet weak var noLyricsLabel: UILabel!
    private static var observerContext = 0

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
         super.viewDidLoad()

        setupTableView()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        self.tableView.backgroundColor = UIColor(red: 51/255, green: 58/255, blue: 66/255, alpha: 1.0)

        let nib = UINib (
            nibName: String(describing: LyricsTableViewCell.self),
            bundle: nil
        )

        tableView.register(nib, forCellReuseIdentifier: String(describing: LyricsTableViewCell.self))

        tableView.separatorStyle = .none

        tableView.allowsSelection = false
    }

    func requestLyrics(song: Song) {

        manager.delegate = self
        self.manager.getLyricBySong(id: song.id)
    }

    func moveLyrics(currentTime: Float) {

        guard let lyrics = lyrics else {
            return
        }

        if currentIndex < lyrics.lines.count && currentTime - lyrics.lines[currentIndex].start >= 0 {

            self.tableView.scrollToRow(
                at: IndexPath(row: currentIndex, section: 0),
                at: .middle,
                animated: true
            )

            let lyricsCell = self.tableView.cellForRow(at: IndexPath(row: currentIndex, section: 0)) as? LyricsTableViewCell
            let lastLyricsCell = self.tableView.cellForRow(at: IndexPath(row: currentIndex - 1, section: 0)) as? LyricsTableViewCell

            lyricsCell?.lineLabel.textColor = UIColor.orange
            lastLyricsCell?.lineLabel.textColor = UIColor.white

            currentIndex += 1
        }
    }
}

extension LyricsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let lyrics = lyrics else {
            return 0
        }

        return lyrics.lines.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 50.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell =
            tableView.dequeueReusableCell(
                withIdentifier: String(describing: LyricsTableViewCell.self),
                for: indexPath
            ) as? LyricsTableViewCell else { return UITableViewCell()}

        if let lyrics = lyrics {
            guard indexPath.row < lyrics.lines.count else {
                return cell
            }

            cell.updatelineWith(line: lyrics.lines[indexPath.row].words)

            cell.lineLabel.textColor = UIColor.white

            return cell
        }

        return cell
    }
}

extension LyricsViewController: LyricsManagerDelegate {
    func manager(_ manager: LyricsManager, didGet lyrics: Lyrics) {

        if lyrics.lines.count == 0 {
            self.tableView.removeFromSuperview()

        } else {
            noLyricsLabel.isHidden = true
            self.lyrics = lyrics
            self.tableView.reloadData()
        }
    }
}
