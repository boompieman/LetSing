//
//  UserProfileViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/2.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import UIKit

class userProfileViewController: UIViewController {

    @IBOutlet weak var userInfoView: UserInfoView!

    var records = [Record]()

    override func viewDidLoad() {
        super.viewDidLoad()

        requestProfile()
        
    }

    func requestProfile() {

        UserManager.shared.getUserProfile(success: { [weak self](user) in
            self?.userInfoView.updateProfileWith(name: user.name, image: user.image)
        }) { (error) in
            print(error)
        }
    }
}
