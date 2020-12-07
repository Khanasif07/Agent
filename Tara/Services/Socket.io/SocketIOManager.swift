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

enum EventListnerKeys : String ,Codable {
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
    case otpToStartService = "OTP_TO_START_SERVICE"
    case serviceStatusUpdated = "SERVICE_STATUS_UPDATED"
    case serviceStarted = "SERVICE_STARTED"
    case editedBidAccepted = "EDITED_BID_ACCEPTED"
    case bid_cancelled = "BID_CANCELLED"
    case garageRequestRejected = "GARAGE_REQUEST_REJECTED"
    case garageRequestApproved = "GARAGE_REQUEST_APPROVED"
    case payment_recieved_by_garage =  "PAYMENT_RECEIVED"
}

class SocketIOManager: NSObject {
    
    // MARK: - PROPERTIES
    //==================
    
    var baseSocketUrl: String {
        #if ENV_DEV
        return "https://arabiantyersdevapi.appskeeper.com"
        #elseif ENV_STAG
        return "https://arabiantyersstgapi.appskeeper.com"
        #elseif ENV_QA
        return "https://arabiantyersqaapi.appskeeper.com"
        #elseif ENV_PROD
        return "https://arabiantyersstgapi.appskeeper.com"
        #else
        return ""
        #endif
    }
    var socket: SocketIOClient?
    private var manager: SocketManager?
    static let shared: SocketIOManager = SocketIOManager()
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
                if isUserLoggedin {
                    self.establishConnection()
                }
            }
        }
    }
     
    /// Method to close socket connection at the time of logout
    func closeConnection() {
        socket?.disconnect()
        socket = nil
    }
}
