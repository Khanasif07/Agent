//
//  URTyreSizeVM.swift
//  ArabianTyres
//
//  Created by Admin on 25/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol URTyreSizeVMDelegate: class {
    func getTyreSizeListingDataSuccess(message: String)
    func getTyreSizeListingDataFailed(error:String)
}

extension URTyreSizeVMDelegate {
    func getTyreSizeListingDataSuccess(message: String) {}
    func getTyreSizeListingDataFailed(error:String) {}
}

class URTyreSizeVM{
    
    //MARK:- Variables
    //================
    var tyreSizeListings: [TyreSizeModel] = []
    var selectedtyreSizeListings :  [TyreSizeModel] = []
    weak var delegate: URTyreSizeVMDelegate?
    var hideLoader: Bool = false
    var currentPage = 1
    var totalPages = 1
    var nextPageAvailable = true
    var isRequestinApi = false
    var showPaginationLoader: Bool {
        return  hideLoader ? false : nextPageAvailable
    }
    
    //MARK:- Functions
    //Function for verify OTP
    func getTyreSizeListingData(dict: JSONDictionary){
        WebServices.getTyreSizeListingData(parameters: dict, success: { (json) in
            self.parseToTyreSizeListingData(result: json)
        }) { (error) -> (Void) in
            self.delegate?.getTyreSizeListingDataFailed(error: error.localizedDescription)
        }
    }
    
    func parseToTyreSizeListingData(result: JSON) {
        if let jsonString = result[ApiKey.data].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                if result[ApiKey.data].arrayValue.isEmpty {
                    self.hideLoader = true
                    self.tyreSizeListings = []
                    isRequestinApi = false
                    self.delegate?.getTyreSizeListingDataSuccess(message: "")
                    return
                }
                let modelList = try JSONDecoder().decode([TyreSizeModel].self, from: data)
                printDebug(modelList)
                currentPage = result[ApiKey.data][ApiKey.page].intValue
                isRequestinApi = false
                if currentPage == 1 {
                    self.tyreSizeListings = modelList
                } else {
                    self.tyreSizeListings.append(contentsOf: modelList)
                }
                nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
                currentPage += 1
                self.delegate?.getTyreSizeListingDataSuccess(message: "")
            } catch {
                isRequestinApi = false
                self.delegate?.getTyreSizeListingDataFailed(error: "error occured")
                printDebug("error occured")
            }
        }
    }
    
    
}
