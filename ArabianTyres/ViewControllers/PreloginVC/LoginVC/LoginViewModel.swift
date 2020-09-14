//
//  LoginViewModel.swift
//  ArabianTyres
//
//  Created by Admin on 04/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol SignInVMDelegate: NSObjectProtocol {
    
    func signInSuccess(userModel: UserModel)
    func signInFailed(message: String)
    func socailLoginApiSuccess(message: String)
    func socailLoginApiSuccessWithoutPhoneNo(message: String)
    func socailLoginApiSuccessWithoutVerifyPhoneNo(message: String)
    func socailLoginApiFailure(message: String)
    func emailNotVerified(message: String)
    func sendOtpForSocialLoginSuccess(message: String)
    func sendOtpForSocialLoginFailed(message: String)
}

extension SignInVMDelegate {
    func socailLoginApiSuccess(message: String) {}
    func socailLoginApiFailure(message: String) {}
}

struct LoginViewModel {
    
    var model = SignUpModel()
    weak var delegate: SignInVMDelegate?
    
    func signIn(_ parameters: JSONDictionary) {
        WebServices.login(parameters: parameters, success: { (json) in
            let user = UserModel(json[ApiKey.data])
            UserModel.main = user
            let accessToken = json[ApiKey.data][ApiKey.authToken].stringValue
            AppUserDefaults.save(value: accessToken, forKey: .accesstoken)
            AppUserDefaults.save(value: json[ApiKey.data][ApiKey.userType].stringValue, forKey: .currentUserType)
            self.delegate?.signInSuccess(userModel: UserModel.main)
        }) { (error) -> (Void) in
            if (error as NSError).code == 401 {
                self.delegate?.emailNotVerified(message: error.localizedDescription)
            }else {
                self.delegate?.signInFailed(message: error.localizedDescription)
            }
        }
    }
    
    func checkSignInValidations(parameters: JSONDictionary) -> (status: Bool, message: String) {
        var validationStatus = true
        var errorMessage = ""
        guard let email = parameters[ApiKey.email] as? String,!email.isEmpty  else{
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterEmail.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        if !email.checkIfValid(.email) {
            validationStatus = false
            errorMessage =  LocalizedString.pleaseEnterValidEmail.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        guard let password = parameters[ApiKey.password] as? String, !password.isEmpty  else{
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterPassword.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        if !password.checkIfValid(.password) {
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterValidPassword.localized
            return (status: validationStatus, message: errorMessage)
        }
        return (status: validationStatus, message: errorMessage)
    }
    
    func socailLoginApi(parameters : JSONDictionary) {
        WebServices.socialLoginAPI(parameters: parameters, success: { (json) in
            let user = UserModel(json[ApiKey.data])
            UserModel.main = user
            let accessToken = json[ApiKey.data][ApiKey.authToken].stringValue
            AppUserDefaults.save(value: accessToken, forKey: .accesstoken)
            AppUserDefaults.save(value: "basic", forKey: .currentUserType)
            if UserModel.main.phoneNoAdded && UserModel.main.phoneVerified {
                self.delegate?.socailLoginApiSuccess(message: "")
                return
            }
            if !UserModel.main.phoneNoAdded{
                self.delegate?.socailLoginApiSuccessWithoutPhoneNo(message: "")
                return
            }
            if !UserModel.main.phoneVerified && UserModel.main.phoneNoAdded{
                self.delegate?.socailLoginApiSuccessWithoutVerifyPhoneNo(message: "")
                return
            }
          
        }) { (error) -> (Void) in
            self.delegate?.socailLoginApiFailure(message: error.localizedDescription)
            
        }
    }
    
    func sendOtp(params: JSONDictionary,loader: Bool = false) {
        WebServices.sendOtpThroughPhone(parameters: params, success: { (json) in
            self.delegate?.sendOtpForSocialLoginSuccess(message:"")
            printDebug(json)
        }) { (error) in
            self.delegate?.sendOtpForSocialLoginFailed(message: error.localizedDescription)
        }
    }
}
