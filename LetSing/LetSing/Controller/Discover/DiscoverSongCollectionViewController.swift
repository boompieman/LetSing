//
//  DiscoverSongCollectionViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/4.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import UIKit

protocol DiscoverSongCollectionViewControllerDelegate: class {
    func songViewDidScroll(_ controller: DiscoverSongCollectionViewController, translation: CGFloat)
}

class DiscoverSongCollectionViewController: UIViewController {

    var discoverSongDistanceBetweenItemsCenter: CGFloat?

    weak var delegate: DiscoverSongCollectionViewControllerDelegate?

    @IBOutlet weak var collectionView: UICollectionView!


    override func viewDidLoad() {

        setupCollectionView()
    }

    func setupCollectionView() {

        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        let nib = UINib(nibName: String(describing: DiscoverSongCollectionViewCell.self), bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: String(describing: DiscoverSongCollectionViewCell.self))

        // set song collection view layout
        let discoverSongCollectionViewFlowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        discoverSongCollectionViewFlowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: self.collectionView.bounds.height)

        discoverSongCollectionViewFlowLayout.minimumLineSpacing = 0
        
        discoverSongDistanceBetweenItemsCenter = discoverSongCollectionViewFlowLayout.minimumLineSpacing + discoverSongCollectionViewFlowLayout.itemSize.width
    }
}

extension DiscoverSongCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 5

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DiscoverSongCollectionViewCell.self), for: indexPath)

        guard let discoverSongCollectionViewCell = cell as? DiscoverSongCollectionViewCell else {return cell}

        return discoverSongCollectionViewCell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        guard let discoverSongCollectionViewCell = cell as? DiscoverSongCollectionViewCell else {
            return
        }

        discoverSongCollectionViewCell.setTableViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
}

extension DiscoverSongCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize.zero
    }
}

extension DiscoverSongCollectionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 10
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 200
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let tableViewCell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: SongTableViewCell.self),
            for: indexPath
            ) as! SongTableViewCell

        if indexPath.row == 1 {
            tableViewCell.backgroundColor = UIColor.red
        }

        else if indexPath.row == 4 {
            tableViewCell.backgroundColor = UIColor.blue
        }
        else {
            tableViewCell.backgroundColor = UIColor.yellow
        }
        tableViewCell.titleLabel.text = "66666666"


        return tableViewCell
    }

}
