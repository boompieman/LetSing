//
//  MainViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/2.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {

    var searchController: LSSearchController!

    @IBOutlet weak var tableView: UITableView!

    var songManager = SongManager()

    var songs = [Song]()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCustomSearchController()

        setupTableView()

        searchController.searchBarDelegate = self

        self.navigationController?.navigationBar.isHidden = false

        songManager.delegate = self
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }

    func setupTableView() {

        self.tableView.delegate = self
        self.tableView.dataSource = self

        let nib = UINib(nibName: String(describing: SearchResultTableViewCell.self), bundle: nil)

        self.tableView.register(nib, forCellReuseIdentifier: String(describing: SearchResultTableViewCell.self))
    }

    func configureCustomSearchController() {

//        self.navigationController?.isNavigationBarHidden = false

        print(self.navigationController) 

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

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultTableViewCell.self), for: indexPath)

        guard let searchResultTableViewCell = cell as? SearchResultTableViewCell else {return cell}

        searchResultTableViewCell.updateDataWith(title: songs[indexPath.row].name, imageUrl: songs[indexPath.row].image)

        return searchResultTableViewCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)

        guard let controller = UIStoryboard.recordStoryboard().instantiateViewController(
                withIdentifier: String(describing: RecordViewController.self)
            ) as? RecordViewController else { return }

        controller.song = songs[indexPath.row]

        show(controller, sender: nil)
    }
}

extension SearchViewController: SongManagerDelegate {

    func manager(_ manager: SongManager, didGet songs: [Song]) {
        self.songs = songs
        self.tableView.reloadData()
    }
}

extension SearchViewController: LSSearchControllerDelegate {
    func didStartSearching() {

        searchController.customSearchBar.showsCancelButton = true
        print("did start")
    }

    func didTapOnSearchButton(searchText: String) {
        searchController.customSearchBar.showsCancelButton = false
        songManager.getSearchResult(songName: searchText)
    }


    func didTapOnCancelButton() {
        searchController.customSearchBar.showsCancelButton = false
        print("did cancel")
    }

    func didChangeSearchText(searchText: String) {
        songManager.getSearchResult(songName: searchText)
        print("did change")
    }
}
