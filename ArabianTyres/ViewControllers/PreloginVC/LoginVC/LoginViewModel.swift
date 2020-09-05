//
//  LoginViewModel.swift
//  ArabianTyres
//
//  Created by Admin on 04/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol SignInVMDelegate: NSObjectProtocol {
    
    func willSignIn()
    func signUpSuccess(userModel: UserModel)
    func signUpFailed(message: String)
    func invalidInput(message: String)
}

struct LoginViewModel {
    
    var model = SignUpModel()
    weak var delegate: SignInVMDelegate?
    
    func signIn(_ parameters: JSONDictionary) {
        WebServices.login(parameters: parameters, success: { (user) in
            let userModel = UserModel()
            self.delegate?.signUpSuccess(userModel: userModel)
        }) { (error) -> (Void) in
            self.delegate?.signUpFailed(message: error.localizedDescription)
        }
    }
    
    func checkSignupValidations(parameters: JSONDictionary) -> (status: Bool, message: String) {
        var validationStatus = true
        var errorMessage = ""
        guard let email = parameters[ApiKey.email] as? String else{
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterEmail.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        guard let password = parameters[ApiKey.password] as? String, !password.isEmpty  else{
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterPassword.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        if !email.checkIfValid(.email) {
            validationStatus = false
            errorMessage =  LocalizedString.pleaseEnterValidEmail.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        if !password.checkIfValid(.password) {
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterValidPassword.localized
            return (status: validationStatus, message: errorMessage)
        }
        return (status: validationStatus, message: errorMessage)
    }
    
}
