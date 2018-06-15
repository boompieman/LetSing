//
//  TabBarViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/2.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

enum TabBar {

    case discover

    case search

    case userProfile

    func controller() -> UIViewController {

        switch self {

        case .discover:

            return UIStoryboard.discoverStoryboard().instantiateInitialViewController()!

        case .search:

            return UIStoryboard.searchStoryboard().instantiateInitialViewController()!

        case .userProfile:

            return UIStoryboard.userProfileStoryboard().instantiateInitialViewController()!
        }
    }

    func image() -> UIImage {

        switch self {

        case .discover:

            return #imageLiteral(resourceName: "discover")

        case .search:

            return #imageLiteral(resourceName: "search")

        case .userProfile:

            return #imageLiteral(resourceName: "userProfile")

        }
    }

    func selectedImage() -> UIImage {

        switch self {

        case .discover:

            return #imageLiteral(resourceName: "discover").withRenderingMode(.alwaysTemplate)

        case .search:

            return #imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate)

        case .userProfile:

            return #imageLiteral(resourceName: "userProfile").withRenderingMode(.alwaysTemplate)

        }
    }
}

class TabBarViewController: UITabBarController {

    var tabs = [TabBar]()

    override func viewDidLoad() {
        super.viewDidLoad()

            tabs = [.discover, .search, .userProfile]

        setupTab()
    }

    private func setupTab() {

        tabBar.tintColor = UIColor(named: LSColor.brand.color())

        var controllers: [UIViewController] = []

        for tab in tabs {

            let controller = tab.controller()

            let item = UITabBarItem(
                title: nil,
                image: tab.image(),
                selectedImage: tab.selectedImage()
            )

            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

            controller.tabBarItem = item

            controllers.append(controller)
        }

        setViewControllers(controllers, animated: false)
    }

}
