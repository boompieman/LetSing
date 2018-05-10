//
//  DiscoverSongCollectionViewCell.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/3.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

class DiscoverSongCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var discoverSongTableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        setupTableView()
    }

    func setupTableView() {
//        let nib = UINib(nibName: String(describing: DiscoverSongTableViewCell.self), bundle: nil)
//
//        self.discoverSongTableView.register(nib, forCellReuseIdentifier: String(describing: DiscoverSongTableViewCell.self))
    }

//    func setTableViewDataSourceDelegate <D: UICollectionViewDataSource & UICollectionViewDelegate>
//        (dataSourceDelegate: D, forRow row: Int) {
//
//        self.discoverSongTableView.delegate = dataSourceDelegate
//        self.discoverSongTableView.dataSource = dataSourceDelegate
//        self.discoverSongTableView.tag = row
//    }

}
