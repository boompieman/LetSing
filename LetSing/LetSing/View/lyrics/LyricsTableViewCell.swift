//
//  LyricsTableViewCell.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/18.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

class LyricsTableViewCell: UITableViewCell {

    @IBOutlet weak var lineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updatelineWith(line: String) {
        lineLabel.text = line
    }

    
    
}
