//
//  AlertManager.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/24.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit
class AlertManager {

    static let shared = AlertManager()

    private init() { }

    typealias ActionHandler = (UIAlertAction) -> Void

    func showEdit(with title: String, message: String?, placeholder: String?, completion: @escaping (String) -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        var text = LSConstants.emptyString

        alertController.addTextField { (textField) in
            textField.placeholder = placeholder

            textField.text = text
        }

        let action = UIAlertAction(title: "確定", style: .default) { _ in


            completion((alertController.textFields?.first?.text!)!)
        }

        alertController.addAction(action);

        return alertController
    }

    func showAlert(with title: String, message: String, completion: @escaping () -> Void) -> UIAlertController {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: "確定", style: .default) { _ in
            completion()
        }

        alertController.addAction(action)

        return alertController
    }

    func showActionSheet(
        defaultOptions: [String],
        defaultCompletion: ActionHandler?,
        destructiveOptions: [String],
        destrctiveCompletion: ActionHandler?
        ) -> UIAlertController {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let action = UIAlertAction(
            title: NSLocalizedString(
                "Cancel",
                comment: ""
            ),
            style: .cancel,
            handler: nil
        )

        alertController.addAction(action)

        for item in defaultOptions {

            let action = UIAlertAction(title: item, style: .default, handler: { action in
                defaultCompletion?(action)
            })

            alertController.addAction(action)
        }

        for item in destructiveOptions {

            let action = UIAlertAction(title: item, style: .destructive, handler: { action in
                destrctiveCompletion?(action)
            })

            alertController.addAction(action)
        }

        return alertController
    }
}
