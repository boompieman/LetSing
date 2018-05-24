//
//  LoginViewController.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/24.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController {

    private let ref = Database.database().reference()

    @IBOutlet weak var loginInputView: LoginInputView!
    @IBOutlet weak var loginButtonView: LoginButtonView!
    let manager = LoginManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLoginButton()
        
    }

    @IBAction func loginFacebook() {

        manager.facebookLogin { [weak self] (error, token) in

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
            print(token)
//            self?.signupUser(token: token!)
        }
    }

//    private func signupUser(token: String) {
//
//        let credential = FacebookAuthProvider.credential(withAccessToken: token)
//
//        Auth.auth().signIn(with: credential, completion: { (user, error) in
//            if let error = error {
//                print("Login error: \(error.localizedDescription)")
//                return
//            }
//            if let FIRUser = user {
//
//                let userData = ["name": FIRUser.displayName ,"email": FIRUser.email, "image": FIRUser.photoURL?.absoluteString] as [String : Any]
//                self.ref.child("users").child(FIRUser.uid).updateChildValues(userData)
//
//                self.saveToken(FIRUser.uid)
//
//                DispatchQueue.main.async {
//
//                    guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
//
//                    delegate.window?.rootViewController = UIStoryboard.mainStoryboard().instantiateInitialViewController()
//                }
//            }
//        })
//
//        //        UserManager.shared.loginUser(
//        //            facebookToken: token,
//        //            success: { _ in
//        //
//        //                DispatchQueue.main.async {
//        //
//        //                    guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        //
//        //                    delegate.window?.rootViewController = UIStoryboard.mainStoryboard().instantiateInitialViewController()
//        //                }
//        //            },
//        //            failure: { _ in
//        //
//        //            }
//        //        )
//    }
}
