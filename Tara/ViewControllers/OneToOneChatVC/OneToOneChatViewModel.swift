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
    var chatData = ChatModel()
    var totalTime = 00
    var countdownTimer:Timer!
    
    // MARK: Functions
    //=================================
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
       
    func getChatData(params: JSONDictionary,loader: Bool = false) {
        WebServices.getChatData(parameters: params,loader: loader, success: { [weak self] (json) in
            guard let `self` = self else { return }
            self.parseToMakeListingData(result: json)
            printDebug(json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.chatDataFailure(msg: error.localizedDescription)
        }
    }
    
    func parseToMakeListingData(result: JSON) {
        if let jsonString = result[ApiKey.data].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                if result[ApiKey.data][ApiKey._id].stringValue.isEmpty {
                    self.hideLoader = true
                    self.chatData = ChatModel()
                    isRequestinApi = false
                    return
                }
                let modelList = try! JSONDecoder().decode(ChatModel.self, from: data)
                printDebug(modelList)
                currentPage = result[ApiKey.data][ApiKey.page].intValue
                isRequestinApi = false
                chatData = modelList
                
                if currentPage == 1 {
//                    self.userBidListingArr = modelList
                } else {
//                    self.userBidListingArr.append(contentsOf: modelList)
                }
                nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
                currentPage += 1
                self.delegate?.chatDataSuccess(msg: "")
            } catch {
                isRequestinApi = false
                self.delegate?.chatDataFailure(msg: "error occured")
                printDebug("error occured")
            }
        }
    }
}

