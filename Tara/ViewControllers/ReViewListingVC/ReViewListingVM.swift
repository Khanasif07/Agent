//
//  ReViewListingVM.swift
//  Tara
//
//  Created by Arvind on 05/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON


protocol ReViewListingVMDelegate: class {
    func getReviewListingSuccess(msg: String)
    func getReviewListingFailed(msg: String)
}

class ReViewListingVM {
    
    // MARK: Variables
    //=================================
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
    
    weak var delegate: ReViewListingVMDelegate?
    var reviewListingArr = [GarageRequestModel]()
    
    // MARK: Functions
    //=================================
    func fetchReviewListing(params: JSONDictionary,loader: Bool = false) {
        WebServices.getReviewListingData(parameters: params, success: { [weak self] (json) in
            guard let `self` = self else { return }
            self.parseToMakeListingData(result: json)
            printDebug(json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.getReviewListingFailed(msg: error.localizedDescription)
        }
    }
    
    func parseToMakeListingData(result: JSON) {
        if let jsonString = result[ApiKey.data][ApiKey.result].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                if result[ApiKey.data][ApiKey.result].arrayValue.isEmpty {
                    self.hideLoader = true
                    self.reviewListingArr = []
                    isRequestinApi = false
                    self.delegate?.getReviewListingSuccess(msg: "")
                    return
                }
                let modelList = try! JSONDecoder().decode([GarageRequestModel].self, from: data)
                printDebug(modelList)
                currentPage = result[ApiKey.data][ApiKey.page].intValue
                isRequestinApi = false
                if currentPage == 1 {
                    self.reviewListingArr = modelList
                } else {
                    self.reviewListingArr.append(contentsOf: modelList)
                }
                nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
                currentPage += 1
                self.delegate?.getReviewListingSuccess(msg: "")
            } catch {
                isRequestinApi = false
                self.delegate?.getReviewListingFailed(msg: "error occured")
                printDebug("error occured")
            }
        }
    }
    
}
