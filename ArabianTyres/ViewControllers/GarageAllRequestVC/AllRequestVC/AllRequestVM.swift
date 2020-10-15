//
//  AllRequestVM.swift
//  ArabianTyres
//
//  Created by Arvind on 07/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import Foundation
import SwiftyJSON

protocol AllRequestVMDelegate: class {
    func getGarageListingDataSuccess(message: String)
    func getGarageListingDataFailed(error:String)
    func cancelGarageRequestSuccess(message: String)
    func cancelGarageRequestFailure(error:String)
    func cancelBidSuccess(message: String)
    func cancelBidFailure(error:String)
}

extension AllRequestVMDelegate {
    func cancelGarageRequestSuccess(message: String) {}
    func cancelGarageRequestFailure(error:String) {}
    func cancelBidSuccess(message: String){}
    func cancelBidFailure(error:String){}
}

class AllRequestVM {
    
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
    
    var garageRequestListing = [GarageRequestModel]()
    weak var delegate: AllRequestVMDelegate?
    
    // MARK: Functions
    //=================================
    func getGarageRequestData(params: JSONDictionary,loader: Bool = false,pagination: Bool = false) {
        if pagination {
            guard nextPageAvailable, !isRequestinApi else { return }
        } else {
            guard !isRequestinApi else { return }
        }
        isRequestinApi = true
        WebServices.getGarageRequestListing(parameters: params,loader: loader, success: { [weak self] (json) in
            guard let `self` = self else { return }
            self.parseToMakeListingData(result: json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.getGarageListingDataFailed(error: error.localizedDescription)
        }
    }
    
    func cancelBid(params: JSONDictionary,loader: Bool = true,pagination: Bool = false) {
      
        WebServices.bidCancelByUser(parameters: params, success: { [weak self] (json) in
            guard let `self` = self else { return }
            self.delegate?.cancelBidSuccess(message: "")
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.cancelBidFailure(error: error.localizedDescription)
        }
    }
    
    func parseToMakeListingData(result: JSON) {
        if let jsonString = result[ApiKey.data][ApiKey.result].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                if result[ApiKey.data][ApiKey.result].arrayValue.isEmpty {
                    self.hideLoader = true
                    self.garageRequestListing = []
                    isRequestinApi = false
                    self.delegate?.getGarageListingDataSuccess(message: "")
                    return
                }
                let modelList = try! JSONDecoder().decode([GarageRequestModel].self, from: data)
                printDebug(modelList)
                currentPage = result[ApiKey.data][ApiKey.page].intValue
                isRequestinApi = false
                if currentPage == 1 {
                    self.garageRequestListing = modelList
                } else {
                    self.garageRequestListing.append(contentsOf: modelList)
                }
                nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
                currentPage += 1
                self.delegate?.getGarageListingDataSuccess(message: "")
            } catch {
                isRequestinApi = false
                self.delegate?.getGarageListingDataFailed(error: "error occured")
                printDebug("error occured")
            }
        }
    }
    
    func rejectGarageRequest(params: JSONDictionary,loader: Bool = true,pagination: Bool = false){
        
        WebServices.cancelGarageRequest(parameters: params, success: { (json) in
            self.delegate?.cancelGarageRequestSuccess(message: "")
        }) { (error) -> (Void) in
            self.delegate?.cancelGarageRequestFailure(error: error.localizedDescription)
        }
    }
}


