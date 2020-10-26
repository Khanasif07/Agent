//
//  UserAllRequestVM.swift
//  ArabianTyres
//
//  Created by Admin on 07/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import Foundation
import SwiftyJSON


protocol UserAllRequestVMDelegate: class {
    func getUserMyRequestDataSuccess(message: String)
    func mgetUserMyRequestDataFailed(error:String)
    func resendRequsetSuccess(message: String)
    func resendRequsetFailure(error: String)

}


class UserAllRequestVM{
    
    //MARK:- Variables
    //================
    var searchText: String = ""
    var hideLoader: Bool = false
    var currentPage = 1
    var totalPages = 1
    var nextPageAvailable = true
    var isRequestinApi = false
    var showPaginationLoader: Bool {
        return  hideLoader ? false : nextPageAvailable
    }
    
    var userRequestListing = [UserServiceRequestModel]()
    weak var delegate: UserAllRequestVMDelegate?
    
    //MARK:- Functions
    func resendRequest(params: JSONDictionary,loader: Bool = true) {
        WebServices.userRequestResend(parameters: params,loader: loader,success: { (json) in
            self.delegate?.resendRequsetSuccess(message: "")
        }) { (error) -> (Void) in
            self.delegate?.resendRequsetFailure(error: error.localizedDescription)
        }
    }
    
    func getUserMyRequestData(params: JSONDictionary,loader: Bool = true,pagination: Bool = false){
        if pagination {
            guard nextPageAvailable, !isRequestinApi else { return }
        } else {
            guard !isRequestinApi else { return }
        }
        isRequestinApi = true
        WebServices.getUserMyRequestData(parameters: params,loader: loader,success: { (json) in
            self.parseToMakeListingData(result: json)
        }) { (error) -> (Void) in
            self.delegate?.mgetUserMyRequestDataFailed(error: error.localizedDescription)
        }
    }
    
    func parseToMakeListingData(result: JSON) {
        if let jsonString = result[ApiKey.data][ApiKey.result].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                if result[ApiKey.data][ApiKey.result].arrayValue.isEmpty {
                    self.hideLoader = true
                    self.userRequestListing = []
                    isRequestinApi = false
                    self.delegate?.getUserMyRequestDataSuccess(message: "")
                    return
                }
                let modelList = try! JSONDecoder().decode([UserServiceRequestModel].self, from: data)
                printDebug(modelList)
                currentPage = result[ApiKey.data][ApiKey.page].intValue
                isRequestinApi = false
                if currentPage == 1 {
                    self.userRequestListing = modelList
                } else {
                    self.userRequestListing.append(contentsOf: modelList)
                }
                nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
                currentPage += 1
                self.delegate?.getUserMyRequestDataSuccess(message: "")
            } catch {
                isRequestinApi = false
                self.delegate?.mgetUserMyRequestDataFailed(error: "error occured")
                printDebug("error occured")
            }
        }
    }
}
