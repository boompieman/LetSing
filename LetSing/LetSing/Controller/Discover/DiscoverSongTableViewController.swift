//
//  DiscoverTableViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/6/4.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import UIKit

class DiscoverSongTableViewController: UIViewController {

    var type: LSSongType?
    var tableView = UITableView()
    var songs = [Song]()

    var manager = SongManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        requestYoutubeData(type: type!)

        setupTableView()
    }

    func requestYoutubeData(type: LSSongType) {

        manager.delegate = self

        LSAnalytics.shared.logEvent("type_in_\(type.rawValue)", parameters: nil)

        let hasDataInRealm: Bool =
            !(manager.generateRealm().objects(SongObject.self).filter("typeString = '\(type.rawValue)'").isEmpty)

        if hasDataInRealm {

            manager.getBoardFromRealm(type: type)
        }
        else {

            manager.getBoardSongFromYoutube(type: type)
        }
    }

    func setupTableView() {

        let nib = UINib(nibName: String(describing: SongTableViewCell.self), bundle: nil)

        tableView.register(nib, forCellReuseIdentifier: String(describing: SongTableViewCell.self))

        tableView.contentInset = LSConstants.tableViewInset

        tableView.dataSource = self

        tableView.delegate = self

        self.view.addSubview(tableView)
    }
}


extension DiscoverSongTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return songs.count

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let tableViewCell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: SongTableViewCell.self),
            for: indexPath
            ) as! SongTableViewCell

        tableViewCell.updateWith(title: songs[indexPath.row].name, imageUrl: songs[indexPath.row].image)

        return tableViewCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)


        guard let recordController = UIStoryboard.recordStoryboard().instantiateViewController(
            withIdentifier: String(describing: RecordViewController.self)
            ) as? RecordViewController else { return }

        recordController.song = songs[indexPath.row]
        show(recordController, sender: nil)
    }
}

extension DiscoverSongTableViewController: SongManagerDelegate {

    func manager(_ manager: SongManager, didGet songs: [Song], _ pageToken: String) {

        self.songs = songs
        self.tableView.reloadData()
    }
}
