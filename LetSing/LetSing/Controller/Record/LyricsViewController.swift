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

    var currentTimeProvider = LSYoutubeVideoProvider()

    var timer: Timer?

    var lyrics: Lyrics?

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
         super.viewDidLoad()

        setupTableView()
    }

    func startTimer() {

        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(detactTimeBySecond),
            userInfo:nil,
            repeats:true
        )
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc func detactTimeBySecond() {

        self.currentTimeProvider.getCurrentTime()
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

            cell.lineLabel.textColor = UIColor.white

            return cell
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath) as! LyricsTableViewCell

        cell.lineLabel.textColor = UIColor.orange

        print("selected")

    }
}

extension LyricsViewController: LyricsManagerDelegate {
    func manager(_ manager: LyricsManager, didGet lyrics: Lyrics) {

        if lyrics.lines.count == 0 {
            print("screen should show 這首歌在youtube上沒有歌詞")


        }

        else {
            self.lyrics = lyrics
            self.tableView.reloadData()
            startTimer()
        }
    }
}

extension LyricsViewController: currentTimeProviderDelegate {
    func didCurrentTimeChangedBySecond(didGet currentTime: Float) {

        print("did sent Time", currentTime)
    }
}
