//
//  LoginManager.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/24.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import FBSDKLoginKit

struct LoginManager {

    private let httpClient = LSHTTPClient.shared

    func instagramLogin(completion: @escaping (_ error: LSError?, _ token: String?) -> Void) {

        

    }

    func facebookLogin(completion: @escaping (_ error: LSError?, _ token: String?) -> Void) {

        let manager = FBSDKLoginManager()

        manager.logIn(
            withReadPermissions: ["email", "public_profile"],
            from: nil,
            handler: { (result, error) -> Void in

                guard error == nil else {

                    completion(LSError.loginFacebookFail, nil)

                    return
                }

                guard let token = result?.token?.tokenString else {

                    completion(LSError.loginFacebookReject, nil)

                    return
                }

                completion(nil, token)
        })
    }
}
