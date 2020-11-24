//
//  AppDelegate + PushRedirection.swift
//  Tara
//
//  Created by Admin on 21/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Notification.Name {
    static let didReceiveNotification = Notification.Name("didReceiveNotification")
    static let updateBatchCount = Notification.Name("updateBatchCount")
}

class PushNotificationRedirection {
    
    ///Managing the redirection on Notification
    static func redirectionOnNotification(_ userInfo: [String: Any]) {
        guard let value = userInfo[ApiKey.gcm_notification_type] as? String else { return }
        switch value {
        case PushNotificationType.NEW_REQUEST_EVENT.rawValue:
            let requestId = userInfo[ApiKey.gcm_notification_requestId] as? String ?? ""
            _ = userInfo[ApiKey.gcm_notification_type] as? String ?? ""
            AppRouter.goToGarageServiceRequestVCThroughNotification(requestId)
        case PushNotificationType.NEW_BID_EVENT.rawValue:
            let requestId = userInfo[ApiKey.gcm_notification_requestId] as? String ?? ""
            AppRouter.goToUserAllOffersVCThroughNotification(requestId: requestId)
        case PushNotificationType.BID_EDIT.rawValue:
            let requestId = userInfo[ApiKey.gcm_notification_requestId] as? String ?? ""
            AppRouter.goToUserAllOffersVCThroughNotification(requestId: requestId)
        case PushNotificationType.BID_ACCEPTED.rawValue:
            let requestId = userInfo[ApiKey.gcm_notification_requestId] as? String ?? ""
            AppRouter.goToGarageServiceRequestVCThroughNotification(requestId)
        case PushNotificationType.BID_REJECTED.rawValue:
            let requestId = userInfo[ApiKey.gcm_notification_requestId] as? String ?? ""
            AppRouter.goToGarageServiceRequestVCThroughNotification(requestId)
        case PushNotificationType.SERVICE_STATUS_UPDATED.rawValue:
            let requestId = userInfo[ApiKey.gcm_notification_requestId] as? String ?? ""
            AppRouter.goToUserServiceStatusVCThroughNotification(requestId: requestId)
        case PushNotificationType.GARAGE_REQUEST_REJECTED.rawValue:
            let requestId = userInfo[ApiKey.gcm_notification_requestId] as? String ?? ""
            AppRouter.goToGarageServiceRequestVCThroughNotification(requestId)
        case PushNotificationType.BID_CANCELLED.rawValue:
            let requestId = userInfo[ApiKey.gcm_notification_requestId] as? String ?? ""
            AppRouter.goToUserServiceDetailVCThroughNotification(requestId: requestId)
        case PushNotificationType.GARAGE_REQUEST_APPROVED.rawValue:
            //complete garage profile screen
             printDebug(userInfo)
        case PushNotificationType.REQUEST_REJECTED.rawValue:
            let requestId = userInfo[ApiKey.gcm_notification_requestId] as? String ?? ""
            AppRouter.goToUserServiceDetailVCThroughNotification(requestId: requestId)
        case PushNotificationType.GARAGE_REGISTRATION_REQUEST.rawValue:
             printDebug(userInfo)
        case PushNotificationType.SERVICE_STARTED.rawValue:
            let requestId = userInfo[ApiKey.gcm_notification_requestId] as? String ?? ""
            AppRouter.goToUserServiceStatusVCThroughNotification(requestId: requestId)
        default:
            break
        }
    }
}





