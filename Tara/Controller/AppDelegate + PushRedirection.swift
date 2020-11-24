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
            AppDelegate.shared.unreadNotificationCount -= 1
            AppUserDefaults.save(value: AppDelegate.shared.unreadNotificationCount, forKey: .unreadCount)
            let requestId = userInfo[ApiKey.gcm_notification_requestId] as? String ?? ""
            _ = userInfo[ApiKey.gcm_notification_type] as? String ?? ""
            AppRouter.goToGarageServiceRequestVCThroughNotification(requestId)
        case PushNotificationType.NEW_BID_EVENT.rawValue:
            AppDelegate.shared.unreadNotificationCount -= 1
            AppUserDefaults.save(value: AppDelegate.shared.unreadNotificationCount, forKey: .unreadCount)
//            let viewId = userInfo[ApiKey.notificationViewId]
            let requestId = userInfo[ApiKey.gcm_notification_requestId] as? String ?? ""
//            AppRouter.goToUserAllOffersVC(vc: <#T##UIViewController#>, requestId: requestId)
            break
//        case PushNotificationType.BID_EDIT.rawValue:
//            guard let userType = userInfo["userType"] as? String else { return }
//            AppRouter.goToWalkthrough()
//        case PushNotificationType.BID_ACCEPTED.rawValue:
//            let _ = userInfo[ApiKey.notificationViewId]
//            let eventId = userInfo[ApiKey.notificationEventId]
//            let _ = userInfo[ApiKey.notificationPostId]
//            AppRouter.redirectUserToEventDetailSCreen(eventId as! String)
//        case PushNotificationType.BID_REJECTED.rawValue:
//            let _ = userInfo[ApiKey.notificationViewId]
//            let eventId = userInfo[ApiKey.notificationEventId]
//            let _ = userInfo[ApiKey.notificationPostId]
//            AppRouter.redirectUserToEventDetailSCreen(eventId as! String)
//        case PushNotificationType.BID_CANCELLED.rawValue:
//            let _ = userInfo[ApiKey.notificationViewId]
//            let eventId = userInfo[ApiKey.notificationEventId]
//            let _ = userInfo[ApiKey.notificationPostId]
//            AppRouter.redirectUserToEventDetailSCreen(eventId as! String)
//        case PushNotificationType.GARAGE_REGISTRATION_REQUEST.rawValue:
//            let _ = userInfo[ApiKey.notificationViewId]
//            let eventId = userInfo[ApiKey.notificationEventId]
//            let _ = userInfo[ApiKey.notificationPostId]
//            AppRouter.redirectUserToEventDetailSCreen(eventId as! String)
//        case PushNotificationType.SERVICE_STARTED.rawValue:
//            let _ = userInfo[ApiKey.notificationViewId]
//            let eventId = userInfo[ApiKey.notificationEventId]
//            let _ = userInfo[ApiKey.notificationPostId]
//            AppRouter.redirectUserToEventDetailSCreen(eventId as! String)
        default:
            break
        }
    }
}





