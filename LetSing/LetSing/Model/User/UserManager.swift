//
//  UserManager.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/24.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase

class UserManager {

    static let shared = UserManager()
    private let ref = Database.database().reference()

    func getUserToken() -> String? {
        let token = UserDefaults.standard.value(forKey: "UserID")

        guard let tokenString = token as? String else { return nil }

        return tokenString
    }

    func loginUserFromFacebook(
        facebookToken: String,
        success: @escaping (User) -> Void,
        failure: @escaping (LSError) -> Void
    ) {
        let credential = FacebookAuthProvider.credential(withAccessToken: facebookToken)

        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if let error = error {
                print("Login error: \(error.localizedDescription)")

                return
            }
            
            if let FIRUser = user {

                let LSUser = User(name: FIRUser.displayName!, email: FIRUser.email!, image: (FIRUser.photoURL?.absoluteString)!, id: FIRUser.uid)

                let userData = ["name": FIRUser.displayName ,"email": FIRUser.email, "image": FIRUser.photoURL?.absoluteString] as [String : Any]
                self.ref.child("users").child(FIRUser.uid).updateChildValues(userData)

                self.saveToken(FIRUser.uid)

                success(LSUser)
            }
        })

        failure(LSError.loginFacebookReject)
    }


    private func saveToken(_ token: String) {

        UserDefaults.standard.set(token, forKey: "UserID")
        UserDefaults.standard.synchronize()
    }


}
