//
//  DiscoverSongCollectionViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/4.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

protocol DiscoverSongCollectionViewControllerDelegate: class {

    func songViewDidScroll(_ controller: DiscoverSongCollectionViewController, translation: CGFloat)

    func songViewDidScroll(_ controller: DiscoverSongCollectionViewController, from lastRow: Int, to currentRow: Int)
}

class DiscoverSongCollectionViewController: UIViewController {

    var discoverSongDistanceBetweenItemsCenter: CGFloat?

    weak var delegate: DiscoverSongCollectionViewControllerDelegate?

    @IBOutlet weak var collectionView: UICollectionView!

    var songs = [Song]()

    var lastRow: Int = 0

    var currentRow: Int = 0

    lazy var tableViewControllers = [
        DiscoverSongTableViewController(),
        DiscoverSongTableViewController(),
        DiscoverSongTableViewController(),
        DiscoverSongTableViewController(),
        DiscoverSongTableViewController()
    ]

    private var songType: [LSSongType] = [.chinese, .english, .guan, .japanese, .taiwanese]

    override func viewDidLoad() {

        setupCollectionView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    func setupCollectionView() {

        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)

        collectionView.backgroundColor = UIColor.white

        let nib = UINib(nibName: String(describing: DiscoverSongCollectionViewCell.self), bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: String(describing: DiscoverSongCollectionViewCell.self))

        // set song collection view layout

        discoverSongDistanceBetweenItemsCenter = UIScreen.main.bounds.width
    }
}

extension DiscoverSongCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return tableViewControllers.count

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

        self.tableViewControllers[indexPath.row].type = self.songType[indexPath.row]

        //問為何改bounds可以，frame不行!!
        tableViewControllers[indexPath.row].tableView.frame = discoverSongCollectionViewCell.bounds

        // 問為何明明沒有kill掉，卻不會加一
        self.addChildViewController(tableViewControllers[indexPath.row])
    self.tableViewControllers[indexPath.row].didMove(toParentViewController: self)

        // 加這行才會讓tableView顯示在collectionView上
        discoverSongCollectionViewCell.addSubview(tableViewControllers[indexPath.row].view)

    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        guard let discoverSongCollectionViewCell = cell as? DiscoverSongCollectionViewCell else {
            
            return
        }
    }

    // scrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offsetX = scrollView.contentOffset.x - scrollView.frame.origin.x
        self.delegate?.songViewDidScroll(self, translation: offsetX)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastRow = Int(self.collectionView.contentOffset.x / discoverSongDistanceBetweenItemsCenter!)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        currentRow = Int(self.collectionView.contentOffset.x  / discoverSongDistanceBetweenItemsCenter!)

        if lastRow != currentRow {
            self.delegate?.songViewDidScroll(self, from: lastRow, to: currentRow)
        }
    }
}

extension DiscoverSongCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemSize = CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)

        return itemSize
    }

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
