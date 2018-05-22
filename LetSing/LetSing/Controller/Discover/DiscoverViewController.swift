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

    lazy var lastOffsetX: CGFloat = self.scrollView.frame.origin.x

    lazy var lastOffsetY: CGFloat = self.scrollView.frame.origin.y

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

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let offsetX = scrollView.contentOffset.x - scrollView.frame.origin.x
//
//        let offsetY = scrollView.contentOffset.y - scrollView.frame.origin.y
//
//        print("offsetX:", offsetX, "offsetY:", offsetY)
//        print("lastOffsetX:", lastOffsetX, "lastOffsetY:", lastOffsetY)
//        print("contentOffsetX: ", scrollView.contentOffset.x, "contentOffsetY:", scrollView.contentOffset.y)
//
////        print("offsetX - currentX ",  offsetX - lastOffsetX, "offsetY - currentY:", offsetY - lastOffsetY)
//
//        let songVC = childViewControllers[1] as? DiscoverSongCollectionViewController
//
//        let typeVC = childViewControllers[0] as? DiscoverTypeCollectionViewController
//
//        let currentCollectionViewCell = songVC?.collectionView.visibleCells[0] as? DiscoverSongCollectionViewCell
//
//        if fabs(offsetX - lastOffsetX) > 0{ // 往左右滑
//
//            scrollView.isPagingEnabled = true
//            songVC?.collectionView.setContentOffset(
//                CGPoint(x: offsetX, y: (songVC?.collectionView.frame.origin.y)! + offsetY),
//                animated: false
//            )
//
//            DispatchQueue.main.async {
//                currentCollectionViewCell?.discoverSongTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
//            }
//
//            typeVC?.collectionView.setContentOffset(CGPoint(x: offsetX * offsetFactor, y: (typeVC?.collectionView.frame.origin.y)!), animated: false)
//
//            lastOffsetX = offsetX
//        }
//
//        if fabs(offsetY - lastOffsetY) > 0 { // 往上下滑
//
//            scrollView.isPagingEnabled = false
//
//            currentCollectionViewCell?.discoverSongTableView.setContentOffset(CGPoint(x: (songVC?.collectionView.frame.origin.x)!, y: (songVC?.collectionView.frame.origin.y)! + scrollView.contentOffset.y), animated: false)
//
//            lastOffsetY = offsetY
//        }
//    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)

        let typeVC = childViewControllers[0] as? DiscoverTypeCollectionViewController
        let songVC = childViewControllers[1] as? DiscoverSongCollectionViewController

        typeVC?.delegate = self

        offsetFactor = (typeVC?.discoverTypeDistanceBetweenItemsCenter)! / (songVC?.discoverSongDistanceBetweenItemsCenter)!
    }

//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let identifier = segue.identifier {
//
//            switch identifier {
//            case "DiscoverTypeCollectionViewController":
//                if let typeVC = segue.destination as? DiscoverTypeCollectionViewController {
//                    typeVC.delegate = self
//                }
//            default:
//                if let songVC = segue.destination as? DiscoverSongCollectionViewController {
//                    songVC.delegate = self
//                }
//            }
//        }
//    }
}
//
//extension DiscoverViewController: DiscoverTypeCollectionViewControllerDelegate, DiscoverSongCollectionViewControllerDelegate {
//
//    // did scroll
//    func typeViewDidScroll(_ controller: DiscoverTypeCollectionViewController, translation: CGFloat) {
//
//        let songVC = childViewControllers[1] as? DiscoverSongCollectionViewController
//
//        songVC?.collectionView.contentOffset.x = translation / offsetFactor
//    }
//
//    func songViewDidScroll(_ controller: DiscoverSongCollectionViewController, translation: CGFloat) {
////        self.songTranslation = translation
//
//        let typeVC = childViewControllers[0] as? DiscoverTypeCollectionViewController
//
//        typeVC?.collectionView.contentOffset.x = translation * offsetFactor
//    }
//}

extension DiscoverViewController: SongManagerDelegate {
    func manager(_ manager: SongManager, didGet songs: [Song]) {

        let songVC = childViewControllers[1] as? DiscoverSongCollectionViewController
        songVC?.songs = songs

        let currentCollectionViewCell = songVC?.collectionView.visibleCells[0] as? DiscoverSongCollectionViewCell

        currentCollectionViewCell?.tableView.reloadData()

    }
}

extension DiscoverViewController: DiscoverTypeCollectionViewControllerDelegate {
    func typeViewDidScroll(_ controller: DiscoverTypeCollectionViewController, translation: CGFloat) {

    }

    func typeViewDidSelect(_ controller: DiscoverTypeCollectionViewController, type: LSSongType) {
        requestYoutubeData(type: type)

        let songVC = childViewControllers[1] as? DiscoverSongCollectionViewController
        songVC?.collectionView.scrollToItem(at: IndexPath(row: type.hashValue, section: 0), at: .centeredHorizontally, animated: false)

        print(type.hashValue)
    }


}

