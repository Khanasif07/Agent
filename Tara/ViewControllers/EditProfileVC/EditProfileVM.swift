//
//  EditProfileVM.swift
//  Tara
//
//  Created by Admin on 31/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON


protocol EditProfileVMDelegate: class {
    func getEditProfileVMSuccess(msg: String,statusCode : Int)
    func getEditProfileVMFailed(msg: String, error: Error)
}

class EditProfileVM {
    
    // MARK: Variables
    //=================================
    weak var delegate: EditProfileVMDelegate?
    var userModel = UserModel()
    
    // MARK: Functions
    //=================================
    func postEditProfileData(params: JSONDictionary,loader: Bool = false) {
        WebServices.postEditProfileData(parameters: params, success: { [weak self] (json) in
            guard let `self` = self else { return }
            let msg = json[ApiKey.message].stringValue
            let statusCode = json[ApiKey.statusCode].intValue
            self.delegate?.getEditProfileVMSuccess(msg:msg, statusCode : statusCode)
            printDebug(json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.getEditProfileVMFailed(msg: error.localizedDescription,error: error)
        }
    }
}
