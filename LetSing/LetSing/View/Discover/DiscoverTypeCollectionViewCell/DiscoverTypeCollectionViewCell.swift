//
//  DiscoverTypeCollectionViewCell.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/3.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

class DiscoverTypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateWith(type: LSSongType) {
        typeLabel.text = type.title()
    }

}
