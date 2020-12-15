//
//  PaymentListingVM.swift
//  Tara
//
//  Created by Arvind on 21/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol PaymentListingVMDelegate: class {
    func paymentListingApiSuccess(msg : String)
    func paymentListingApiFailure(msg : String)
    
}
class PaymentListingVM {
    
    //MARK:- Variables
    //================
    weak var delegate: PaymentListingVMDelegate?
    var hideLoader: Bool = false
    var currentPage = 1
    var totalPages = 1
    var nextPageAvailable = true
    var isRequestinApi = false
    var showPaginationLoader: Bool {
        return  hideLoader ? false : nextPageAvailable
    }
    var paymentListing = [GarageRequestModel]()

    // MARK: Functions
    //=================================
    func fetchPaymentListing(params: JSONDictionary,loader: Bool = false,pagination: Bool = false) {
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
            self.delegate?.paymentListingApiFailure(msg: error.localizedDescription)
        }
    }
    
    func parseToMakeListingData(result: JSON) {
        if let jsonString = result[ApiKey.data][ApiKey.result].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                if result[ApiKey.data][ApiKey.result].arrayValue.isEmpty {
                    self.hideLoader = true
                    self.paymentListing = []
                    isRequestinApi = false
                    self.delegate?.paymentListingApiSuccess(msg: "")
                    return
                }
                let modelList = try! JSONDecoder().decode([GarageRequestModel].self, from: data)
                printDebug(modelList)
                currentPage = result[ApiKey.data][ApiKey.page].intValue
                isRequestinApi = false
                if currentPage == 1 {
                    self.paymentListing = modelList
                } else {
                    self.paymentListing.append(contentsOf: modelList)
                }
                nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
                currentPage += 1
                self.delegate?.paymentListingApiSuccess(msg: "")
            } catch {
                isRequestinApi = false
                self.delegate?.paymentListingApiFailure(msg: "error occured")
                printDebug("error occured")
            }
        }
    }
}
