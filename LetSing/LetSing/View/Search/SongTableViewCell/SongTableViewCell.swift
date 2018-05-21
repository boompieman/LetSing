//
//  SearchResultTableViewCell.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/7.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit
import SDWebImage

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var youtubeImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateDataWith(title: String, imageUrl: String) {
        self.titleLabel.text = title


        self.youtubeImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
    }
    
}
