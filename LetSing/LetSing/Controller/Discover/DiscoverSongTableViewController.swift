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

    var tableView = UITableView()
    var songs = [Song]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
    }

    func setupTableView() {

//        guard let tableView = self.tableView else {
//            return
//        }

        let nib = UINib(nibName: String(describing: SongTableViewCell.self), bundle: nil)

        tableView.register(nib, forCellReuseIdentifier: String(describing: SongTableViewCell.self))

        tableView.contentInset = LSConstants.tableViewInset

        tableView.dataSource = self

        tableView.delegate = self
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

        tableViewCell.updateDataWith(title: songs[indexPath.row].name, imageUrl: songs[indexPath.row].image)

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
