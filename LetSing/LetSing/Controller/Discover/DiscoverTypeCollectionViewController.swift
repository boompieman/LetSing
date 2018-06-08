//
//  DiscoverTypeCollectionViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/4.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit


protocol DiscoverTypeCollectionViewControllerDelegate: class {

    func typeViewDidScroll(_ controller: DiscoverTypeCollectionViewController, translation: CGFloat)

    func typeViewDidSelect(_ controller: DiscoverTypeCollectionViewController, type: LSSongType)

    func typeViewDidScroll(_ controller: DiscoverTypeCollectionViewController, from lastRow:Int, to currentRow: Int)
}


class DiscoverTypeCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var lastRow: Int = 0

    var currentRow: Int = 0

    private let typeList:[LSSongType] = [.chinese, .english, .guan, .japanese, .taiwanese]

    weak var delegate: DiscoverTypeCollectionViewControllerDelegate?

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

        // MARK: Layout Setting and Calculate one item length
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

        discoverTypeCollectionViewCell.updateWith(type: typeList[indexPath.row])

        return discoverTypeCollectionViewCell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        guard let discoverTypeCollectionViewCell = cell as? DiscoverTypeCollectionViewCell else { return }

        discoverTypeCollectionViewCell.typeLabel.textColor = UIColor(named: LSColor.type.color())

        discoverTypeCollectionViewCell.typeLabel.font = UIFont.systemFont(ofSize: 15.0)


    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)

        
        self.delegate?.typeViewDidSelect(self, type: typeList[indexPath.row])

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offsetX = scrollView.contentOffset.x - scrollView.frame.origin.x
        self.delegate?.typeViewDidScroll(self, translation: offsetX)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        lastRow = Int(self.collectionView.contentOffset.x / discoverTypeDistanceBetweenItemsCenter!)

    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        currentRow = lastRow

        targetContentOffset.pointee = scrollView.contentOffset

        if (velocity.x == 0) {

            currentRow = Int(self.collectionView.contentOffset.x  / discoverTypeDistanceBetweenItemsCenter!)
        }

        else {

            currentRow = velocity.x > 0 ? currentRow + 1 : currentRow - 1

            if currentRow < 0 {

                currentRow = 0
            }
            if (currentRow > Int(self.collectionView.contentSize.width / discoverTypeDistanceBetweenItemsCenter!) - 2) {

                currentRow = Int(ceil(self.collectionView.contentSize.width / discoverTypeDistanceBetweenItemsCenter!)) - 2
            }
        }

        self.collectionView.scrollToItem(at: IndexPath(row: currentRow, section: 0), at: .centeredHorizontally, animated: true)

        if lastRow != currentRow {
            self.delegate?.typeViewDidScroll(self, from: lastRow, to: currentRow)
        }
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


