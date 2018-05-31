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

    let manager = RecordManager()

    var records = [URL]()

    override func viewDidLoad() {
        super.viewDidLoad()

        requestProfile()
        setupTableView()

        manager.getRecordFromRealm()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.records = LSRecordFileManager.shared.fetchAllRecords()
        self.tableView.reloadData()
    }

    func requestProfile() {

        UserManager.shared.getUserProfile(success: { (user) in
                self.userInfoView.updateProfileWith(name: user.name, image: user.image)
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

        return self.records.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let tableViewCell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: UserVideoTableViewCell.self),
            for: indexPath
            ) as! UserVideoTableViewCell

        tableViewCell.urlLabel.text = self.records[indexPath.row].absoluteString

        return tableViewCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: String(describing: VideoPlayerViewController.self), sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let identifier = segue.identifier else { return }

        if identifier == String(describing: VideoPlayerViewController.self) {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {

                let destinationVC = segue.destination as? VideoPlayerViewController
                destinationVC?.videoURL = self.records[indexPath.row]
            }
        }
    }
}
