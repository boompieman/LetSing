//
//  LoginButtonView.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/24.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import UIKit

class LoginButtonView: UIView {

    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var emailLoginButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    private func setupView() {
        facebookLoginButton.layer.cornerRadius = 25.0

        facebookLoginButton.tintColor = UIColor.gray

        facebookLoginButton.setTitleColor(UIColor.gray, for: .highlighted)

        //        FBLoginButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)

        //        FBLoginButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 50.0, bottom: 0.0, right: 0.0)
        //        FBLoginButton.contentHorizontalAlignment = .center

        emailLoginButton.layer.cornerRadius = 25.0

        emailLoginButton.tintColor = UIColor.gray

        emailLoginButton.setTitleColor(UIColor.gray, for: .highlighted)

        let iconFacebook = #imageLiteral(resourceName: "icon_facebook").withRenderingMode(.alwaysTemplate)

        facebookLoginButton.setImage(#imageLiteral(resourceName: "icon_facebook"), for: .normal)

        facebookLoginButton.setImage(iconFacebook, for: .highlighted)
    }
}
