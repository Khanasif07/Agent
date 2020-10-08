//
//  GarageServiceRequestVM.swift
//  ArabianTyres
//
//  Created by Arvind on 07/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import Foundation
import SwiftyJSON

protocol GarageServiceRequestVMDelegate: class {
    func getGarageDetailSuccess(message: String)
    func getGarageDetailFailed(error:String)
    func brandListingSuccess(message: String)
    func brandListingFailed(error:String)
}

extension GarageServiceRequestVMDelegate {
    func brandListingSuccess(message: String){}
    func brandListingFailed(error:String){}
}

class GarageServiceRequestVM {

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
    
    var garageRequestDetailArr : GarageRequestModel? = nil
    var brandsListings:[PreferredBrand] = []
    weak var delegate: GarageServiceRequestVMDelegate?
    
    // MARK: Functions
      //=================================
      func getGarageRequestDetailData(params: JSONDictionary,loader: Bool = false) {
          WebServices.getGarageRequestDetail(parameters: params, success: { [weak self] (json) in
              guard let `self` = self else { return }
              self.parseToMakeListingData(result: json)
             
              printDebug(json)
          }) { [weak self] (error) in
              guard let `self` = self else { return }
            self.delegate?.getGarageDetailFailed(error: error.localizedDescription)
          }
      }
    

        func parseToMakeListingData(result: JSON) {
            if let jsonString = result[ApiKey.data].rawString(), let data = jsonString.data(using: .utf8) {
                do {
                    if result[ApiKey.data].isEmpty {
                        self.hideLoader = true
                        self.garageRequestDetailArr = nil
                        isRequestinApi = false
                        self.delegate?.getGarageDetailSuccess(message: "")
                        return
                    }
                    let modelList = try! JSONDecoder().decode(GarageRequestModel.self, from: data)
                    printDebug(modelList)
                    currentPage = result[ApiKey.data][ApiKey.page].intValue
                    isRequestinApi = false
                    self.garageRequestDetailArr = modelList
                 
                    nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
                    currentPage += 1
                    self.delegate?.getGarageDetailSuccess(message: "")
                } catch {
                    isRequestinApi = false
                    self.delegate?.getGarageDetailFailed(error: "error occured")
                    printDebug("error occured")
                }
            }
        }
    
    
    func getBrandListingData(params: JSONDictionary,loader: Bool = true,pagination: Bool = false){
        if pagination {
            guard nextPageAvailable, !isRequestinApi else { return }
        } else {
            guard !isRequestinApi else { return }
        }
        isRequestinApi = true
        WebServices.getBrandListingData(parameters: params, success: { (json) in
            self.parseToBankListingData(result: json)
        }) { (error) -> (Void) in
            self.delegate?.brandListingFailed(error: error.localizedDescription)
        }
    }
    
    func parseToBankListingData(result: JSON) {
        if let jsonString = result[ApiKey.data][ApiKey.result].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                if result[ApiKey.data][ApiKey.result].arrayValue.isEmpty {
                    self.hideLoader = true
                    self.brandsListings = []
                    isRequestinApi = false
                    self.delegate?.brandListingSuccess(message: "")
                    return
                }
                let modelList = try JSONDecoder().decode([PreferredBrand].self, from: data)
                printDebug(modelList)
                currentPage = result[ApiKey.data][ApiKey.page].intValue
                isRequestinApi = false
                if currentPage == 1 {
                    self.brandsListings = modelList
                } else {
                    self.brandsListings.append(contentsOf: modelList)
                }
                nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
//                currentPage += 1
                self.delegate?.brandListingSuccess(message: "")
            } catch {
                isRequestinApi = false
                self.delegate?.brandListingFailed(error: "error occured")
                printDebug("error occured")
            }
        }
    }
}


