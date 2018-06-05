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

    private let navBarHeightPlusStatusHeight: CGFloat = 64.0

    override func viewDidLoad() {
        super.viewDidLoad()

        requestProfile()
        childViewConfiguration()
    }

    func childViewConfiguration() {
        guard let recordTableVC = self.childViewControllers[0] as? RecordTableViewController else { return }

        recordTableVC.delegate = self
    }

    func requestProfile() {

        UserManager.shared.getUserProfile(success: { [weak self](user) in
            self?.userInfoView.updateProfileWith(name: user.name, image: user.image)
        }) { (error) in
            print(error)
        }
    }
}

extension userProfileViewController: RecordTableViewControllerDelegate {
    func tableViewDidScroll(_ tableView: RecordTableViewController, translation: CGFloat) {
        print(translation)
        self.userInfoView.frame = CGRect(x:0, y: navBarHeightPlusStatusHeight - translation, width: userInfoView.frame.width, height: 180)

//        self.view.bounds.origin.y = self.view.bounds.origin.y - translation
    }


}
