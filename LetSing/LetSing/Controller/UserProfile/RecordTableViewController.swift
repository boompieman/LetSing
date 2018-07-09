//
//  RecordTableViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/6/5.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

class RecordTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var records = [Record]()

    private let dataTransformer = LSDataTransformer()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.records = LSRecordFileManager.shared.fetchAllRecords()

        if self.records.count != 0 {
            self.tableView.reloadData()
            startUserActivity()
        }
    }

    deinit {
        stopUserActivity()
    }

    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: String(describing: UserVideoTableViewCell.self), bundle: nil)

        self.tableView.register(nib, forCellReuseIdentifier: String(describing: UserVideoTableViewCell.self))

        self.tableView.contentInset = LSConstants.tableViewInset
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

//        let distance = scrollView.contentOffset.y + userInfoViewHeight
//        self.delegate?.tableViewDidScroll(self, translation: distance)
    }

    @objc func moreButtonDidTapped(_ sender: UIButton) {

        guard let cell = sender.superview?.superview as? UserVideoTableViewCell,
            let indexPath = tableView.indexPath(for: cell) else { return }

        guard let urlScheme = URL(string: LSConstants.InstagramAPI.SCHEMEURL) else {
            return
        }

        if UIApplication.shared.canOpenURL(urlScheme) {
            let pasteboardItems = [["com.instagram.sharedSticker.backgroundVideo" : dataTransformer.videoToData(url: self.records[indexPath.row].videoUrl)]]

            let pasteboardOptions = [UIPasteboardOption.expirationDate : Date(timeIntervalSinceNow: 60 * 5)]

            UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)

            UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
        }

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
                self.records = LSRecordFileManager.shared.fetchAllRecords()
                self.tableView.isEditing = false
                self.tableView.reloadData()
        })

        return alert
    }

    private func deleteRecord(indexPath: IndexPath) {
        LSRecordFileManager.shared.deleteRecord(at: self.records[indexPath.row].videoUrl)
        self.records = LSRecordFileManager.shared.fetchAllRecords()
        self.tableView.isEditing = false
        self.tableView.reloadData()
    }

    private func startUserActivity() {
        let activity = NSUserActivity(activityType: LSConstants.UserActivity.TypeUserRecordView)
        activity.title = "Record List"
        activity.userInfo = [LSConstants.UserActivity.RecordsKey: ["record 1", "record 2", "record 3"]]
        userActivity = activity
        userActivity?.becomeCurrent()
    }

    // 更新userActivity的狀態
    override func updateUserActivityState(_ activity: NSUserActivity) {

        // 小資料傳遞用userInfo，大資料用 getContinuationStreams
        activity.addUserInfoEntries(from: [LSConstants.UserActivity.RecordsKey: ["record 1", "record 2", "record 3"]])
        super.updateUserActivityState(activity)
    }

    private func stopUserActivity() {
        userActivity?.invalidate()
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

        return LSConstants.recordCellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let tableViewCell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: UserVideoTableViewCell.self),
            for: indexPath
            ) as? UserVideoTableViewCell else { return UITableViewCell()}

        let currentRecord = records[indexPath.row]

        tableViewCell.updateCellWith(
            title: currentRecord.title,
            createdTime: currentRecord.createdTimeString
        )

        tableViewCell.moreButton.addTarget(
            self,
            action: #selector(moreButtonDidTapped(_:)),
            for: .touchUpInside)

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
