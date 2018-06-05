//
//  RecordTableViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/6/5.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import UIKit

protocol RecordTableViewControllerDelegate: class {
    func tableViewDidScroll(_ tableView: RecordTableViewController, translation: CGFloat)
}

class RecordTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    weak var delegate: RecordTableViewControllerDelegate?

    var records = [Record]()

    private let userInfoViewHeight: CGFloat = 180.0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 一滑動後，整個offset會變化，要讓userInfoView貼著tableView，所以要給一個userInfoViewHeight
        let distance = scrollView.contentOffset.y - (-userInfoViewHeight)



        self.delegate?.tableViewDidScroll(self, translation: distance)
    }

    //定義好物件與周圍的距離(Inset)與物件一開始的位置(Offset) // 180為 userInfoView 高度
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.tableView.contentInset = UIEdgeInsetsMake(userInfoViewHeight, 0, 49, 0)
        self.tableView.contentOffset = CGPoint(x: 0, y: -userInfoViewHeight)

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
