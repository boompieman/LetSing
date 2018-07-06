//
//  LetSingNavigationController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/2.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

class LetSingNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = .init(rawValue: 0)
        setupShadow()
    }

    private func setupShadow() {

        self.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        self.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.navigationBar.layer.shadowRadius = 5
        self.navigationBar.layer.shadowOpacity = 1

    }

    override func restoreUserActivityState(_ activity: NSUserActivity) {

        guard activity.activityType == Song.domainIdentifier,
            let songData = activity.userInfo?["song"] as? Data else { return }

        let song = try? JSONDecoder().decode(Song.self, from: songData)

        guard let recordController = UIStoryboard.recordStoryboard().instantiateViewController(
            withIdentifier: String(describing: RecordViewController.self)
            ) as? RecordViewController else { return }

        recordController.song = song

        show(recordController, sender: nil)

    }
}
