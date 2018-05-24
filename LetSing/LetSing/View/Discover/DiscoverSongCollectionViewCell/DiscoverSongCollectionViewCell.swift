//
//  DiscoverSongCollectionViewCell.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/3.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

class DiscoverSongCollectionViewCell: UICollectionViewCell {

    

    @IBOutlet weak var tableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        setupTableView()
    }

    func setupTableView() {
        let nib = UINib(nibName: String(describing: SongTableViewCell.self), bundle: nil)

        self.tableView.register(nib, forCellReuseIdentifier: String(describing: SongTableViewCell.self))



        tableView.contentInset = LSConstants.tableViewInset
    }

    func setTableViewDataSourceDelegate <D: UITableViewDataSource & UITableViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {

        self.tableView.delegate = dataSourceDelegate
        self.tableView.dataSource = dataSourceDelegate
        self.tableView.tag = row
    }

}
