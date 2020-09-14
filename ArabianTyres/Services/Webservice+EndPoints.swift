//
//  Webservice+EndPoints.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

let baseUrl = "http://arabiantyersqaapi.appskeeper.com/api/v1/"
//API path: http://arabiantyersdevapi.appskeeper.com/api/v1/
//Swagger Url: http://arabiantyersdevapi.appskeeper.com/api-docs/swagger
let settingsUrl = ""

extension WebServices {
    
    enum EndPoint : String {
        case login = "user/login"
        case signUp = "user/signup"
        case verifyOtp = "user/verifyOtp"
        case sendOtp = "user/sendOtp"
        case resendOtp = "user/resendOtp"
        case forgetPassword = "user/forgotPassword"
        case resetPassword =  "user/resetpassword"
        case verifyforgetPasswordOtp = "user/verifyforgetPasswordOtp"
        case logout = "user/logout"
        case socialLogin = "user/socialLogin"
        case socialSignup = "user/socialSignup"
        case myProfile = "user/myProfile"
        case emailVerificationLink = "user/emailVerificationLink"
        case addPhoneNo = "user/addPhoneNo"

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
