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
    func signUpSuccess(userModel: UserModel)
    func signUpFailed(message: String)
    func invalidInput(message: String)
}


struct SignUpViewModel {
    
    var model = SignUpModel()
    weak var delegate: SignUpVMDelegate?
    
    func signUp(_ parameters: JSONDictionary) {
        
        guard inputsValidity(parameters: parameters) else { return }
        
        WebServices.signUp(parameters: parameters, success: { (user) in
//            let userModel = UserModel(parameters)
            self.delegate?.signUpSuccess(userModel: UserModel())
        }) { (error) -> (Void) in
            self.delegate?.signUpFailed(message: error.localizedDescription)
        }
    }
    
    func checkValidity(dictionary: JSONDictionary) {
        guard inputsValidity(parameters: dictionary) else { return }
    }
    

    
    /// Inputs Validity
    private func inputsValidity(parameters: JSONDictionary) -> Bool {
        
        if let name = parameters[ApiKey.name] as? String {
            if name.count < 3 || name.count > 30 {
//                self.delegate?.invalidInput(message: LocalizedString.nameLengthTooLong.localized)
                return false
            }
        }
        
        if let phone = parameters[ApiKey.phoneNo] as? String {
            if !phone.isEmpty {
                if phone.count < 3 || phone.count > 15 {
//                    self.delegate?.invalidInput(message: LocalizedString.phoneLengthTooLong.localized)
                    return false
                }
            }
        }
        
        if let email = parameters[ApiKey.email] as? String {
            if email.count < 3 || email.count > 60 {
//                self.delegate?.invalidInput(message: LocalizedString.invalidEmail.localized)
                return false
            } else if email.checkIfInvalid(.email) {
//                self.delegate?.invalidInput(message: LocalizedString.invalidEmail.localized)
                return false
            }
        }
        
        if let password = parameters[ApiKey.password] as? String, !password.isEmpty {
            if password.count < 6 || password.count > 32  {
//                self.delegate?.invalidInput(message: LocalizedString.passwordInvalidLength.localized)
                return false
            } else if password.checkIfInvalid(.password) {
//                self.delegate?.invalidInput(message: LocalizedString.invalidPassword.localized)
                return false
            }
        } else {
//            self.delegate?.invalidInput(message: LocalizedString.enterPassword.localized)
            return false
        }
        return true
    }
    
}
