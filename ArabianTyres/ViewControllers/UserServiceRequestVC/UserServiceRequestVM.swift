//
//  UserServiceRequestVM.swift
//  ArabianTyres
//
//  Created by Admin on 08/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON


protocol UserServiceRequestVMDelegate: class {
    func getUserMyRequestDetailSuccess(message: String)
    func getUserMyRequestDetailFailed(error:String)
    func cancelUserMyRequestDetailSuccess(message: String)
    func cancelUserMyRequestDetailFailed(error:String)
}


class UserServiceRequestVM{
    
    //MARK:- Variables
    //================
    var serviceType: String  = ""
    var requestId: String  = ""
    var hideLoader: Bool = false
    var currentPage = 1
    var totalPages = 1
    var nextPageAvailable = true
    var isRequestinApi = false
    var showPaginationLoader: Bool {
        return  hideLoader ? false : nextPageAvailable
    }
    
    var userRequestDetail = UserServiceRequestModel()
    weak var delegate: UserServiceRequestVMDelegate?
    
    //MARK:- Functions
    
    
    func getUserMyRequestDetailData(params: JSONDictionary,loader: Bool = true,pagination: Bool = false){
        if pagination {
            guard nextPageAvailable, !isRequestinApi else { return }
        } else {
            guard !isRequestinApi else { return }
        }
        isRequestinApi = true
        WebServices.getUserMyRequestDetailData(parameters: params, success: { (json) in
            self.parseToMakeListingData(result: json)
        }) { (error) -> (Void) in
            self.delegate?.getUserMyRequestDetailFailed(error: error.localizedDescription)
        }
    }
    
    func cancelUserMyRequestDetailData(params: JSONDictionary,loader: Bool = true){
        WebServices.cancelUserMyRequestDetailData(parameters: params, success: { (json) in
            let msg = json[ApiKey.message].stringValue
            self.delegate?.cancelUserMyRequestDetailSuccess(message: msg)
        }) { (error) -> (Void) in
            self.delegate?.cancelUserMyRequestDetailFailed(error: error.localizedDescription)
        }
    }
    
    
    func parseToMakeListingData(result: JSON) {
        if let jsonString = result[ApiKey.data].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                let modelList = try JSONDecoder().decode(UserServiceRequestModel.self, from: data)
                printDebug(modelList)
                currentPage = result[ApiKey.data][ApiKey.page].intValue
                isRequestinApi = false
                self.userRequestDetail = modelList
                nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
                currentPage += 1
                self.delegate?.getUserMyRequestDetailSuccess(message: "")
            } catch {
                isRequestinApi = false
                self.delegate?.getUserMyRequestDetailFailed(error: "error occured")
                printDebug("error occured")
            }
        }
    }
}
