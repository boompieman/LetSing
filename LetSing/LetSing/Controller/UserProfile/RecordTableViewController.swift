//
//  RecordTableViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/6/5.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.records = LSRecordFileManager.shared.fetchAllRecords()

        if self.records.count != 0 {
            self.tableView.reloadData()
        }
    }

    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: String(describing: UserVideoTableViewCell.self), bundle: nil)

        self.tableView.register(nib, forCellReuseIdentifier: String(describing: UserVideoTableViewCell.self))

//        self.tableView.contentInset = UIEdgeInsetsMake(userInfoViewHeight, 0, 49, 0)
        self.tableView.contentInset = LSConstants.tableViewInset

//        self.tableView.separatorStyle = .singleLine
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

//        let distance = scrollView.contentOffset.y + userInfoViewHeight
//
//        self.delegate?.tableViewDidScroll(self, translation: distance)
    }

    // MARK: private function
    private func generateEditAlert(indexPath: IndexPath) -> UIAlertController {
        let alert = AlertManager.shared.showEdit(
            with: NSLocalizedString(
                LSConstants.Localization.editTitle,
                comment: LSConstants.emptyString
            ),
            message: nil,
            placeholder: NSLocalizedString(
                LSConstants.Localization.editPlaceHolder,
                comment: LSConstants.emptyString
            ),
            completion: { (text) in
                LSRecordFileManager.shared.updateRecordTitle(from: self.records[indexPath.row].videoUrl, to: text)
                self.records[indexPath.row].title = text
                self.tableView.isEditing = false
                self.tableView.reloadData()
        })

        return alert
    }

    private func deleteRecord(indexPath: IndexPath) {
        LSRecordFileManager.shared.deleteRecord(at: self.records[indexPath.row].videoUrl)
        self.records.remove(at: indexPath.row)
        self.tableView.isEditing = false
        self.tableView.reloadData()
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

        return LSConstants.songCellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let tableViewCell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: UserVideoTableViewCell.self),
            for: indexPath
            ) as? UserVideoTableViewCell else { return UITableViewCell()}

        tableViewCell.titleLabel.text = self.records[indexPath.row].title

        return tableViewCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: String(describing: ReviewViewController.self), sender: indexPath)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actionArray = [UITableViewRowAction]()

        let actionEdit = UITableViewRowAction(
            style: .default,
            title: NSLocalizedString(
                LSConstants.Localization.edit,
                comment: LSConstants.emptyString)
            ) { (_, indexPath) in

            let alert = self.generateEditAlert(indexPath: indexPath)

            self.present(alert, animated: true, completion: nil)
        }

        actionEdit.backgroundColor = UIColor.orange

        let actionDelete = UITableViewRowAction(
        style: .default,
        title: NSLocalizedString(
            LSConstants.Localization.delete,
            comment: LSConstants.emptyString)) { (_, indexPath) in

            self.deleteRecord(indexPath: indexPath)
        }

        actionDelete.backgroundColor = UIColor.red

        actionArray.append(actionDelete)
        actionArray.append(actionEdit)

        return actionArray
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let identifier = segue.identifier else { return }

        if identifier == String(describing: ReviewViewController.self) {

            if let indexPath = self.tableView.indexPathForSelectedRow {

                let destinationVC = segue.destination as? ReviewViewController
                destinationVC?.videoURL = self.records[indexPath.row].videoUrl
            }
        }
    }
}
