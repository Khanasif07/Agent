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
    func userQuerySuccess(msg: String)
    func userQueryFailure(msg: String)
}

extension EditProfileVMDelegate {
    func getEditProfileVMSuccess(msg: String,statusCode : Int) {}
    func getEditProfileVMFailed(msg: String, error: Error) {}
    func userQuerySuccess(msg: String) {}
    func userQueryFailure(msg: String){}
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
            FirestoreController.updateUserNode(name: json[ApiKey.data][ApiKey.name].stringValue, imageURL: json[ApiKey.data][ApiKey.image].stringValue, countryCode: json[ApiKey.data][ApiKey.countryCode].stringValue,email: json[ApiKey.data][ApiKey.email].stringValue,phoneNo: json[ApiKey.data][ApiKey.phoneNo].stringValue, completion: {
                 self.delegate?.getEditProfileVMSuccess(msg:msg, statusCode : statusCode)
            }) { (error) -> (Void) in
                 self.delegate?.getEditProfileVMSuccess(msg:msg, statusCode : statusCode)
            }
            printDebug(json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.getEditProfileVMFailed(msg: error.localizedDescription,error: error)
        }
    }
    
    func userQuery(params: JSONDictionary,loader: Bool = false) {
        WebServices.userQuery(parameters: params, loader: loader,success: { [weak self] (json) in
               guard let `self` = self else { return }
               let msg = json[ApiKey.message].stringValue
            _ = json[ApiKey.statusCode].intValue
               self.delegate?.userQuerySuccess(msg:msg)
               printDebug(json)
           }) { [weak self] (error) in
               guard let `self` = self else { return }
               self.delegate?.userQueryFailure(msg: error.localizedDescription)
           }
       }
}
