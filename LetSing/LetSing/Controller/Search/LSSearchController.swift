//
//  LSSearchController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/7.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

protocol LSSearchControllerDelegate: class {

    func didStartSearching()

    func didTapOnSearchButton(searchText: String)

    func didTapOnCancelButton()

    func didChangeSearchText(searchText: String)
}

class LSSearchController: UISearchController {

    var customSearchBar: LSSearchBar!
    weak var searchBarDelegate: LSSearchControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(searchResultsController: UIViewController!, searchBarFrame: CGRect, searchBarFont: UIFont, searchBarTextColor: UIColor, searchBarTintColor: UIColor) {
        super.init(searchResultsController: searchResultsController)

        configureSearchBar(frame: searchBarFrame, font: searchBarFont, textColor: searchBarTextColor, bgColor: searchBarTintColor)
    }

    func configureSearchBar(frame: CGRect, font: UIFont, textColor: UIColor, bgColor: UIColor) {
        customSearchBar = LSSearchBar(frame: frame, font: font, textColor: textColor)

        customSearchBar.barTintColor = bgColor
        customSearchBar.tintColor = textColor
        customSearchBar.showsBookmarkButton = false
        customSearchBar.showsCancelButton = false

        customSearchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LSSearchController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarDelegate?.didStartSearching()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        customSearchBar.resignFirstResponder()

        guard let searchText = searchBar.text else {
            return
        }

        searchBarDelegate?.didTapOnSearchButton(searchText: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        customSearchBar.resignFirstResponder()
        searchBarDelegate?.didTapOnCancelButton()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarDelegate?.didChangeSearchText(searchText: searchText)
    }
}
