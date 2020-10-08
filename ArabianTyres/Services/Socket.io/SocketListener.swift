//
//  SocketListener.swift
//  ArabianTyres
//
//  Created by Admin on 08/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import Foundation
import SwiftyJSON
//import SocketIO

// MARK: - Listener for Live Stream
extension SocketIOManager {

}
// MARK: - Backend listener
// ==============================
// MARK: - IM Sockets
// listen message data to socket server
extension SocketIOManager {
    func receiveNewDirectMessages() {
        self.socket?.on(SocketKeys.message, callback: { (arrAckData, ack) in
            printDebug("New Message")
            guard let dictMsg = arrAckData.first as? JSONDictionary else { return }
            ack.with(true)
        })
    }
}
