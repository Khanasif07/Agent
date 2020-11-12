//
//  NotificationExtension.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Foundation

extension Notification.Name {
    static let NotConnectedToInternet = Notification.Name("NotConnectedToInternet")
    static let SelectedTyreSizeSuccess = Notification.Name("SelectedTyreSizeSuccess")
    static let ServiceRequestSuccess = Notification.Name("ServiceRequestSuccess")
    static let ServiceRequestReceived = Notification.Name("ServiceRequestReceived")
    static let PlaceBidRejectBidSuccess = Notification.Name("PlaceBidRejectBidSuccess")
    static let UserServiceAcceptRejectSuccess = Notification.Name("UserServiceAcceptRejectSuccess")
    static let NewBidSocketSuccess = Notification.Name("NewBidSocketSuccess")
    static let BidAcceptedRejected = Notification.Name("bidAcceptedRejected")
    static let RequestRejected = Notification.Name("RequestRejected")
    static let RequestAccepted = Notification.Name("RequestAccepted")
    static let UpdateServiceStatus = Notification.Name("UpdateServiceStatus")

    static let UpdateServiceStatusUserSide = Notification.Name("UpdateServiceStatusUserSide")

}
