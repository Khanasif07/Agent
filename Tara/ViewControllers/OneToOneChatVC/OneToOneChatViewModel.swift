//
//  OneToOneChatViewModel.swift
//  Tara
//
//  Created by Arvind on 05/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON


protocol OneToOneChatViewModelDelegate: class {
    func chatDataSuccess(msg: String)
    func chatDataFailure(msg: String)
}

class OneToOneChatViewModel {
    
    // MARK: Variables
    //=================================
    weak var delegate: OneToOneChatViewModelDelegate?
    var hideLoader: Bool = false
    var currentPage = 1
    var totalPages = 1
    var nextPageAvailable = true
    var isRequestinApi = false
    
    // MARK: Functions
    //=================================
    func getChatData(params: JSONDictionary,loader: Bool = false) {
        WebServices.getChatData(parameters: params, success: { [weak self] (json) in
            guard let `self` = self else { return }
            let msg = json[ApiKey.message].stringValue
            let statusCode = json[ApiKey.statusCode].intValue

            printDebug(json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.chatDataFailure(msg: error.localizedDescription)
        }
    }
    
    func parseToMakeListingData(result: JSON) {
        if let jsonString = result[ApiKey.data][ApiKey.result].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                if result[ApiKey.data][ApiKey.result].arrayValue.isEmpty {
                    self.hideLoader = true
                    isRequestinApi = false
//                    self.delegate?.getUserBidDataSuccess(message: "")
                    return
                }
                let modelList = try! JSONDecoder().decode([UserBidModel].self, from: data)
                printDebug(modelList)
                currentPage = result[ApiKey.data][ApiKey.page].intValue
                isRequestinApi = false
                if currentPage == 1 {
//                    self.userBidListingArr = modelList
                } else {
//                    self.userBidListingArr.append(contentsOf: modelList)
                }
                nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
                currentPage += 1
//                self.delegate?.getUserBidDataSuccess(message: "")
            } catch {
                isRequestinApi = false
//                self.delegate?.getUserBidDataFailed(error: "error occured")
                printDebug("error occured")
            }
        }
    }
}

