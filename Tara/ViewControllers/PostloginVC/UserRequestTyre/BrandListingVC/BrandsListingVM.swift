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
    var searchText: String = ""
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
    var selectedBrandsArr : [TyreBrandModel] = []
    var selectedCountryArr : [TyreCountryModel] = []
    var memberCountLbl: Int = 0
    
    weak var delegate: BrandsListingVMDelegate?

    var searchBrandListing : [TyreBrandModel] {
        if searchText.isEmpty{
            return brandsListings
        }
        return brandsListings.filter({$0.name.lowercased().contains(s: searchText.lowercased())})
    }
    
    var searchCountryListing : [TyreCountryModel] {
           if searchText.isEmpty{
               return countryListings
           }
        return countryListings.filter({$0.name.lowercased().contains(s: searchText.lowercased())})
       }
    
    
    //MARK:- Functions
    
    
    func getBrandListingData(params: JSONDictionary,loader: Bool = true,pagination: Bool = false){
        if pagination {
            guard nextPageAvailable, !isRequestinApi else { return }
        } else {
            guard !isRequestinApi else { return }
        }
        isRequestinApi = true
        WebServices.getBrandListingData(parameters: params, loader: loader, success: { (json) in
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
                    TyreRequestModel.shared.tyreBrandsListings = []
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
                    var allModel = TyreBrandModel()
                    allModel.name = "All Brands"
                    self.brandsListings.insert(allModel, at: 0)
                } else {
                    self.brandsListings.append(contentsOf: modelList)
                }
                TyreRequestModel.shared.tyreBrandsListings =  self.brandsListings
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
                    TyreRequestModel.shared.tyreCountryListings  = []
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
                    var allModel = TyreCountryModel()
                    allModel.name = "All Country"
                    self.countryListings.insert(allModel, at: 0)
                } else {
                    self.countryListings.append(contentsOf: modelList)
                }
                TyreRequestModel.shared.tyreCountryListings =  self.countryListings
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
    
    
      func removeSelectedBrands(model : TyreBrandModel) {
          if self.selectedBrandsArr.count != 0 {
              for power in self.selectedBrandsArr.enumerated() {
                  if power.element.id == model.id {
                      self.selectedBrandsArr.remove(at: power.offset)
                      break
                  }
              }
          }
      }
      
      func setSelectedBrands(model : TyreBrandModel) {
          if self.brandsListings.count != 0 {
              self.selectedBrandsArr.append(model)
          } else {
              self.selectedBrandsArr = [model]
          }
      }
    
    func removeSelectedCountry(model : TyreCountryModel) {
        if self.selectedCountryArr.count != 0 {
            for power in self.selectedCountryArr.enumerated() {
                if power.element.id == model.id {
                    self.selectedCountryArr.remove(at: power.offset)
                    break
                }
            }
        }
    }
    
    func setSelectedCountry(model : TyreCountryModel) {
        if self.countryListings.count != 0 {
            self.selectedCountryArr.append(model)
        } else {
            self.selectedCountryArr = [model]
        }
    }
      
}
