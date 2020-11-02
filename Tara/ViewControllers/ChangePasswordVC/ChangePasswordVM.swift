//
//  ChangePasswordVM.swift
//  Tara
//
//  Created by Admin on 02/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ChangePasswordModel{
    var oldPass: String = ""
    var newPass: String = ""
    var confirmPass: String = ""
    
    init(oldPass: String,newPass: String,confirmPass: String){
        self.oldPass = oldPass
        self.newPass = newPass
        self.confirmPass = confirmPass
    }
    
    init() {
    }
    
    func  getDict()->JSONDictionary{
        var dict = JSONDictionary()
        dict[ApiKey.oldPassword] = self.oldPass
        dict[ApiKey.newPassword] = self.newPass
        return dict
    }
    
}

protocol ChangePasswordVMDelegate: class {
    func changePasswordSuccess(msg: String)
    func changePasswordFailed(msg: String, error: Error)
}

class ChangePasswordVM {
    
    // MARK: Variables
    //=================================
    weak var delegate: ChangePasswordVMDelegate?
    var model = ChangePasswordModel()
    // MARK: Functions
    //=================================
    func changePasswordData(params: JSONDictionary,loader: Bool = false) {
        WebServices.changePasswordData(parameters: params, success: { [weak self] (json) in
            guard let `self` = self else { return }
            let msg = json[ApiKey.message].stringValue
            self.delegate?.changePasswordSuccess(msg:msg)
            printDebug(json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.changePasswordFailed(msg: error.localizedDescription,error: error)
        }
    }
    
    
    func checkChangePasswordValidations(parameters: JSONDictionary) -> (status: Bool, message: String) {
        var validationStatus = true
        var errorMessage = ""
        guard let password = parameters[ApiKey.oldPassword] as? String, !password.isEmpty  else{
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterPassword.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        if  self.model.newPass.isEmpty {
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterPassword.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        if !password.checkIfValid(.password) {
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterValidPassword.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        if password != self.model.confirmPass{
            validationStatus = false
            errorMessage = LocalizedString.passwordDoesNotMatch.localized
            return (status: validationStatus, message: errorMessage)
        }
        return (status: validationStatus, message: errorMessage)
    }
}
