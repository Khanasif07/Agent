//
//  GarageHomeVM.swift
//  ArabianTyres
//
//  Created by Admin on 27/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GarageHomeModel {
    var newRequests: Int
    var acceptedRequets: Int
    var garageId: String
    var ratingCount: Int
    var averageRating : Double
    var ongoingServices : Int
    var revenue : Double
    var servicesCompletedToday : Int
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json : JSON = JSON()){
        self.newRequests = json[ApiKey.newRequests].intValue
        self.acceptedRequets = json[ApiKey.acceptedRequets].intValue
        self.ratingCount = json[ApiKey.ratingCount].intValue
        self.averageRating = json[ApiKey.averageRating].doubleValue
        self.garageId = json[ApiKey.garageId].stringValue
        self.ongoingServices = json[ApiKey.ongoingServices].intValue
        self.revenue = json[ApiKey.revenue].doubleValue
        self.servicesCompletedToday = json[ApiKey.servicesCompletedToday].intValue

    }
    
}

protocol GarageHomeVMDelegate: class {
    func getGarageHomeDataSuccess(msg: String)
    func getGarageHomeDataFailed(msg: String, error: Error)
    func getAdminIdSuccess(id: String, name: String, image: String)
    func getAdminIdFailed(msg: String)

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
    
    func getAdminId(dict: JSONDictionary,loader: Bool){
        WebServices.getAdminId(parameters: dict,loader: loader, success: { (json) in
            let addminId = json[ApiKey.data][ApiKey.id].stringValue
            let name = json[ApiKey.data][ApiKey.name].stringValue
            let image = json[ApiKey.data][ApiKey.image].stringValue
            self.delegate?.getAdminIdSuccess(id: addminId, name: name,image: image)
        }) { (error) -> (Void) in
            self.delegate?.getAdminIdFailed(msg: error.localizedDescription)
        }
    }
}
