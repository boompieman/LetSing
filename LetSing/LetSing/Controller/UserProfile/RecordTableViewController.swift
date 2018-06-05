//
//  RecordTableViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/6/5.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import UIKit

class RecordTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    

    var records = [Record]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.records = LSRecordFileManager.shared.fetchAllRecords()
        self.tableView.reloadData()
    }

    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: String(describing: UserVideoTableViewCell.self), bundle: nil)

        self.tableView.register(nib, forCellReuseIdentifier: String(describing: UserVideoTableViewCell.self))

        tableView.contentInset = LSConstants.tableViewInset
    }
}

extension RecordTableViewController: UITableViewDelegate, UITableViewDataSource {

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

        tableViewCell.titleLabel.text = self.records[indexPath.row].title

        print(self.records[indexPath.row].videoUrl.absoluteString.components(separatedBy: "/"))

        return tableViewCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: String(describing: VideoPlayerViewController.self), sender: indexPath)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actionArray = [UITableViewRowAction]()

        let actionEdit = UITableViewRowAction(style: .default, title:"編輯") { (action, indexPath) in

            let alert = AlertManager.shared.showEdit(
                with: "編輯標題",
                message: nil,
                placeholder: "請輸入標題..",
                completion: { (text) in
                    LSRecordFileManager.shared.updateRecordTitle(from: self.records[indexPath.row].videoUrl, to: text)
                    self.records[indexPath.row].title = text
                    self.tableView.isEditing = false
                    self.tableView.reloadData()
            })

            self.present(alert, animated: true, completion: nil)
        }

        actionEdit.backgroundColor = UIColor.orange

        let actionDelete = UITableViewRowAction(style: .default, title: "刪除") { (action, indexPath) in
            LSRecordFileManager.shared.deleteRecord(at: self.records[indexPath.row].videoUrl)
            self.records.remove(at: indexPath.row)
            tableView.isEditing = false
            tableView.reloadData()
        }

        actionDelete.backgroundColor = UIColor.red
        actionArray.append(actionDelete)
        actionArray.append(actionEdit)

        return actionArray
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let identifier = segue.identifier else { return }

        if identifier == String(describing: VideoPlayerViewController.self) {

            if let indexPath = self.tableView.indexPathForSelectedRow {

                let destinationVC = segue.destination as? VideoPlayerViewController
                destinationVC?.videoURL = self.records[indexPath.row].videoUrl
            }
        }
    }
}
