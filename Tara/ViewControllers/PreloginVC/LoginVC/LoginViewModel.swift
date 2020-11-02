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
            AppUserDefaults.save(value: json[ApiKey.data][ApiKey.phoneVerified].boolValue, forKey: .phoneNoVerified)
            AppUserDefaults.save(value: json[ApiKey.data][ApiKey.isGarrage].boolValue, forKey: .isGarrage)
            AppUserDefaults.save(value: json[ApiKey.data][ApiKey.currentRole].stringValue, forKey: .currentUserType)
            AppUserDefaults.save(value: json[ApiKey.data][ApiKey._id].stringValue, forKey: .userId)
            self.addUser(parameters: parameters, user: user)
        }) { (error) -> (Void) in
            if (error as NSError).code == 401 {
                self.delegate?.emailNotVerified(message: error.localizedDescription)
            }else {
                self.delegate?.signInFailed(message: error.localizedDescription)
            }
        }
    }
    //Add User in FireStore
    private func addUser(parameters: JSONDictionary, user: UserModel) {
        if let email = parameters[ApiKey.email] as? String, let password = parameters[ApiKey.password] as? String {
            FirestoreController.login(userId: user.id, withEmail: email, with: password, success: {
                FirestoreController.setFirebaseData(userId: user.id, email: user.email, password: password, name: user.name, imageURL: user.image, phoneNo: user.countryCode + "" + user.phoneNo, status: "", completion: {
                    self.delegate?.signInSuccess(userModel: user)
                }) { (error) -> (Void) in
                    self.delegate?.signInFailed(message: error.localizedDescription)
                }
            }) { (error, code) in
                if code == 17011 {
                    FirestoreController.createUserNode(userId: user.id, email: user.email, password: password, name: user.name, imageURL: user.image, phoneNo: user.countryCode + "" + user.phoneNo, status: "", completion: {
                        self.delegate?.signInSuccess(userModel: user)
                    }) { (error) -> (Void) in
                        self.delegate?.signInFailed(message: error.localizedDescription)
                    }
                } else {
                    self.delegate?.signInFailed(message: "Please try again")
                }
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
        var socialParams = parameters
        if !TyreRequestModel.shared.quantity.isEmpty{
            socialParams[ApiKey.makeUser] = true
        }
        WebServices.socialLoginAPI(parameters: socialParams, success: { (json) in
            let user = UserModel(json[ApiKey.data])
            UserModel.main = user
            let accessToken = json[ApiKey.data][ApiKey.authToken].stringValue
            AppUserDefaults.save(value: accessToken, forKey: .accesstoken)
            AppUserDefaults.save(value: json[ApiKey.data][ApiKey.currentRole].stringValue, forKey: .currentUserType)
            AppUserDefaults.save(value: json[ApiKey.data][ApiKey._id].stringValue, forKey: .userId)
            AppUserDefaults.save(value: json[ApiKey.data][ApiKey.phoneVerified].boolValue, forKey: .phoneNoVerified)
            self.addUser(parameters: parameters, user: user)
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
    
    func sendOtp(params: JSONDictionary,loader: Bool = true) {
        WebServices.sendOtpThroughPhone(parameters: params, success: { (json) in
            self.delegate?.sendOtpForSocialLoginSuccess(message:"")
            printDebug(json)
        }) { (error) in
            self.delegate?.sendOtpForSocialLoginFailed(message: error.localizedDescription)
        }
    }
}
