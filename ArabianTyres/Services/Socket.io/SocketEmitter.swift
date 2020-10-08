//
//  SocketEmitter.swift
//  ArabianTyres
//
//  Created by Admin on 08/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON
import SocketIO

// MARK: - Emitter for Live Stream
extension SocketIOManager {

}
// MARK: - Emit for Chat

extension SocketIOManager {
    
    // new emit
    /**
     Emits an event with a dictionary
     - Parameters:
     - event: Name of the event to emit
     - params: Dictionary to emit in the event
     - Acknowledgement Handler
     */
    func emit(with event: String, _ params: JSONDictionary?, timeoutAfter: Double = 15.0, ackHandler: (([Any]) -> Void)? = nil) {
        self.connectSocket(handler: {
            self.emitWithACK(withTimeoutAfter: timeoutAfter, event: event, params: params, array: nil) { (ack) in
                ackHandler?(ack)
            }
        })
    }
    private func emitWithACK(withTimeoutAfter seconds: Double, event: String, params: JSONDictionary?, array: [Any]?, ackHandler: (([Any]) -> Void)? = nil) {
        
        var ack: OnAckCallback?
        
        if let tempParams = params {
            ack = self.socket?.emitWithAck(event, tempParams)
        } else if let tempArray = array {
            ack = self.socket?.emitWithAck(event, tempArray)
        } else {
            ack = self.socket?.emitWithAck(event)
        }
        
        ack?.timingOut(after: seconds, callback: { (data) in
            ackHandler?(data)
        })
    }
}
// new emit
// MARK: - IM Sockets
// Emit message data to socket server
extension SocketIOManager {}
