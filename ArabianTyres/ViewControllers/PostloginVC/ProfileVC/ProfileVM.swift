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
}

class ProfileVM {
    
    // MARK: Variables
    //=================================
    weak var delegate: ProfileVMDelegate?
    var userModel = UserModel()
    
    // MARK: Functions
    //=================================
    func getMyProfileData(params: JSONDictionary,loader: Bool = false) {
        WebServices.getMyProfileData(parameters: params, success: { [weak self] (json) in
            guard let `self` = self else { return }
            let msg = json[ApiKey.message].stringValue
            self.userModel = UserModel(json[ApiKey.data])
            self.delegate?.getProfileDataSuccess(msg:msg)
            printDebug(json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.getProfileDataFailed(msg: error.localizedDescription,error: error)
        }
    }
    
}
