//
//  SocketIOManager.swift
//  ArabianTyres
//
//  Created by Admin on 08/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit
import Foundation
import SocketIO
import SwiftyJSON


enum EventListnerKeys : String {
    case didConnect = "connected"
    case didDisConnect = "disconnected"
    case syncContact = "contact-sync"
    case sync_error = "socket-error"
    case contactDelete = "contact-delete"
    case contactEdit = "contact-update"
    case handshakeWithServer = "handshakeWithServer"
    case eventAck = "eventAck"
    case contactFetch = "contact-fetch"
    case syncResponse = "contact_sync_response"
}

class SocketIOManager: NSObject {
    
    // MARK: - PROPERTIES
    //==================
    var socket: SocketIOClient?
    private var manager: SocketManager?
    static let shared: SocketIOManager = SocketIOManager()
    public var baseSocketUrl: String  = "http://demo.yourdomain.com:3000"
    var messageQueue = [[String: Any]]()
    static var isSocketConnected: Bool {
        return SocketIOManager.shared.socket?.status == SocketIOStatus.connected ? true: false
    }
    ///SOCKET INIT
    ///============
    private override init() {
        super.init()
        self.initializeSocket()
    }
    
    // Configure socket
    private func initializeSocket() {
        let socketSerialQueue = DispatchQueue(label: "socketSerialQueue", qos: .userInteractive)
        let accessToken = AppUserDefaults.value(forKey: .accesstoken).stringValue
            let strUrl = baseSocketUrl
            let baseUrl = URL(string: strUrl)!
            printDebug(baseUrl)
            self.manager = SocketManager(socketURL: baseUrl,
                                         config: [.log(true),
                                                  .connectParams(["accessToken": accessToken]),
                                                  .forcePolling(false),
                                                  .reconnects(true),
                                                  .reconnectAttempts(10),
                                                  .reconnectWait(10),
                                                  .reconnectWaitMax(20),
                                                  .forceNew(true),
                                                  .handleQueue(socketSerialQueue)])
            self.socket = manager?.defaultSocket
    }
    
    /// Method to estabish socket connection
    func establishConnection() {
        if self.socket?.status == .connected || self.socket?.status == .connecting {
            printDebug(self.socket?.status)
        } else if self.socket?.status != .connecting {
            self.connectSocket()
        }
    }
    
    func connectSocket(handler:(() -> Void)? = nil) {
        if self.socket == nil {
            self.initializeSocket()
        }
        if self.socket?.status == .connected {
            handler?()
            return
        } else {
            if self.socket?.status != .connecting {
                self.socket?.connect()
            }
            self.socket?.on(SocketKeys.didConnect) { (data, ack) in
                if self.socket?.status == .connected {
                    if isUserLoggedin {
                    }
                }
            }
            self.socket?.on(SocketKeys.didDisconnect) { (data, ack) in
                print("socket disconnect")
            }
        }
    }
     
    /// Method to close socket connection at the time of logout
    func closeConnection() {
        self.stopListenChatSocket()
        socket?.disconnect()
        socket = nil
    }
    
    
}

// MARK: - IM Sockets
// remove observer to socket server
extension SocketIOManager {
    /// Method to stop listen Comments in joined room
    func stopListenChatSocket() {
        self.socket?.off(SocketKeys.message)
        self.socket?.off(SocketKeys.messageStatus)
        self.socket?.off(SocketKeys.chatThread)
        self.socket?.off(SocketKeys.chatStatus)
    }
    
    /// Method to stop listen Comments in joined room
    func stopListenComments() {
        self.socket?.off(SocketKeys.commentResponse)
    }
    
    /// Method to stop listen Pinned Comments in joined room
    func stopListenPinnedComments() {
        self.socket?.off(SocketKeys.pinnedCommentInfo)
    }
    
    /// Method to stop listen time over for live streaming  in joined room
    func stopListenTimeLimitOver() {
        self.socket?.off(SocketKeys.terminateLiveStream)
    }
    
    //MARK:- Socket emit and listeners
    func getSyncContactResponse() {
        SocketIOManager.shared.socket?.on(EventListnerKeys.syncResponse.rawValue, callback: { (data, ack) in
            guard let first = data.first as? JSONDictionary else{ return }
        })
    }
}