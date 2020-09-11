//
//  ResetPasswordVM.swift
//  ArabianTyres
//
//  Created by Admin on 08/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol ResetPasswordVMDelegate: class {
    func resetPasswordSuccess(message: String)
    func resetPasswordFailed(error:String)
}

extension ResetPasswordVMDelegate {
    func resetPasswordSuccess(message: String) {}
    func resetPasswordFailed(error:String) {}
}

class ResetPasswordVM{
    
    //MARK:- Variables
    //================
    var resetToken: String = ""
    var newPassword: String = ""
    var confirmNewPassword: String = ""
    weak var delegate: ResetPasswordVMDelegate?
    
    //MARK:- Functions
    //Function for verify OTP
    func resetPassword(dict: JSONDictionary){
        WebServices.resetPassword(parameters: dict, success: { (json) in
            self.delegate?.resetPasswordSuccess(message: "")
            }) { (error) -> (Void) in
                self.delegate?.resetPasswordFailed(error: error.localizedDescription)
            }
    }
    
    func checkResetPassValidations() -> (status: Bool, message: String) {
        var validationStatus = true
        var errorMessage = ""
        
        if self.newPassword.isEmpty{
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterPassword.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        if self.confirmNewPassword.isEmpty{
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterPassword.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        if !newPassword.checkIfValid(.password) {
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterValidPassword.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        if !confirmNewPassword.checkIfValid(.password) {
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterValidPassword.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        if newPassword != confirmNewPassword{
            validationStatus = false
            errorMessage = LocalizedString.passwordDoesNotMatch.localized
            return (status: validationStatus, message: errorMessage)
        }
        return (status: validationStatus, message: errorMessage)
    }
}
