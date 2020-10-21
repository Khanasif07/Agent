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
            self.parseToMakeListingData(result: json)
           })
        
        //
         self.socket?.on(EventListnerKeys.didConnect.rawValue, callback: { data, _ in
                       let json = JSON(data)
                       printDebug(json)
                   })
        //
        self.socket?.on(EventListnerKeys.didDisConnect.rawValue, callback: { data, _ in
            let json = JSON(data)
            printDebug(json)
        })
        //
        self.socket?.on(EventListnerKeys.newBid.rawValue, callback: { data, _ in
            printDebug(data)
            let json = JSON(data)
            self.parseToMakeListingData(result: json)
        })
        
        self.socket?.on(EventListnerKeys.bidAccepted.rawValue, callback: { data, _ in
                   printDebug(data)
                   let json = JSON(data)
                   if let jsonString = json.arrayValue.first![ApiKey.data].rawString(), let data = jsonString.data(using: .utf8) {
                       do {
                       } catch {
                           printDebug("Error Occured due to Live User Model not parsed correctly.")
                       }
                       
                   }
               })
       }
}
