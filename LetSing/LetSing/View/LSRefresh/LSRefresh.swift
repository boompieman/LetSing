//
//  LSRefresh.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/28.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import MJRefresh

struct LSRefresh {

    static func footer ( completion: @escaping () -> Void ) -> MJRefreshAutoNormalFooter? {

        let footer = MJRefreshAutoNormalFooter(refreshingBlock: completion)

        footer?.setTitle("Loading", for: .idle)

        footer?.setTitle("Loading", for: .pulling)

        footer?.setTitle("Loading", for: .willRefresh)

        footer?.setTitle("Refreshing", for: .refreshing)

        footer?.setTitle("No more data !", for: .noMoreData)

        return footer
    }
}
