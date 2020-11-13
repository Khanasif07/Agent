//
//  UserServiceStatusVM.swift
//  Tara
//
//  Created by Arvind on 11/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import Foundation
import SwiftyJSON


protocol UserServiceStatusVMDelegate: class {
    func serviceDetailSuccess(msg: String)
    func serviceDetailFailed(msg: String)
    func markCarReceivedSuccess(msg: String)
    func markCarReceivedFailure(msg: String)
    func getAdminIdSuccess(id: String, name: String, image: String)
    func getAdminIdFailed(error:String)
}

class UserServiceStatusVM {
    
    // MARK: Variables
    //=================================
    weak var delegate: UserServiceStatusVMDelegate?
    var serviceDetailData : GarageRequestModel? = nil
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
    func fetchRequestDetail(params: JSONDictionary,loader: Bool = false) {
        WebServices.userServiceDetail(parameters: params, loader : loader,success: { [weak self] (json) in
            guard let `self` = self else { return }
            self.parseToMakeListingData(result: json)
            printDebug(json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.serviceDetailFailed(msg: error.localizedDescription)
        }
    }
 
    func carReceived(params: JSONDictionary,loader: Bool = false) {
           WebServices.markCarReceived(parameters: params, loader : loader,success: { [weak self] (json) in
            guard let `self` = self else { return }
            printDebug(json)
            self.delegate?.markCarReceivedSuccess(msg: "")
           }) { [weak self] (error) in
               guard let `self` = self else { return }
               self.delegate?.markCarReceivedFailure(msg: error.localizedDescription)
           }
       }
    
    func getAdminId(dict: JSONDictionary,loader: Bool){
        WebServices.getAdminId(parameters: dict,loader: loader, success: { (json) in
     
            let addminId = json[ApiKey.data][ApiKey.id].stringValue
            let name = json[ApiKey.data][ApiKey.name].stringValue
            let image = json[ApiKey.data][ApiKey.image].stringValue
            
            self.delegate?.getAdminIdSuccess(id: addminId, name: name,image: image)
        }) { (error) -> (Void) in
            self.delegate?.getAdminIdFailed(error: error.localizedDescription)
        }
    }

    func parseToMakeListingData(result: JSON) {
        if let jsonString = result[ApiKey.data].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                if result[ApiKey.data].isEmpty {
                    self.hideLoader = true
                    self.serviceDetailData = nil
                    isRequestinApi = false
                    self.delegate?.serviceDetailSuccess(msg: "")
                    return
                }
                let modelList = try! JSONDecoder().decode(GarageRequestModel.self, from: data)
                currentPage = result[ApiKey.data][ApiKey.page].intValue
                isRequestinApi = false
                self.serviceDetailData = nil
                self.serviceDetailData = modelList
                printDebug(self.serviceDetailData)
                nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
                currentPage += 1
                self.delegate?.serviceDetailSuccess(msg: "")
            } catch {
                isRequestinApi = false
                self.delegate?.serviceDetailFailed(msg: "error occured")
                printDebug("error occured")
            }
        }
    }
}
