//
//  SearchResultTableViewCell.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/7.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit
import SDWebImage

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var youtubeImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateDataWith(title: String, imageUrl: String) {
        self.titleLabel.text = title



        self.youtubeImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
    }
    
}
