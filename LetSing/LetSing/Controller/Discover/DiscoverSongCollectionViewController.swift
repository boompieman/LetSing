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


        if indexPath.row == 1 {
            cell.backgroundColor = UIColor.red
        }

        guard let discoverSongCollectionViewCell = cell as? DiscoverTypeCollectionViewCell else {return cell}

        return discoverSongCollectionViewCell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offsetX = scrollView.contentOffset.x - scrollView.frame.origin.x
        self.delegate?.songViewDidScroll(self, translation: offsetX)

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

