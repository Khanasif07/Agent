//
//  ServiceStatusVM.swift
//  Tara
//
//  Created by Arvind on 09/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON


protocol ServiceStatusVMDelegate: class {
    func bookedRequestDetailSuccess(msg: String)
    func bookedRequestDetailFailed(msg: String)
    func updateServiceStatusSuccess(msg: String)
    func updateServiceStatusFailed(msg: String)
}

class ServiceStatusVM {
    
    // MARK: Variables
    //=================================
    weak var delegate: ServiceStatusVMDelegate?
    var bookedRequestDetail : GarageRequestModel? = nil
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
    func fetchBookedRequestDetail(params: JSONDictionary,loader: Bool = false) {
        WebServices.getBookedRequestDetail(parameters: params, loader : loader,success: { [weak self] (json) in
            guard let `self` = self else { return }
            self.parseToMakeListingData(result: json)
            printDebug(json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.bookedRequestDetailFailed(msg: error.localizedDescription)
        }
    }
    
    
    func updateServiceStatus(params: JSONDictionary,loader: Bool = false) {
        WebServices.serviceStatusApi(parameters: params, loader : loader,success: { [weak self] (json) in
            guard let `self` = self else { return }
            let msg = json[ApiKey.message].stringValue
            let status = json[ApiKey.data][ApiKey.serviceStatus].stringValue
            self.bookedRequestDetail?.serviceStatus = ServiceState(rawValue: status)
            self.delegate?.updateServiceStatusSuccess(msg: msg)
            printDebug(json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.updateServiceStatusFailed(msg: error.localizedDescription)
        }
    }
    func sendOtpToStartService(params: JSONDictionary,loader: Bool = false,pagination: Bool = false) {
           WebServices.sendOtpToStartService(parameters: params,loader: loader, success: { [weak self] (json) in
               guard let `self` = self else { return }
               printDebug("Otp send to user")
           }) { [weak self] (error) in
               guard let `self` = self else { return }
               self.isRequestinApi = false
            self.delegate?.updateServiceStatusFailed(msg: error.localizedDescription)
           }
       }
    func parseToMakeListingData(result: JSON) {
        if let jsonString = result[ApiKey.data].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                if result[ApiKey.data].isEmpty {
                    self.hideLoader = true
                    self.bookedRequestDetail = nil
                    isRequestinApi = false
                    self.delegate?.bookedRequestDetailSuccess(msg: "")
                    return
                }
                let modelList = try JSONDecoder().decode(GarageRequestModel.self, from: data)
                currentPage = result[ApiKey.data][ApiKey.page].intValue
                isRequestinApi = false
                self.bookedRequestDetail = nil
                self.bookedRequestDetail = modelList
                printDebug(self.bookedRequestDetail)
                nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
                currentPage += 1
                self.delegate?.bookedRequestDetailSuccess(msg: "")
            } catch {
                isRequestinApi = false
                self.delegate?.bookedRequestDetailFailed(msg: "error occured")
                printDebug("error occured")
            }
        }
    }
}
