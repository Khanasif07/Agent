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
    func garageRegistrationFailed(msg: String)
    func switchGarageRegistrationSuccess(code: Int, msg : String)
    func switchGarageRegistrationFailure(msg: String)
    func completeProfileSuccess(msg: String)
    func completeProfileFailure(msg: String)

}

extension GarageRegistrationVMDelegate {
    func garageRegistrationSuccess(msg: String){}
    func garageRegistrationFailed(msg: String){}
    func switchGarageRegistrationSuccess(code: Int, msg : String){}
    func switchGarageRegistrationFailure(msg: String){}
    func completeProfileSuccess(msg: String){}
    func completeProfileFailure(msg: String){}
}
class GarageRegistrationVM {
    
    // MARK: Variables
    //=================================
    weak var delegate: GarageRegistrationVMDelegate?
    var model = GarageProfileModel()
    // MARK: Functions
    //=================================
    func setGarageRegistration(params: JSONDictionary,loader: Bool = false) {
        WebServices.garageRegistration(parameters: params, success: { [weak self] (msg) in
            guard let `self` = self else { return }
            self.delegate?.garageRegistrationSuccess(msg: msg)
//            let msg = json[ApiKey.message].stringValue
            printDebug(msg)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.garageRegistrationFailed(msg: error.localizedDescription)
        }
    }
    
    func switchGarageProfile() {
        
        WebServices.switchProfile(parameters: [:], success: { [weak self] (json) in
            guard let `self` = self else { return }
            let code = json[ApiKey.statusCode].intValue
            let msg = json[ApiKey.message].stringValue
            self.delegate?.switchGarageRegistrationSuccess(code: code,msg : msg)
            
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.switchGarageRegistrationFailure(msg: error.localizedDescription)
        }
    }
    
    func garageProfile(params: JSONDictionary) {
        
        WebServices.completeGarageProfile(parameters: params, success: { [weak self] (msg) in
            guard let `self` = self else { return }
            self.delegate?.completeProfileSuccess(msg : msg)
            
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.completeProfileFailure(msg: error.localizedDescription)
        }
    }
    
}
