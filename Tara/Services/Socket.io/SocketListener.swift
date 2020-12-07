//
//  SocketListener.swift
//  ArabianTyres
//
//  Created by Admin on 08/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import Foundation
import SocketIO
import SwiftyJSON

// MARK: - IM Sockets
// listen message data to socket server
extension SocketIOManager {
    /// Method to listen online users when any one goes in and out from Room
    func listenOnlineUsers() {
        self.socket?.on(EventListnerKeys.newRequest.rawValue, callback: { data, _ in
            let json = JSON(data)
            printDebug(json)
            NotificationCenter.default.post(name: Notification.Name.ServiceRequestReceived, object: nil)
            //Garage request listing
            //garage home count
            self.parseToMakeListingData(result: json)
        })
        
        self.socket?.on(EventListnerKeys.newBid.rawValue, callback: { data, _ in
            printDebug(data)
            let json = JSON(data)
            NotificationCenter.default.post(name: Notification.Name.NewBidSocketSuccess, object: nil)
            //offer listing
            //user service detail
            //User request listing
            //offer detail
            self.parseToMakeListingData(result: json)
        })
        
        self.socket?.on(EventListnerKeys.bidEdit.rawValue, callback: { data, _ in
            printDebug(data)
            let json = JSON(data)
            printDebug(json)
            //offer listing
            //user service detail
            //User request listing
            //offer detail
            NotificationCenter.default.post(name: Notification.Name.NewBidSocketSuccess, object: nil)
        })
        
        self.socket?.on(EventListnerKeys.bidAccepted.rawValue, callback: { data, _ in
            printDebug(data)
            let json = JSON(data)
            printDebug(json)
            //garage request detail
            //Garage request listing
            //garage home count
            NotificationCenter.default.post(name: Notification.Name.BidAcceptedRejected, object: nil)
        })
        
        self.socket?.on(EventListnerKeys.bidRejected.rawValue, callback: { data, _ in
            printDebug(data)
            let json = JSON(data)
            printDebug(json)
            //garage request detail
            //Garage request listing
            //garage home count
            NotificationCenter.default.post(name: Notification.Name.BidAcceptedRejected, object: nil)
        })
        
        self.socket?.on(EventListnerKeys.requestRejected.rawValue, callback: { data, _ in
            printDebug(data)
            let json = JSON(data)
            printDebug(json)
           //User request listing
            //User request detail
            NotificationCenter.default.post(name: Notification.Name.RequestRejected, object: nil)
        })
        
        self.socket?.on(EventListnerKeys.requestCancelled.rawValue, callback: { data, _ in
            printDebug(data)
            let json = JSON(data)
            printDebug(json)
            //Garage request listing
            //garage request detail
            NotificationCenter.default.post(name: Notification.Name.RequestAccepted, object: nil)
        })
        
        self.socket?.on(EventListnerKeys.otpToStartService.rawValue, callback: { data, _ in
            let json = JSON(data)
            printDebug(json)
            self.parseToMakeListingData(result: json)
        })
        
        self.socket?.on(EventListnerKeys.serviceStatusUpdated.rawValue, callback: { data, _ in
            let json = JSON(data)
            NotificationCenter.default.post(name: Notification.Name.UpdateServiceStatusUserSide, object: nil)
            printDebug(json)
        })
        
        self.socket?.on(EventListnerKeys.serviceStarted.rawValue, callback: { data, _ in
            let json = JSON(data)
            NotificationCenter.default.post(name: Notification.Name.UserServiceAcceptRejectSuccess, object: nil)
            printDebug(json)
        })
        
        self.socket?.on(EventListnerKeys.editedBidAccepted.rawValue, callback: { data, _ in
            let json = JSON(data)
            NotificationCenter.default.post(name: Notification.Name.EditedBidAccepted, object: nil)
            printDebug(json)
        })
        
        self.socket?.on(EventListnerKeys.bid_cancelled.rawValue, callback: { data, _ in
            let json = JSON(data)
            NotificationCenter.default.post(name: Notification.Name.BidCancelled, object: nil)
            printDebug(json)
        })
        
        self.socket?.on(EventListnerKeys.payment_recieved_by_garage.rawValue, callback: { data, _ in
            let json = JSON(data)
            NotificationCenter.default.post(name: Notification.Name.PaymentSucessfullyDone, object: nil)
            printDebug(json)
        })
        
    }
}
