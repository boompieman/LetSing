//
//  LSSearchBar.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/7.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

class LSSearchBar: UISearchBar {

    var preferredFont: UIFont!

    var preferredTextColor: UIColor!

    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)

        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor

        searchBarStyle = UISearchBarStyle.prominent
//        isTranslucent = false

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func indexOfSearchFieldInSubviews() -> Int! {
        var index: Int!
        let searchBarView = subviews[0]

        for i in 0...searchBarView.subviews.count {
            if searchBarView.subviews[i] is UITextField {
                index = i
                break
            }
        }
        return index
    }

    override func draw(_ rect: CGRect) {
        // Find the index of the search field in the search bar subviews.
        if let index = indexOfSearchFieldInSubviews() {
            // Access the search field
            let searchField: UITextField = subviews[0].subviews[index] as! UITextField

            // Set its frame.
            searchField.frame = CGRect(x: 20.0, y: 10.0, width: frame.size.width - 40.0, height: frame.size.height - 20.0)

            // Set the font and text color of the search field.
            searchField.font = preferredFont
            searchField.textColor = preferredTextColor

            // Set the background color of the search field.
            searchField.backgroundColor = barTintColor

            // Set the border
            searchField.layer.borderWidth = 1
            searchField.layer.borderColor = UIColor.white.cgColor
            searchField.layer.cornerRadius = 5

            // Set the placeholder

            searchField.attributedPlaceholder = NSAttributedString(string: "搜尋", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])

            searchField.clearButtonMode = .never

            if let leftImageView = searchField.leftView as? UIImageView {
                leftImageView.image = leftImageView.image?.transform(withNewColor: UIColor.white)
            }


        }

        // 下面那條橘色的線

//        let startPoint = CGPoint(x: 0.0, y: frame.size.height)
//        let endPoint = CGPoint(x: frame.size.width, y: frame.size.height)
//        let path = UIBezierPath()
//        path.move(to: startPoint)
//        path.addLine(to: endPoint)
//
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = path.cgPath
//        shapeLayer.strokeColor = preferredTextColor.cgColor
//        shapeLayer.lineWidth = 2.5
//        layer.addSublayer(shapeLayer)

        super.draw(rect)
    }
}
