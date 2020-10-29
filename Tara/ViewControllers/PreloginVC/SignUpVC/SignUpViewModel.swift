//
//  SignUpViewModel.swift
//  ArabianTyres
//
//  Created by Admin on 04/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol SignUpVMDelegate: NSObjectProtocol {
    
    func willSignUp()
    func signUpSuccess(message: String)
    func signUpFailed(message: String)
    func invalidInput(message: String)
    func socailLoginApiSuccessWithoutPhoneNo(message: String)
    func socailLoginApiSuccessWithoutVerifyPhoneNo(message: String)
    func sendOtpForSocialLoginFailed(message: String)
    func sendOtpForSocialLoginSuccess(message: String)
    func socailLoginApiSuccess(message: String)
    func socailLoginApiFailure(message: String)
}

extension SignUpVMDelegate {
    func socailLoginApiSuccess(message: String) {}
    func socailLoginApiFailure(message: String) {}
}

struct SignUpViewModel {
    
    var model = SignUpModel()
    weak var delegate: SignUpVMDelegate?
    
    func signUp(_ parameters: JSONDictionary) {
        WebServices.signUp(parameters: parameters, success: { (json) in
            self.delegate?.signUpSuccess(message: "Signup successfully, OTP sent to your phone number.")
        }) { (error) -> (Void) in
            self.delegate?.signUpFailed(message: error.localizedDescription)
        }
    }
    
    func checkSignupValidations(parameters: JSONDictionary) -> (status: Bool, message: String) {
        var validationStatus = true
        var errorMessage = ""
        
        guard let name = parameters[ApiKey.name] as? String, !name.isEmpty else{
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterName.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        if name.count < 2 {
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterMinTwoChar.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        guard let email = parameters[ApiKey.email] as? String ,!email.isEmpty  else{
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterEmail.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        if !email.checkIfValid(.email) {
            validationStatus = false
            errorMessage =  LocalizedString.pleaseEnterValidEmail.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        guard let phoneNo = parameters[ApiKey.phoneNo] as? String ,!phoneNo.isEmpty else{
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterPhoneNumber.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        if phoneNo.count < 7 {
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterminimumdigitsphonenumber.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        if !phoneNo.checkIfValid(.mobileNumber) {
            validationStatus = false
            errorMessage =  LocalizedString.pleaseEnterPhoneNumber.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        guard let password = parameters[ApiKey.password] as? String, !password.isEmpty  else{
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterPassword.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        if  self.model.confirmPasssword.isEmpty {
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterPassword.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        if !password.checkIfValid(.password) {
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterValidPassword.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        if password != self.model.confirmPasssword{
            validationStatus = false
            errorMessage = LocalizedString.passwordDoesNotMatch.localized
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
            AppUserDefaults.save(value: json[ApiKey.data][ApiKey.phoneVerified].boolValue, forKey: .phoneNoVerified)
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
            self.delegate?.socailLoginApiSuccess(message: "")
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
