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
    func loginWithPhoneSuccess(msg: String,statusCode:Int)
    func loginWithPhoneFailed(msg: String, error: Error)
    func forgotPasswordSuccess(msg: String)
    func forgotPasswordFailed(msg: String, error: Error)
    func addPhoneNumbersSuccess(msg: String)
    func addPhoneNumberFailed(msg: String)
}

class LoginWithPhoneViewModel {
    
    // MARK: Variables
    //=================================
    var isComefromForgotpass : Bool = false
    var countryCode: String = "+966"
    var phoneNo: String  = ""
    weak var delegate: LoginWithPhoneVMDelegate?
    var loginModel = UserModel()
    
    // MARK: Functions
    //=================================
    func sendOtp(params: JSONDictionary,loader: Bool = false) {
        WebServices.sendOtpThroughPhone(parameters: params, success: { [weak self] (json) in
            guard let `self` = self else { return }
            self.delegate?.loginWithPhoneSuccess(msg:"",statusCode: 200)
            printDebug(json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            if (error as NSError).code == 404 {
                self.delegate?.loginWithPhoneFailed(msg: error.localizedDescription,error: error)
            }else {
                self.delegate?.loginWithPhoneFailed(msg: error.localizedDescription,error: error)
            }
        }
    }
    
    func forgotPassword(params: JSONDictionary,loader: Bool = false) {
        WebServices.forgotPassword(parameters: params, success: { [weak self] (json) in
            guard let `self` = self else { return }
            self.delegate?.forgotPasswordSuccess(msg:"")
            printDebug(json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.forgotPasswordFailed(msg: error.localizedDescription,error: error)
        }
    }
    
    func addPhoneNumber(params: JSONDictionary,loader: Bool = false) {
        WebServices.addPhoneNumber(parameters: params, success: { [weak self] (json) in
            guard let `self` = self else { return }
            self.delegate?.addPhoneNumbersSuccess(msg: "")
            printDebug(json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.addPhoneNumberFailed(msg: error.localizedDescription)
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
        return (status: validationStatus, message: errorMessage)
    }
}
