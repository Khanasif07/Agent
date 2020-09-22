//
//  BrandsListingVM.swift
//  ArabianTyres
//
//  Created by Admin on 21/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON


protocol BrandsListingVMDelegate: class {
    func brandListingSuccess(message: String)
    func brandListingFailed(error:String)
    func countryListingSuccess(message: String)
    func countryListingFailed(error:String)
}


class BrandsListingVM{
    
    //MARK:- Variables
    //================
    var hideLoader: Bool = false
    var currentPage = 1
    var totalPages = 1
    var nextPageAvailable = true
    var isRequestinApi = false
    var showPaginationLoader: Bool {
        return  hideLoader ? false : nextPageAvailable
    }
    var brandsListings:[TyreBrandModel] = []
    var countryListings:[TyreCountryModel] = []
    var memberCountLbl: Int = 0
    
    weak var delegate: BrandsListingVMDelegate?
    
    //MARK:- Functions
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
    
    
    //MARK:- Functions
    func getCountryListingData(params: JSONDictionary,loader: Bool = true,pagination: Bool = false){
        if pagination {
            guard nextPageAvailable, !isRequestinApi else { return }
        } else {
            guard !isRequestinApi else { return }
        }
        isRequestinApi = true
        WebServices.getCountryListingData(parameters: params, success: { (json) in
            self.parseToCountryListingData(result: json)
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
                let modelList = try JSONDecoder().decode([TyreBrandModel].self, from: data)
                printDebug(modelList)
                currentPage = result[ApiKey.data][ApiKey.page].intValue
                isRequestinApi = false
                if currentPage == 1 {
                    self.brandsListings = modelList
                } else {
                    self.brandsListings.append(contentsOf: modelList)
                }
                nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
                currentPage += 1
                self.delegate?.brandListingSuccess(message: "")
            } catch {
                isRequestinApi = false
                self.delegate?.brandListingFailed(error: "error occured")
                printDebug("error occured")
            }
        }
    }
    
    func parseToCountryListingData(result: JSON) {
        if let jsonString = result[ApiKey.data][ApiKey.result].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                if result[ApiKey.data][ApiKey.result].arrayValue.isEmpty {
                    self.hideLoader = true
                    self.countryListings = []
                    isRequestinApi = false
                    self.delegate?.countryListingSuccess(message: "")
                    return
                }
                let modelList = try JSONDecoder().decode([TyreCountryModel].self, from: data)
                printDebug(modelList)
                currentPage = result[ApiKey.data][ApiKey.page].intValue
                isRequestinApi = false
                if currentPage == 1 {
                    self.countryListings = modelList
                } else {
                    self.countryListings.append(contentsOf: modelList)
                }
                nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
                currentPage += 1
                self.delegate?.countryListingSuccess(message: "")
            } catch {
                isRequestinApi = false
                self.delegate?.countryListingFailed(error: "error occured")
                printDebug("error occured")
            }
        }
    }
}
