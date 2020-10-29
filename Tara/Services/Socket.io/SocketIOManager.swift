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
    case newBid =  "NEW_BID"
    case bidAccepted = "BID_ACCEPTED"
    case newRequest = "NEW_REQUEST"
    case bidRejected = "BID_REJECTED"
    case requestRejected = "REQUEST_REJECTED"
    case requestCancelled = "REQUEST_CANCELLED"
    case didConnect = "connected"
    case didDisConnect = "disconnected"
    case bidEdit = "BID_EDIT"
    case handshakeWithServer = "handshakeWithServer"
    case eventAck = "eventAck"
    case syncResponse = "contact_sync_response"
}

class SocketIOManager: NSObject {
    
    // MARK: - PROPERTIES
    //==================
    var socket: SocketIOClient?
    private var manager: SocketManager?
    static let shared: SocketIOManager = SocketIOManager()
//    public var baseSocketUrl: String  = "https://arabiantyersdevapi.appskeeper.com" // dev socket url
    public var baseSocketUrl: String  = "http://arabiantyersqaapi.appskeeper.com" // qa socket url
//    public var baseSocketUrl: String  = "https://arabiantyersstgapi.appskeeper.com" // stg socket url


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
        let userId = AppUserDefaults.value(forKey: .userId).stringValue
            let strUrl = baseSocketUrl
            let baseUrl = URL(string: strUrl)!
            self.manager = SocketManager(socketURL: baseUrl,
                                         config: [.log(true),
                                                  .connectParams(["userId": userId]),
                                                  .forcePolling(false),
                                                  .reconnects(true),
                                                  .reconnectAttempts(10),
                                                  .reconnectWait(10),
                                                  .reconnectWaitMax(20),
                                                  .forceNew(true),
                                                  .handleQueue(socketSerialQueue)])
            self.socket = manager?.defaultSocket
            self.listenOnlineUsers()
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
                        print("//////////+++socket connected+++//////////")
                    }
                }
            }
            self.socket?.on(SocketKeys.didDisconnect) { (data, ack) in
                print("//////////+++socket disconnect+++//////////")
                self.establishConnection()
            }
        }
    }
     
    /// Method to close socket connection at the time of logout
    func closeConnection() {
        socket?.disconnect()
        socket = nil
    }
    
    
}

// MARK: - IM Sockets
// remove observer to socket server
extension SocketIOManager {
  
}
