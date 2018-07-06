//
//  AppDelegate.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/1.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FirebaseApp.configure()

        Fabric.with([Crashlytics.self])

        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent

        FBSDKApplicationDelegate.sharedInstance()

//        setUserActivityForHighlightSearch()

        switchToMainStoryBoard()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of
        //  temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data,
        // invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([Any]?) -> Void) -> Bool {

        let mainController = (window!.rootViewController! as! TabBarViewController).viewControllers?.first

        print(mainController)

        mainController?.restoreUserActivityState(userActivity)

//        guard userActivity.activityType == Song.domainIdentifier,
//            let songData = userActivity.userInfo?["song"] as? Data else { return false }
//
//        let song = try? JSONDecoder().decode(Song.self, from: songData)
//
//        guard let recordController = UIStoryboard.recordStoryboard().instantiateViewController(
//            withIdentifier: String(describing: RecordViewController.self)
//            ) as? RecordViewController else { return false}
//
//        recordController.song = song

        return true
    }

//    func application(application: UIApplication,
//                     continueUserActivity userActivity: NSUserActivity,
//                     restorationHandler: ([AnyObject]?) -> Void) -> Bool {


//        if let nav = window?.rootViewController as? UINavigationController,
//            let discoverViewController = nav.viewControllers.first as? DiscoverViewController,
//            let song = EmployeeService().employeeWithObjectId(objectId) {
//            nav.popToRootViewControllerAnimated(false)
//
//            guard let recordController = UIStoryboard.recordStoryboard().instantiateViewController(
//                withIdentifier: String(describing: RecordViewController.self)
//                ) as? RecordViewController else { return }
//
//            recordController.song = song
//            nav.pushViewController(recordController, animated: false)
//            return true
//        }
//
//        return false

//        return true
//    }

    func switchToMainStoryBoard() {

        if !Thread.current.isMainThread {

            DispatchQueue.main.async { [weak self] in

                self?.switchToMainStoryBoard()
            }

            return
        }

        window?.rootViewController = UIStoryboard.mainStoryboard().instantiateInitialViewController()


    }

    func setUserActivityForHighlightSearch() {
        let activity = NSUserActivity(activityType: "com.letSing.appWorksSchool")
        activity.title = "來唱"
        activity.isEligibleForSearch = true
        activity.keywords = Set(arrayLiteral: "LetSing", "來唱", "卡拉OK")

        self.userActivity = activity
        activity.becomeCurrent()
    }


}
