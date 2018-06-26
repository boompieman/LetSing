//
//  UserVideoTableViewCell.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/24.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

class UserVideoTableViewCell: UITableViewCell {

    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCellWith(title: String, createdTime: String) {
        self.titleLabel.text = title
        self.createdTimeLabel.text = createdTime
    }

}
