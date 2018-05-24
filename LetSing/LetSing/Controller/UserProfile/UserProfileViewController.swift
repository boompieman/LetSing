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
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        requestProfile()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func requestProfile() {

        UserManager.shared.getUserProfile(success: { (user) in
            DispatchQueue.main.async {

                self.userInfoView.updateProfileWith(name: user.name, image: user.image)
            }
        }) { (error) in
            print(error)
        }

    }

    func setupTableView() {

        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: String(describing: UserVideoTableViewCell.self), bundle: nil)

        self.tableView.register(nib, forCellReuseIdentifier: String(describing: UserVideoTableViewCell.self))

        tableView.contentInset = LSConstants.tableViewInset
    }


}

extension userProfileViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 6
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let tableViewCell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: UserVideoTableViewCell.self),
            for: indexPath
            ) as! UserVideoTableViewCell

        return tableViewCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
}
