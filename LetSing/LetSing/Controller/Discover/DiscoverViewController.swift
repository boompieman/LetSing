//
//  DiscoverViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/2.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class DiscoverViewController: UIViewController, UIScrollViewDelegate {

    var offsetFactor: CGFloat = 0.0

    var lastCellRow: Int = 0

    var currentCellRow: Int = 0

    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let typeVC = childViewControllers[0] as? DiscoverTypeCollectionViewController
        let songVC = childViewControllers[1] as? DiscoverSongCollectionViewController

        typeVC?.delegate = self
        songVC?.delegate = self

        offsetFactor = (typeVC?.discoverTypeDistanceBetweenItemsCenter)! / (songVC?.discoverSongDistanceBetweenItemsCenter)!

        resetCell(from: lastCellRow, to: currentCellRow)
    }

    // 可以封裝進view裏，將包覆兩個大collectionView的View在定義成一個swift檔出來
    func resetCell(from lastRow:Int, to currentRow: Int) {

        currentCellRow = currentRow

        let typeVC = childViewControllers[0] as? DiscoverTypeCollectionViewController

        let lastCell = typeVC?.collectionView.cellForItem(at: IndexPath(row: lastRow, section: 0)) as? DiscoverTypeCollectionViewCell

        lastCell?.typeLabel.textColor = UIColor(red: 255/255, green: 190/255, blue: 185/255, alpha: 1.0)
        lastCell?.typeLabel.font = UIFont.systemFont(ofSize: 15.0)

        let currentCell = typeVC?.collectionView.cellForItem(at: IndexPath(row: currentRow, section: 0)) as? DiscoverTypeCollectionViewCell

        currentCell?.typeLabel.textColor = UIColor(red: 215/255, green: 68/255, blue: 62/255, alpha: 1.0)
        currentCell?.typeLabel.font = UIFont.boldSystemFont(ofSize: 17.0)

        lastCellRow = currentRow
    }
}

extension DiscoverViewController: DiscoverTypeCollectionViewControllerDelegate {

    func typeViewDidScroll(_ controller: DiscoverTypeCollectionViewController, translation: CGFloat) {

        let songVC = childViewControllers[1] as? DiscoverSongCollectionViewController
        songVC?.collectionView.bounds.origin.x = translation / offsetFactor
    }

    func typeViewDidSelect(_ controller: DiscoverTypeCollectionViewController, type: LSSongType) {

        resetCell(from: lastCellRow, to: type.hashValue)
    }

    func typeViewDidScroll(_ controller: DiscoverTypeCollectionViewController, from lastRow: Int, to currentRow: Int) {
        
        resetCell(from: lastRow, to: currentRow)
    }
}

extension DiscoverViewController: DiscoverSongCollectionViewControllerDelegate {
    func songViewDidScroll(_ controller: DiscoverSongCollectionViewController, from lastRow: Int, to currentRow: Int) {

        resetCell(from: lastRow,to: currentRow)
    }

    func songViewDidScroll(_ controller: DiscoverSongCollectionViewController, translation: CGFloat) {

        let typeVC = childViewControllers[0] as? DiscoverTypeCollectionViewController
        typeVC?.collectionView.bounds.origin.x = translation * offsetFactor
    }
}
