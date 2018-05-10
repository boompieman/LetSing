//
//  TabBarViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/2.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

enum TabBar {

//    case main

    case discover

    case search
//
    case userProfile

//    case more

    func controller() -> UIViewController {

        switch self {

//        case .main:
//
//            return UIStoryboard.recommendationStoryboard().instantiateInitialViewController()!

        case .discover:

            return UIStoryboard.discoverStoryboard().instantiateInitialViewController()!

        case .search:

            return UIStoryboard.searchStoryboard().instantiateInitialViewController()!

        case .userProfile:

            return UIStoryboard.userProfileStoryboard().instantiateInitialViewController()!
//
//        case .more:
//
//            return UIStoryboard.profileStoryboard().instantiateInitialViewController()!

        }
    }

    func image() -> UIImage {

        switch self {

//        case .main:
//
//            return #imageLiteral(resourceName: "main_icon")

        case .discover:

            return #imageLiteral(resourceName: "discover")

        case .search:

            return #imageLiteral(resourceName: "search")

        case .userProfile:

            return #imageLiteral(resourceName: "userProfile")

//        case .more:
//
//            return #imageLiteral(resourceName: "more_icon")
        }
    }

    //    func selectedImage() -> UIImage {
    //
    //        switch self {
    //
    //        case .article:
    //
    //            return #imageLiteral(resourceName: "tab_main_normal").withRenderingMode(.alwaysTemplate)
    //
    //        case .discover:
    //
    //            return #imageLiteral(resourceName: "tab_discover_normal").withRenderingMode(.alwaysTemplate)
    //
    //        case .profile:
    //
    //            return #imageLiteral(resourceName: "tab_profile_normal").withRenderingMode(.alwaysTemplate)
    //        }
    //    }
}

class TabBarViewController: UITabBarController {

    let tabs: [TabBar] = [.discover, .search, .userProfile]

    override func viewDidLoad() {
        super.viewDidLoad()

//        //TODO
//        UserManager.shared.userProfile(
//            success: { _ in
//
//        },
//            failure: { _ in
//
//        }
//        )



        setupTab()
    }

    private func setupTab() {

        tabBar.tintColor = LetSingColor.tabBarTintColor.color()

        var controllers: [UIViewController] = []

        for tab in tabs {

            let controller = tab.controller()

            let item = UITabBarItem(
                title: nil,
                image: tab.image(),
                selectedImage: nil
            )

            


            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

            controller.tabBarItem = item

            controllers.append(controller)
        }



        setViewControllers(controllers, animated: false)
    }

}
