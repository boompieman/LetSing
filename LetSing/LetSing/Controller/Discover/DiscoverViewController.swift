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

    @IBOutlet weak var scrollView: UIScrollView!

    
    override func viewDidLoad() {

        scrollView.delegate = self
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width * 5, height: self.view.frame.height)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offsetX = scrollView.contentOffset.x - scrollView.frame.origin.x

        print(offsetX)

        let songVC = childViewControllers[1] as? DiscoverSongCollectionViewController

        songVC?.collectionView.setContentOffset(CGPoint(x: offsetX, y: (songVC?.collectionView.frame.origin.y)!), animated: false)

        let typeVC = childViewControllers[0] as? DiscoverTypeCollectionViewController

        typeVC?.collectionView.setContentOffset(CGPoint(x: offsetX * offsetFactor, y: (typeVC?.collectionView.frame.origin.y)!), animated: false)

//        self.delegate?.songViewDidScroll(self, translation: offsetX)

    }


//    @IBAction func scrollButtonDidTapped(_ sender: Any) {
//
//        print("tapped")
//
//
//        let songVC = childViewControllers[1] as? DiscoverSongCollectionViewController
//
//        songVC?.collectionView.setContentOffset(CGPoint(x: 187.5 / offsetFactor, y: (songVC?.collectionView.frame.origin.y)!), animated: true)
//
//
//
//        let typeVC = childViewControllers[0] as? DiscoverTypeCollectionViewController
//
//        typeVC?.collectionView.setContentOffset(CGPoint(x: 375 * offsetFactor, y: (typeVC?.collectionView.frame.origin.y)!), animated: true)
//
//    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)

        let typeVC = childViewControllers[0] as? DiscoverTypeCollectionViewController
        let songVC = childViewControllers[1] as? DiscoverSongCollectionViewController

        offsetFactor = (typeVC?.discoverTypeDistanceBetweenItemsCenter)! / (songVC?.discoverSongDistanceBetweenItemsCenter)!

        print(offsetFactor)

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
//
//    //did select
//
//    func typeViewDidSelect(_ controller: DiscoverTypeCollectionViewController, indexPath: IndexPath) {
//
//        let songVC = childViewControllers[1] as? DiscoverSongCollectionViewController
//
//        songVC?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//
//    }
//}

