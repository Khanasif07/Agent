//
//  ServiceCompletedVM.swift
//  Tara
//
//  Created by Arvind on 06/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ServiceCompletedVMDelegate: class {
    func serviceCompleteApiSuccess(msg : String)
    func serviceCompleteApiFailure(msg : String)
    
}
class ServiceCompletedVM {
    
    //MARK:- Variables
    //================
    weak var delegate: ServiceCompletedVMDelegate?
    var hideLoader: Bool = false
    var currentPage = 1
    var totalPages = 1
    var nextPageAvailable = true
    var isRequestinApi = false
    var showPaginationLoader: Bool {
        return  hideLoader ? false : nextPageAvailable
    }
    var serviceCompletedListing = [GarageRequestModel]()

    // MARK: Functions
    //=================================
    func fetchServiceCompleteListing(params: JSONDictionary,loader: Bool = false,pagination: Bool = false) {
        if pagination {
            guard nextPageAvailable, !isRequestinApi else { return }
        } else {
            guard !isRequestinApi else { return }
        }
        isRequestinApi = true
        WebServices.getGarageCompletedServicesList(parameters: params,loader: loader, success: { [weak self] (json) in
            guard let `self` = self else { return }
            self.parseToMakeListingData(result: json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.isRequestinApi = false
            self.delegate?.serviceCompleteApiFailure(msg: error.localizedDescription)
        }
    }
    
    
    func parseToMakeListingData(result: JSON) {
        if let jsonString = result[ApiKey.data][ApiKey.result].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                if result[ApiKey.data][ApiKey.result].arrayValue.isEmpty {
                    self.hideLoader = true
                    self.serviceCompletedListing = []
                    isRequestinApi = false
                    self.delegate?.serviceCompleteApiSuccess(msg: "")
                    return
                }
                let modelList = try! JSONDecoder().decode([GarageRequestModel].self, from: data)
                printDebug(modelList)
                currentPage = result[ApiKey.data][ApiKey.page].intValue
                isRequestinApi = false
                if currentPage == 1 {
                    self.serviceCompletedListing = modelList
                } else {
                    self.serviceCompletedListing.append(contentsOf: modelList)
                }
                nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
                currentPage += 1
                self.delegate?.serviceCompleteApiSuccess(msg: "")
            } catch {
                isRequestinApi = false
                self.delegate?.serviceCompleteApiFailure(msg: "error occured")
                printDebug("error occured")
            }
        }
    }
}
