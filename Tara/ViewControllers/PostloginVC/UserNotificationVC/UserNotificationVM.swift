//
//  UserNotificationVM.swift
//  Tara
//
//  Created by Arvind on 23/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol UserNotificationVMDelegate: class {
    func notificationListingSuccess(msg : String)
    func notificationListingFailure(msg : String)
    func deleteNotificationSuccess(msg : String)
    func deleteNotificationFailure(msg : String)
    func markNotificationSuccess(msg : String)
    func markNotificationFailure(msg : String)
}


class UserNotificationVM {
    
    //MARK:- Variables
    //================
    weak var delegate: UserNotificationVMDelegate?
    var hideLoader: Bool = false
    var currentPage = 1
    var totalPages = 1
    var nextPageAvailable = true
    var isRequestinApi = false
    var showPaginationLoader: Bool {
        return  hideLoader ? false : nextPageAvailable
    }
    var notificationListingArr = [NotificationModel]()

    // MARK: Functions
    //=================================
    func fetchNotificationListing(params: JSONDictionary,loader: Bool = false,pagination: Bool = false) {
        if pagination {
            guard nextPageAvailable, !isRequestinApi else { return }
        } else {
            guard !isRequestinApi else { return }
        }
        isRequestinApi = true
        WebServices.getUserNotifications(parameters: params,loader: loader, success: { [weak self] (json) in
            guard let `self` = self else { return }
            self.parseToMakeListingData(result: json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.isRequestinApi = false
            self.delegate?.notificationListingFailure(msg: error.localizedDescription)
        }
    }
    
    func deleteNotification(params: JSONDictionary,loader: Bool = false,pagination: Bool = false) {
        
          WebServices.deleteUserNotification(parameters: params,loader: loader, success: { [weak self] (json) in
              guard let `self` = self else { return }
              self.delegate?.deleteNotificationSuccess(msg: "")
          }) { [weak self] (error) in
              guard let `self` = self else { return }
              self.isRequestinApi = false
              self.delegate?.deleteNotificationFailure(msg: error.localizedDescription)
          }
      }

    func setNotificationMarkRead(params: JSONDictionary,loader: Bool = false,pagination: Bool = false) {
       
        WebServices.setNotificationMarkRead(parameters: params,loader: loader, success: { [weak self] (json) in
            guard let `self` = self else { return }
            self.delegate?.markNotificationSuccess(msg: "")
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.isRequestinApi = false
            self.delegate?.markNotificationFailure(msg: error.localizedDescription)
        }
    }
    
    func parseToMakeListingData(result: JSON) {
        if let jsonString = result[ApiKey.data][ApiKey.result].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                if result[ApiKey.data][ApiKey.result].arrayValue.isEmpty {
                    self.hideLoader = true
                    self.notificationListingArr = []
                    isRequestinApi = false
                    self.delegate?.notificationListingSuccess(msg: "")
                    return
                }
                let modelList = try JSONDecoder().decode([NotificationModel].self, from: data)
                printDebug(modelList)
                currentPage = result[ApiKey.data][ApiKey.page].intValue
                isRequestinApi = false
                if currentPage == 1 {
                    self.notificationListingArr = modelList
                } else {
                    self.notificationListingArr.append(contentsOf: modelList)
                }
                nextPageAvailable = result[ApiKey.data][ApiKey.next].boolValue
                currentPage += 1
                self.delegate?.notificationListingSuccess(msg: "")
            } catch {
                isRequestinApi = false
                self.delegate?.notificationListingFailure(msg: "error occured")
                printDebug("error occured")
            }
        }
    }
}
