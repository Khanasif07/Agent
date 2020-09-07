//
//  LoginWithPhoneViewModel.swift
//  ArabianTyres
//
//  Created by Admin on 06/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol LoginWithPhoneVMDelegate: class {
    func loginWithPhoneSuccess()
    func loginWithPhoneFailed(msg: String, error: Error)
}

class LoginWithPhoneViewModel {
    
    // MARK: Variables
    //=================================
    var countryCode: String = ""
    var phoneNo: String  = ""
    weak var delegate: LoginWithPhoneVMDelegate?
    var loginModel = UserModel()
    
    // MARK: Functions
    //=================================
    func sendOtp(params: JSONDictionary,loader: Bool = false) {
        WebServices.sendOtpThroughPhone(parameters: params, success: { [weak self] (json) in
            guard let `self` = self else { return }
            self.delegate?.loginWithPhoneSuccess()
            printDebug(json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            printDebug(error)
            self.delegate?.loginWithPhoneFailed(msg: error.localizedDescription, error: error)
        }
    }
    
    func checkSendOtpValidations(parameters: JSONDictionary) -> (status: Bool, message: String)  {
        var validationStatus = true
        var errorMessage = ""
        guard let phoneNo = parameters[ApiKey.phoneNo] as? String ,!phoneNo.isEmpty else{
            validationStatus = false
            errorMessage = LocalizedString.pleaseEnterPhoneNumber.localized
            return (status: validationStatus, message: errorMessage)
        }
        
        if !phoneNo.checkIfValid(.mobileNumber) {
            validationStatus = false
            errorMessage =  LocalizedString.pleaseEnterPhoneNumber.localized
            return (status: validationStatus, message: errorMessage)
        }
        return (status: validationStatus, message: errorMessage)
    }
}
