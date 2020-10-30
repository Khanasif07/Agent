//
//  GarageHomeVM.swift
//  ArabianTyres
//
//  Created by Admin on 27/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
//
//  ProfileVM.swift
//  ArabianTyres
//
//  Created by Admin on 10/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import Foundation
import SwiftyJSON

struct GarageHomeModel {
    var newRequests: Int
    var  acceptedRequets: Int
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json : JSON = JSON()){
        self.newRequests = json[ApiKey.newRequests].intValue
        self.acceptedRequets = json[ApiKey.acceptedRequets].intValue
    }
    
}

protocol GarageHomeVMDelegate: class {
    func getGarageHomeDataSuccess(msg: String)
    func getGarageHomeDataFailed(msg: String, error: Error)
}

class GarageHomeVM {
    
    // MARK: Variables
    //=================================
    weak var delegate: GarageHomeVMDelegate?
    var garageHomeModel = GarageHomeModel()
    
    // MARK: Functions
    //=================================
    func getGarageHomeData(params: JSONDictionary,loader: Bool = false) {
        WebServices.getGarageHomeData(parameters: params,loader: loader, success: { [weak self] (json) in
            guard let `self` = self else { return }
            let msg = json[ApiKey.message].stringValue
            self.garageHomeModel = GarageHomeModel.init(json[ApiKey.data])
            self.delegate?.getGarageHomeDataSuccess(msg:msg)
            printDebug(json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.getGarageHomeDataFailed(msg: error.localizedDescription,error: error)
        }
    }
}
