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
        guard let value = userInfo[ApiKey.notificationType] as? String else { return }
        
//        switch value {
//        case PushNotificationType.chat.rawValue:
//            let model = ChatNotificationModel(userInfo)
//            if model.roomType == ApiKey.singleCaps || model.roomType == ApiKey.single {
//                AppDelegate.shared.userID = model.senderId
//                NotificationCenter.default.post(name: .updateBatchCount, object: nil)
//                AppRouter.redirectUserToChat(model)
//            } else {
//                AppRouter.redirectUserToGroupChat(model)
//            }
//        case PushNotificationType.event.rawValue:
//            AppDelegate.shared.unreadNotificationCount -= 1
//            AppUserDefaults.save(value: AppDelegate.shared.unreadNotificationCount, forKey: .unreadCount)
//            NotificationCenter.default.post(name: .didReceiveNotification, object: nil)
//            let viewId = userInfo[ApiKey.notificationViewId]
//            let eventId = userInfo[ApiKey.notificationEventId]
//            AppRouter.goToHome(isComeFromshareUrl: (viewId as! String) == "2",eventId: eventId as! String)
//            break
//        case PushNotificationType.event.rawValue:
//            guard let userType = userInfo["userType"] as? String else { return }
//            AppUserDefaults.save(value: userType, forKey: .userType)
//            AppRouter.goToWalkthrough()
//        case PushNotificationType.post.rawValue:
//            let _ = userInfo[ApiKey.notificationViewId]
//            let eventId = userInfo[ApiKey.notificationEventId]
//            let _ = userInfo[ApiKey.notificationPostId]
//            AppRouter.redirectUserToEventDetailSCreen(eventId as! String)
//        case PushNotificationType.like.rawValue:
//            let _ = userInfo[ApiKey.notificationViewId]
//            let eventId = userInfo[ApiKey.notificationEventId]
//            let _ = userInfo[ApiKey.notificationPostId]
//            AppRouter.redirectUserToEventDetailSCreen(eventId as! String)
//        case PushNotificationType.comment.rawValue:
//            let _ = userInfo[ApiKey.notificationViewId]
//            let eventId = userInfo[ApiKey.notificationEventId]
//            let _ = userInfo[ApiKey.notificationPostId]
//            AppRouter.redirectUserToEventDetailSCreen(eventId as! String)
//        default:
//            break
//        }
    }
}





