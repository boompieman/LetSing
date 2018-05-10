//
//  LSYoutubeTimerTransformer.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/10.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//
import Foundation

struct LSYoutubeTimerTransformer {

    func time(_ time: String) -> String {

        guard let floatTime = Float(time) else {

            return "Nah"

        }

        let times = Int(floatTime)

        let hour = times / 3600

        let min = times % 3600 / 60

        let second = times % 3600 % 60

        return manipulateTime(hour: hour, minute: min, second: second)
    }

    private func min(_ minute: Int) -> String {
        if minute < 10 {
            return "0\(minute)"
        }

        return "\(minute)"
    }

    private func sec(_ second: Int) -> String {
        if second < 10 {
            return "0\(second)"
        }

        return "\(second)"
    }

    private func manipulateTime(hour: Int, minute: Int, second: Int) -> String {

        if hour == 0 {
            return "\(min(minute)):\(sec(second))"
        }

        return "\(hour):\(min(minute)):\(sec(second))"
    }
}

