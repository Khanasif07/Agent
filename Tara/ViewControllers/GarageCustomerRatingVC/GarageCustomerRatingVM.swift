//
//  GarageCustomerRatingVM.swift
//  Tara
//
//  Created by Arvind on 11/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol GarageCustomerRatingVMDelegate: class {
    func customerRatingSuccess(msg: String)
    func customerRatingFailure(msg: String)
   
}

class GarageCustomerRatingVM {
    
    // MARK: Variables
    //=================================
    weak var delegate: GarageCustomerRatingVMDelegate?
    var garageCompletedDetail : GarageRequestModel? = nil
    var requestType: Category = .tyres
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
    func fetchCustomerRatingDetail(params: JSONDictionary,loader: Bool = false) {
        WebServices.getGarageCompletedServicesDetail(parameters: params, loader : loader,success: { [weak self] (json) in
            guard let `self` = self else { return }
            self.parseToMakeListingData(result: json)
            printDebug(json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.customerRatingFailure(msg: error.localizedDescription)
        }
    }
    
    
    func updateServiceStatus(params: JSONDictionary,loader: Bool = false) {
        WebServices.serviceStatusApi(parameters: params, loader : loader,success: { [weak self] (json) in
            guard let `self` = self else { return }
            let msg = json[ApiKey.message].stringValue
            let status = json[ApiKey.data][ApiKey.serviceStatus].stringValue
//            self.delegate?.updateServiceStatusSuccess(msg: msg)
            printDebug(json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
//            self.delegate?.updateServiceStatusFailed(msg: error.localizedDescription)
        }
    }
    
    func parseToMakeListingData(result: JSON) {
        if let jsonString = result[ApiKey.data].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                if result[ApiKey.data].isEmpty {
                    self.hideLoader = true
                    self.garageCompletedDetail = nil
                    isRequestinApi = false
                    self.delegate?.customerRatingSuccess(msg: "")
                    return
                }
                let modelList = try! JSONDecoder().decode(GarageRequestModel.self, from: data)
                currentPage = result[ApiKey.data][ApiKey.page].intValue
                isRequestinApi = false
                self.garageCompletedDetail = nil
                self.garageCompletedDetail = modelList
                printDebug(self.garageCompletedDetail)
                nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
                currentPage += 1
                self.delegate?.customerRatingSuccess(msg: "")
            } catch {
                isRequestinApi = false
                self.delegate?.customerRatingFailure(msg: "error occured")
                printDebug("error occured")
            }
        }
    }
}
