//
//  Webservice+EndPoints.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

let baseUrl = "http://arabiantyersdevapi.appskeeper.com"
//API path: http://arabiantyersdevapi.appskeeper.com/api/v1/
//Swagger Url: http://arabiantyersdevapi.appskeeper.com/api-docs/swagger
let settingsUrl = ""

extension WebServices {
    
    enum EndPoint : String {
        case login = "user/login"
        case signUp = "user/signup"
        case verifyOtp = "user/verifyOtp"
        case resendOtp = "user/resendOtp"
        case forgetPassword = "user/forgetPassword"
        case resetPassword =  "user/resetPassword"
        case verifyforgetPasswordOtp = "user/verifyforgetPasswordOtp"
        case logOut = "user/logout"
        case socialLogin = "user/socialLogin"
        case socialSignup = "user/socialSignup"

        var path : String {
            let url = baseUrl
            return url + self.rawValue
        }
        
        var settingsPath: String {
            let url = settingsUrl
            return url + self.rawValue
        }
    }
}
