//
//  UserAllOfferVM.swift
//  ArabianTyres
//
//  Created by Arvind on 12/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import Foundation
import SwiftyJSON


protocol UserAllOfferVMDelegate: class {
    func getUserBidDataSuccess(message: String)
    func rejectUserBidDataSuccess(message: String)
    func getUserBidDataFailed(error:String)
    func rejectUserBidDataFailed(error:String)
}


class UserAllOfferVM{
    
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
    
    var userBidListingArr = [UserBidModel]()
    weak var delegate: UserAllOfferVMDelegate?
    
    //MARK:- Functions
    
    func rejectUserBidData(params: JSONDictionary){
        WebServices.rejectUserBidData(parameters: params, success: { (json) in
            self.delegate?.rejectUserBidDataSuccess(message: json[ApiKey.message].stringValue)
        }) { (error) -> (Void) in
            self.delegate?.rejectUserBidDataFailed(error: error.localizedDescription)
        }
    }
    
    func getUserBidData(params: JSONDictionary,loader: Bool = false,pagination: Bool = false){
        if pagination {
            guard nextPageAvailable, !isRequestinApi else { return }
        } else {
            guard !isRequestinApi else { return }
        }
        isRequestinApi = true
        WebServices.getUserBids(parameters: params,loader: loader, success: { (json) in
            self.parseToMakeListingData(result: json)
        }) { (error) -> (Void) in
            self.isRequestinApi = false
            self.delegate?.getUserBidDataFailed(error: error.localizedDescription)
        }
    }
    
    func parseToMakeListingData(result: JSON) {
        if let jsonString = result[ApiKey.data][ApiKey.result].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                if result[ApiKey.data][ApiKey.result].arrayValue.isEmpty {
                    self.hideLoader = true
                    self.userBidListingArr = []
                    isRequestinApi = false
                    self.delegate?.getUserBidDataSuccess(message: "")
                    return
                }
                let modelList = try JSONDecoder().decode([UserBidModel].self, from: data)
                printDebug(modelList)
                currentPage = result[ApiKey.data][ApiKey.page].intValue
                isRequestinApi = false
                if currentPage == 1 {
                    self.userBidListingArr = modelList
                } else {
                    self.userBidListingArr.append(contentsOf: modelList)
                }
                nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
                currentPage += 1
                self.delegate?.getUserBidDataSuccess(message: "")
            } catch {
                isRequestinApi = false
                self.delegate?.getUserBidDataFailed(error: "error occured")
                printDebug("error occured")
            }
        }
    }
}
