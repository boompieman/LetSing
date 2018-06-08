//
//  UserInfoView.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/24.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class UserInfoView: UIView {

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {

//        imageView.layer.borderWidth = 1

        imageView.layer.cornerRadius = 40

        imageView.clipsToBounds = true

        imageView.contentMode = .scaleAspectFill

    }

    func updateProfileWith(image imageString: String) {

        imageView.sd_setImage(with: URL(string: imageString), completed: nil)

    }
    

}
