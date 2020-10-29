//
//  BottomSheetVM.swift
//  ArabianTyres
//
//  Created by Admin on 25/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON


protocol BottomSheetVMDelegate: class {
    func makeListingSuccess(message: String)
    func makeListingFailed(error:String)
    func modelListingSuccess(message: String)
    func modelListingFailed(error:String)
}


class BottomSheetVM{
    
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
    var makeListings:[MakeModel] = []
    var modelListings:[ModelData] = []
    var selectedMakeArr : [MakeModel] = []
    var selectedModelArr : [ModelData] = []
    
    weak var delegate: BottomSheetVMDelegate?

    var searchMakeListing : [MakeModel] {
        if searchText.isEmpty{
            return makeListings
        }
        return makeListings.filter({$0.name.lowercased().contains(s: searchText.lowercased())})
    }
    
    var searchModelListing : [ModelData] {
           if searchText.isEmpty{
               return modelListings
           }
        return modelListings.filter({$0.model.lowercased().contains(s: searchText.lowercased())})
       }
    
    
    //MARK:- Functions
    
    
    func getMakeListingData(params: JSONDictionary,loader: Bool = true,pagination: Bool = false){
        if pagination {
            guard nextPageAvailable, !isRequestinApi else { return }
        } else {
            guard !isRequestinApi else { return }
        }
        isRequestinApi = true
        WebServices.getMakeListingData(parameters: params, success: { (json) in
            self.parseToMakeListingData(result: json)
        }) { (error) -> (Void) in
            self.delegate?.makeListingFailed(error: error.localizedDescription)
        }
    }
    
    func getModelListingData(params: JSONDictionary,loader: Bool = true,pagination: Bool = false){
           if pagination {
               guard nextPageAvailable, !isRequestinApi else { return }
           } else {
               guard !isRequestinApi else { return }
           }
           isRequestinApi = true
           WebServices.getModelListingData(parameters: params, success: { (json) in
               self.parseToModelListingData(result: json)
           }) { (error) -> (Void) in
               self.delegate?.modelListingFailed(error: error.localizedDescription)
           }
       }
    
    func parseToMakeListingData(result: JSON) {
        if let jsonString = result[ApiKey.data].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                if result[ApiKey.data].arrayValue.isEmpty {
                    self.hideLoader = true
                    self.makeListings = []
                    isRequestinApi = false
                    self.delegate?.makeListingSuccess(message: "")
                    return
                }
                let modelList = try JSONDecoder().decode([MakeModel].self, from: data)
                printDebug(modelList)
                currentPage = result[ApiKey.data][ApiKey.page].intValue
                isRequestinApi = false
                if currentPage == 1 {
                    self.makeListings = modelList
                } else {
                    self.makeListings.append(contentsOf: modelList)
                }
                nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
                currentPage += 1
                self.delegate?.makeListingSuccess(message: "")
            } catch {
                isRequestinApi = false
                self.delegate?.makeListingFailed(error: "error occured")
                printDebug("error occured")
            }
        }
    }
    
    func parseToModelListingData(result: JSON) {
        if let jsonString = result[ApiKey.data].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                if result[ApiKey.data].arrayValue.isEmpty {
                    self.hideLoader = true
                    self.modelListings = []
                    isRequestinApi = false
                    self.delegate?.modelListingSuccess(message: "")
                    return
                }
                let modelList = try JSONDecoder().decode([ModelData].self, from: data)
                printDebug(modelList)
                currentPage = result[ApiKey.data][ApiKey.page].intValue
                isRequestinApi = false
                if currentPage == 1 {
                    self.modelListings = modelList
                } else {
                    self.modelListings.append(contentsOf: modelList)
                }
                nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
                currentPage += 1
                self.delegate?.modelListingSuccess(message: "")
            } catch {
                isRequestinApi = false
                self.delegate?.modelListingFailed(error: "error occured")
                printDebug("error occured")
            }
        }
    }

      func removeSelectedMake(model : MakeModel) {
          if self.selectedMakeArr.count != 0 {
              for power in self.selectedMakeArr.enumerated() {
                  if power.element.id == model.id {
                      self.selectedMakeArr.remove(at: power.offset)
                      break
                  }
              }
          }
      }
      
      func setSelectedMake(model : MakeModel) {
          if self.makeListings.count != 0 {
              self.selectedMakeArr.append(model)
          } else {
              self.selectedMakeArr = [model]
          }
      }
    
    func removeSelectedCountry(model : ModelData) {
        if self.selectedModelArr.count != 0 {
            for power in self.selectedModelArr.enumerated() {
                if power.element.model == model.model {
                    self.selectedModelArr.remove(at: power.offset)
                    break
                }
            }
        }
    }
    
    func setSelectedCountry(model : ModelData) {
        if self.modelListings.count != 0 {
            self.selectedModelArr.append(model)
        } else {
            self.selectedModelArr = [model]
        }
    }
      
}
