//
//  LoginInputView.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/24.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import UIKit

class LoginInputView: UIView {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var cornerView: UIView!

    @IBOutlet weak var loginButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    private func setupView() {

        emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)

        cornerView.layer.cornerRadius = 5
        cornerView.clipsToBounds = true

        loginButton.layer.cornerRadius = 5
    }

}
