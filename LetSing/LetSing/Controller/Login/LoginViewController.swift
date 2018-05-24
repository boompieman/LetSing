//
//  LoginViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/24.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginInputView: LoginInputView!
    @IBOutlet weak var loginButtonView: LoginButtonView!
    let loginManager = LoginManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func loginFacebook() {

        loginManager.facebookLogin { [weak self] (error, token) in

            guard error == nil else {

                switch error! {

                case .loginFacebookReject:

                    return

                default:

                    let alert = AlertManager.shared.showAlert(
                        with: "error",
                        message: error!.rawValue,
                        completion: { }
                    )

                    self?.present(alert, animated: true, completion: nil)

                    return
                }
            }

            guard token != nil else { return }
            self?.signupUser(token: token!)
        }
    }

    private func signupUser(token: String) {

        UserManager.shared.loginUserFromFacebook(
            facebookToken: token,
            success: { [weak self] (user) in

                print("-------",user.name,"---------")

                DispatchQueue.main.async {

                    guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }

                    delegate.window?.rootViewController = UIStoryboard.mainStoryboard().instantiateInitialViewController()
                }
        },
            failure: { (error) in
                print(error)
        })
    }
}
