//
//  DiscoverTypeCollectionViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/4.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import UIKit


protocol DiscoverTypeCollectionViewControllerDelegate: class {
    func typeViewDidScroll(_ controller: DiscoverTypeCollectionViewController, translation: CGFloat)

    func typeViewDidSelect(_ controller: DiscoverTypeCollectionViewController, type: LSSongType)
}


class DiscoverTypeCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var typeList:[LSSongType] = [.chinese, .english, .guan, .japanese, .taiwanese]

    weak var delegate: DiscoverTypeCollectionViewControllerDelegate? // to pass offset for parent controller

    var discoverTypeDistanceBetweenItemsCenter: CGFloat?

    override func viewDidLoad() {

        super.viewDidLoad()

        setupCollectionView()
    }

    func setupCollectionView() {

        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        let nib = UINib(nibName: String(describing: DiscoverTypeCollectionViewCell.self), bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: String(describing: DiscoverTypeCollectionViewCell.self))

        let discoverTypeCollectionViewFlowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        discoverTypeCollectionViewFlowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2, height: 40)
        discoverTypeCollectionViewFlowLayout.minimumLineSpacing = 0

        discoverTypeDistanceBetweenItemsCenter = discoverTypeCollectionViewFlowLayout.minimumLineSpacing + discoverTypeCollectionViewFlowLayout.itemSize.width
    }
}


extension DiscoverTypeCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return typeList.count

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DiscoverTypeCollectionViewCell.self), for: indexPath)

        guard let discoverTypeCollectionViewCell = cell as? DiscoverTypeCollectionViewCell else {return cell}

        discoverTypeCollectionViewCell.typeLabel.text = typeList[indexPath.row].title()

        discoverTypeCollectionViewCell.layer.cornerRadius = 10

        return discoverTypeCollectionViewCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.delegate?.typeViewDidSelect(self, type: typeList[indexPath.row])

//        let cell = collectionView.cellForItem(at: indexPath) as? DiscoverTypeCollectionViewCell

//        cell?.typeLabel.textColor = UIColor.orange

    }

//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as? DiscoverTypeCollectionViewCell
//
//        cell?.typeLabel.textColor = UIColor.white
//    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offsetX = scrollView.contentOffset.x - scrollView.frame.origin.x
        self.delegate?.typeViewDidScroll(self, translation: offsetX)

        
    }
}


extension DiscoverTypeCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let discoverTypeSectionInset = UIScreen.main.bounds.width / 4.0

        return UIEdgeInsets(top: 0, left: discoverTypeSectionInset, bottom: 0, right: discoverTypeSectionInset)

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


