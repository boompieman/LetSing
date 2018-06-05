//
//  MainViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/2.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit
import Crashlytics

class SearchViewController: UIViewController {

    var searchController: LSSearchController!

    @IBOutlet weak var tableView: UITableView!

    var isSetupTableView: Bool = false

    private var searchText = LSConstants.emptyString

    private var pageToken = LSConstants.emptyString

    var songManager = SongManager()

    var songs = [Song]()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCustomSearchController()

//        setupTableView()

        searchController.searchBarDelegate = self

        songManager.delegate = self
    }

    func setupTableView() {

        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (self.tabBarController?.tabBar.frame.height)!, right: 0)

        self.tableView.delegate = self
        self.tableView.dataSource = self

        let nib = UINib(nibName: String(describing: SongTableViewCell.self), bundle: nil)

        self.tableView.register(nib, forCellReuseIdentifier: String(describing: SongTableViewCell.self))

        self.tableView.mj_footer = LSRefresh.footer { [weak self] in
            self?.songManager.getSearchResult(searchText: (self?.searchText)!, pageToken: (self?.pageToken)!)
        }

        self.tableView.separatorStyle = .singleLine
    }

    func configureCustomSearchController() {

//        self.navigationController?.isNavigationBarHidden = false

        let barFrame = CGRect(x: 0.0, y: 0.0, width: (self.navigationController?.navigationBar.frame.width)!, height: (self.navigationController?.navigationBar.frame.height)!)

        searchController = LSSearchController(searchResultsController: self, searchBarFrame: barFrame, searchBarFont: UIFont(name: "Futura", size: 16.0)!, searchBarTextColor: UIColor.white, searchBarTintColor: UIColor(red: 215/255, green: 68/255, blue: 62/255, alpha: 1))

//        LSSearchController.searchBarDelegate = self

        self.navigationItem.titleView = searchController.customSearchBar
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SongTableViewCell.self), for: indexPath)

        guard let searchResultTableViewCell = cell as? SongTableViewCell else {return cell}

        searchResultTableViewCell.updateDataWith(title: songs[indexPath.row].name, imageUrl: songs[indexPath.row].image)

        return searchResultTableViewCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)


        guard let recordController = UIStoryboard.recordStoryboard().instantiateViewController(
            withIdentifier: String(describing: RecordViewController.self)
            ) as? RecordViewController else { return }

        recordController.song = songs[indexPath.row]
        show(recordController, sender: nil)
    }
}

extension SearchViewController: SongManagerDelegate {

    func manager(_ manager: SongManager, didGet songs: [Song], _ pageToken: String) {

        guard songs.count > 0 else{
            self.tableView.mj_footer.endRefreshingWithNoMoreData()

            return
        }

        for song in songs {
            self.songs.append(song)
        }
        
        self.pageToken = pageToken
        
        self.tableView.reloadData()
        self.tableView.mj_footer.endRefreshing()
    }
}

extension SearchViewController: LSSearchControllerDelegate {
    func didStartSearching() {

        searchController.customSearchBar.showsCancelButton = true
    }

    func didTapOnSearchButton(searchText: String) {

        self.searchText = searchText

        searchController.customSearchBar.showsCancelButton = false
        self.songs.removeAll()
        songManager.getSearchResult(searchText: searchText, pageToken: LSConstants.emptyString)


        if !isSetupTableView {

            self.setupTableView()
            isSetupTableView = true
        }
    }

    func didTapOnCancelButton() {

        searchController.customSearchBar.showsCancelButton = false
    }

    func didChangeSearchText(searchText: String) {

    }
}
