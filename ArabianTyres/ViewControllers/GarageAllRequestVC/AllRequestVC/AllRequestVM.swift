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
      func getGarageRequestData(params: JSONDictionary,loader: Bool = false) {
          WebServices.getGarageRequestListing(parameters: params, success: { [weak self] (json) in
              guard let `self` = self else { return }
              self.parseToMakeListingData(result: json)
             
              printDebug(json)
          }) { [weak self] (error) in
              guard let `self` = self else { return }
            self.delegate?.getGarageListingDataFailed(error: error.localizedDescription)
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
                    let modelList = try JSONDecoder().decode([GarageRequestModel].self, from: data)
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
    }


