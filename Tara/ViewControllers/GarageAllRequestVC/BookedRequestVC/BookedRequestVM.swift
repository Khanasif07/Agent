//
//  BookedRequestVM.swift
//  Tara
//
//  Created by Arvind on 05/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol BookedRequestVMDelegate: class {
    func getBookedListingDataSuccess(message: String)
    func getBookedListingDataFailed(error:String)

}

extension BookedRequestVMDelegate {
}

class BookedRequestVM {
    
    //MARK:- Variables
    //================
    var makeId: String  = ""
    var searchText: String = ""
    var hideLoader: Bool = false
    var currentPage = 1
    var totalPages = 1
    var nextPageAvailable = true
    var isRequestinApi = false
    var showPaginationLoader: Bool {
        return  hideLoader ? false : nextPageAvailable
    }
    
    var bookedRequestListing = [GarageRequestModel]()
    weak var delegate: BookedRequestVMDelegate?
    
    // MARK: Functions
    //=================================
    func getBookedRequests(params: JSONDictionary,loader: Bool = false,pagination: Bool = false) {
        if pagination {
            guard nextPageAvailable, !isRequestinApi else { return }
        } else {
            guard !isRequestinApi else { return }
        }
        isRequestinApi = true
        WebServices.getBookedRequestData(parameters: params,loader: loader, success: { [weak self] (json) in
            guard let `self` = self else { return }
            self.parseToMakeListingData(result: json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.isRequestinApi = false
            self.delegate?.getBookedListingDataFailed(error: error.localizedDescription)
        }
    }
   
    func sendOtpToStartService(params: JSONDictionary,loader: Bool = false,pagination: Bool = false) {
        WebServices.sendOtpToStartService(parameters: params,loader: loader, success: { [weak self] (json) in
            guard let `self` = self else { return }
            printDebug("Otp send to user")
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.isRequestinApi = false
            self.delegate?.getBookedListingDataFailed(error: error.localizedDescription)
        }
    }
    
    
    func parseToMakeListingData(result: JSON) {
        if let jsonString = result[ApiKey.data][ApiKey.result].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                if result[ApiKey.data][ApiKey.result].arrayValue.isEmpty {
                    self.hideLoader = true
                    self.bookedRequestListing = []
                    isRequestinApi = false
                    self.delegate?.getBookedListingDataSuccess(message: "")
                    return
                }
                let modelList = try! JSONDecoder().decode([GarageRequestModel].self, from: data)
                printDebug(modelList)
                currentPage = result[ApiKey.data][ApiKey.page].intValue
                isRequestinApi = false
                if currentPage == 1 {
                    self.bookedRequestListing = modelList
                } else {
                    self.bookedRequestListing.append(contentsOf: modelList)
                }
                nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
                currentPage += 1
                self.delegate?.getBookedListingDataSuccess(message: "")
            } catch {
                isRequestinApi = false
                self.delegate?.getBookedListingDataFailed(error: "error occured")
                printDebug("error occured")
            }
        }
    }

}


