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
    func getfacilitySuccess()
    func getfacilityFailure()

}

extension GarageRegistrationVMDelegate {
    func garageRegistrationSuccess(msg: String){}
    func garageRegistrationFailed(msg: String){}
    func switchGarageRegistrationSuccess(code: Int, msg : String){}
    func switchGarageRegistrationFailure(msg: String){}
    func completeProfileSuccess(msg: String){}
    func completeProfileFailure(msg: String){}
    func getfacilitySuccess(){}
    func getfacilityFailure(){}

}
class GarageRegistrationVM {
    
    // MARK: Variables
    //=================================
    var facilityDataArr : [FacilityModel] = []
    weak var delegate: GarageRegistrationVMDelegate?
    var model = GarageProfileModel()
    var hideLoader: Bool = false
    var currentPage = 1
    var totalPages = 1
    var nextPageAvailable = true
    var isRequestinApi = false
    var showPaginationLoader: Bool {
        return  hideLoader ? false : nextPageAvailable
    }
    
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
            AppUserDefaults.save(value: json[ApiKey.data][ApiKey.currentRole].stringValue, forKey: .currentUserType)
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
    
    func fetchFacilityList(params: JSONDictionary,loader: Bool = true,pagination: Bool = false) {
        if pagination {
            guard nextPageAvailable, !isRequestinApi else { return }
        } else {
            guard !isRequestinApi else { return }
        }
        isRequestinApi = true
        WebServices.userServiceList(parameters: params, success: { [weak self] (json) in
            guard let `self` = self else { return }
            let arr = json[ApiKey.data][ApiKey.result].arrayValue.map({FacilityModel.init($0)})
            self.facilityDataArr = arr
            self.delegate?.getfacilitySuccess()
       
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.getfacilityFailure()

        }
    }
}
