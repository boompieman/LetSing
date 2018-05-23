//
//  DiscoverViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/2.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import UIKit


class DiscoverViewController: UIViewController, UIScrollViewDelegate {

    var offsetFactor: CGFloat = 0.0

    var lastCellRow: Int = 0

    var currentCellRow: Int = 0

    var manager = SongManager()

    var songs = [Song]()

    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {

        requestYoutubeData(type: .chinese)

    }

    func requestYoutubeData(type: LSSongType) {

        manager.delegate = self

        manager.getDiscoverBoard(type: type)

    }

    func resetCell(from lastRow:Int, to currentRow: Int) {

        currentCellRow = currentRow

        let typeVC = childViewControllers[0] as? DiscoverTypeCollectionViewController

        let lastCell = typeVC?.collectionView.cellForItem(at: IndexPath(row: lastRow, section: 0)) as? DiscoverTypeCollectionViewCell

        lastCell?.typeLabel.textColor = UIColor.white
        lastCell?.typeLabel.font = UIFont.systemFont(ofSize: 15.0)

        let currentCell = typeVC?.collectionView.cellForItem(at: IndexPath(row: currentRow, section: 0)) as? DiscoverTypeCollectionViewCell

        currentCell?.typeLabel.textColor = UIColor(red: 215/255, green: 68/255, blue: 62/255, alpha: 1.0)
        currentCell?.typeLabel.font = UIFont.boldSystemFont(ofSize: 17.0)

        lastCellRow = currentRow
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        let typeVC = childViewControllers[0] as? DiscoverTypeCollectionViewController
        let songVC = childViewControllers[1] as? DiscoverSongCollectionViewController

        typeVC?.delegate = self
        songVC?.delegate = self

        offsetFactor = (typeVC?.discoverTypeDistanceBetweenItemsCenter)! / (songVC?.discoverSongDistanceBetweenItemsCenter)!
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        resetCell(from: lastCellRow, to: currentCellRow)
    }
}

extension DiscoverViewController: SongManagerDelegate {
    func manager(_ manager: SongManager, didGet songs: [Song]) {

        let songVC = childViewControllers[1] as? DiscoverSongCollectionViewController
        songVC?.songs = songs

        let currentSongCell = songVC?.collectionView.cellForItem(at: IndexPath(row: currentCellRow, section: 0)) as? DiscoverSongCollectionViewCell

        currentSongCell?.tableView.reloadData()

    }
}

extension DiscoverViewController: DiscoverTypeCollectionViewControllerDelegate {

    func typeViewDidScroll(_ controller: DiscoverTypeCollectionViewController, translation: CGFloat) {

        let typeVC = childViewControllers[0] as? DiscoverTypeCollectionViewController
        let songVC = childViewControllers[1] as? DiscoverSongCollectionViewController

        songVC?.collectionView.bounds.origin.x = translation / offsetFactor
    }

    func typeViewDidSelect(_ controller: DiscoverTypeCollectionViewController, type: LSSongType) {

        resetCell(from: lastCellRow, to: type.hashValue)
//        requestYoutubeData(type: type)
    }

    func typeViewDidScroll(_ controller: DiscoverTypeCollectionViewController, from lastRow: Int, to currentRow: Int) {
        
        resetCell(from: lastRow, to: currentRow)
    }

}

extension DiscoverViewController: DiscoverSongCollectionViewControllerDelegate {
    func songViewDidScroll(_ controller: DiscoverSongCollectionViewController, translation: CGFloat) {

        let typeVC = childViewControllers[0] as? DiscoverTypeCollectionViewController
        typeVC?.collectionView.bounds.origin.x = translation * offsetFactor

        let songVC = childViewControllers[1] as? DiscoverSongCollectionViewController

        if translation.truncatingRemainder(dividingBy: (songVC?.collectionView.frame.width)!) == 0 {

            let row = Int(translation / (songVC?.collectionView.frame.width)!)

            resetCell(from: lastCellRow,to: row)
//            requestYoutubeData(type: (typeVC?.typeList[row])!)
        }
    }

}
