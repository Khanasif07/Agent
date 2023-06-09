//
//  ProfileVM.swift
//  ArabianTyres
//
//  Created by Admin on 10/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import Foundation
import SwiftyJSON

protocol ProfileVMDelegate: class {
    func getProfileDataSuccess(msg: String)
    func getProfileDataFailed(msg: String, error: Error)
    func resendOtpSuccess(msg: String)
    func resendOtpFailed(msg: String, error: Error)
    func sendVerificationLinkSuccess(msg: String)
    func sendVerificationLinkFailed(msg: String,error: Error)
}

extension ProfileVMDelegate {
    func getProfileDataSuccess(msg: String){}
    func getProfileDataFailed(msg: String, error: Error){}
    func resendOtpSuccess(msg: String){}
    func resendOtpFailed(msg: String, error: Error){}
    func sendVerificationLinkSuccess(msg: String){}
    func sendVerificationLinkFailed(msg: String,error: Error){}
}

class ProfileVM {
    
    // MARK: Variables
    //=================================
    weak var delegate: ProfileVMDelegate?
    var userModel = UserModel()
    var preFillModel = GarageProfilePreFillModel()

    // MARK: Functions
    //=================================
    func getMyProfileData(params: JSONDictionary,loader: Bool = false) {
        WebServices.getMyProfileData(parameters: params,loader:loader, success: { [weak self] (json) in
            guard let `self` = self else { return }
            let msg = json[ApiKey.message].stringValue
            self.userModel = UserModel(json[ApiKey.data])
            if !json[ApiKey.data][ApiKey._id].stringValue.isEmpty{
            UserModel.main =  self.userModel
            }
            AppUserDefaults.save(value: json[ApiKey.data][ApiKey.phoneVerified].boolValue, forKey: .phoneNoVerified)
            AppUserDefaults.save(value: json[ApiKey.data][ApiKey.emailVerified].boolValue, forKey: .emailVerified)
            AppUserDefaults.save(value: json[ApiKey.data][ApiKey.isGarrage].boolValue, forKey: .isGarrage)
            AppUserDefaults.save(value: json[ApiKey.data][ApiKey._id].stringValue, forKey: .userId)
            let currentRole = json[ApiKey.data][ApiKey.currentRole].stringValue
            if !currentRole.isEmpty {
                AppUserDefaults.save(value: currentRole, forKey: .currentUserType)
            }
            self.preFillModel = GarageProfilePreFillModel(json[ApiKey.data][ApiKey.garageProfile])
            self.preFillModel.updateGarageProfileModel(self.preFillModel)
            self.delegate?.getProfileDataSuccess(msg:msg)
            printDebug(json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.getProfileDataFailed(msg: error.localizedDescription,error: error)
        }
    }
    
    func resendOTP(dict: JSONDictionary){
        WebServices.sendOtpThroughPhone(parameters: dict, success: { (message) in
            self.delegate?.resendOtpSuccess(msg: message)
        }) { (error) -> (Void) in
            self.delegate?.resendOtpFailed(msg: error.localizedDescription, error: error)
        }
    }
    
    
    func sendVerificationLink(dict: JSONDictionary){
        WebServices.sendVerificationLink(parameters: dict, success: { (json) in
            let msg = json[ApiKey.message].stringValue
            self.delegate?.sendVerificationLinkSuccess(msg: msg)
        }) { (error) -> (Void) in
            self.delegate?.sendVerificationLinkFailed(msg: error.localizedDescription, error: error)
        }
    }
    
}
