//
//  GarageRegistrationVM.swift
//  ArabianTyres
//
//  Created by Arvind on 15/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//



import Foundation
import SwiftyJSON

protocol GarageRegistrationVMDelegate: class {
    func garageRegistrationSuccess(msg: String)
    func garageRegistrationFailed(msg: String, error: Error)
    
}

class GarageRegistrationVM {
    
    // MARK: Variables
    //=================================
    weak var delegate: ProfileVMDelegate?
    var model = GarageProfileModel()
    // MARK: Functions
    //=================================
    func setGarageRegistration(params: JSONDictionary,loader: Bool = false) {
        WebServices.garageRegistration(parameters: params, success: { [weak self] (msg) in
            guard let `self` = self else { return }
//            let msg = json[ApiKey.message].stringValue
            printDebug(msg)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.getProfileDataFailed(msg: error.localizedDescription,error: error)
        }
    }
}
