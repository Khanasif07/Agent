//
//  SocketListener.swift
//  ArabianTyres
//
//  Created by Admin on 08/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import Foundation
import SwiftyJSON
import SocketIO


// MARK: - IM Sockets
// listen message data to socket server
extension SocketIOManager {
     /// Method to listen online users when any one goes in and out from Room
       func listenOnlineUsers() {
        self.socket?.on(EventListnerKeys.newRequest.rawValue, callback: { data, _ in
               printDebug(data)
               let json = JSON(data)
               if let jsonString = json.arrayValue.first![ApiKey.data].rawString(), let data = jsonString.data(using: .utf8) {
                   do {
//                       let modelOnlineUserUpdate = try JSONDecoder().decode(LiveUserData.self, from: data)
//                       printDebug(modelOnlineUserUpdate)
                       
//                       let nc = NotificationCenter.default
//                       nc.post(name: Notification.Name.liveUserUpdate, object: modelOnlineUserUpdate)
                   } catch {
                       printDebug("Error Occured due to Live User Model not parsed correctly.")
                   }
                   
               }
           })
       }
}
