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

    case login

    case postProduction

    func controller() -> UIViewController {

        switch self {

        case .discover:

            return UIStoryboard.discoverStoryboard().instantiateInitialViewController()!

        case .search:

            return UIStoryboard.searchStoryboard().instantiateInitialViewController()!

        case .userProfile:

            return UIStoryboard.userProfileStoryboard().instantiateInitialViewController()!

        case .login:

            return UIStoryboard.loginStoryBoard().instantiateInitialViewController()!

        case .postProduction:

            return UIStoryboard.postProductionStoryBoard().instantiateInitialViewController()!

        }
    }

    func image() -> UIImage {

        switch self {

        case .discover:

            return #imageLiteral(resourceName: "discover")

        case .search:

            return #imageLiteral(resourceName: "search")

        case .userProfile, .login, .postProduction:

            return #imageLiteral(resourceName: "userProfile")

        }
    }

    func selectedImage() -> UIImage {

        switch self {

        case .discover:

            return #imageLiteral(resourceName: "discover").withRenderingMode(.alwaysTemplate)

        case .search:

            return #imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate)

        case .userProfile, .login, .postProduction:

            return #imageLiteral(resourceName: "userProfile").withRenderingMode(.alwaysTemplate)

        }
    }
}

class TabBarViewController: UITabBarController {

    var tabs = [TabBar]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // 等到userProfile做好再打開

//        if UserManager.shared.getUserToken() != nil {
//            tabs = [.discover, .search, .userProfile]
//        }
//        else {
//            tabs = [.discover, .search, .login]
//        }

        tabs = [.discover, .search, .postProduction]

        setupTab()
    }

    private func setupTab() {

        // 避免擋住tableView

        tabBar.tintColor = UIColor(red: 215/255, green: 68/255, blue: 62/255, alpha: 1.0)

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
