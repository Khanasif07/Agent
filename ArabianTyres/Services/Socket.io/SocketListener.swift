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
    
    /// Method to listen live viewers count
    func listenViewersCount(_ completionHandler: @escaping(_ count: Int) -> Void) {
        self.socket?.on(SocketKeys.viewersCount, callback: { data, _ in
            let json: JSON = JSON(data)
            completionHandler(json[0][ApiKey.data].intValue)
        })
    }
    
    /// Method to auto disconnect live streaming
    func listenAutoDisconnect() {
        self.socket?.on(SocketKeys.autoDisconnect, callback: { data, _ in
            printDebug(data)
            let json = JSON(data)
            var isBlocked = false
            if json.arrayValue.first![ApiKey.statusCode].intValue == 403 {
                isBlocked = true
            } else {
                isBlocked = false
            }
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name.liveStreamingTimeOver, object: nil, userInfo: ["isBlocked": isBlocked])
        })
    }
    
    func listenBlockedLivestream() {
        self.socket?.on(SocketKeys.autoDisconnect, callback: { _, _ in
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name.liveStreamingBlocked, object: nil)
        })
    }
    
    /// Method to listen online users when any one goes in and out from Room
    func listenOnlineUsers() {
        self.socket?.on(SocketKeys.onlineUsers, callback: { data, _ in
            printDebug(data)
            let json = JSON(data)
            if let jsonString = json.arrayValue.first![ApiKey.data].rawString(), let data = jsonString.data(using: .utf8) {
                do {
                    let modelOnlineUserUpdate = try JSONDecoder().decode(LiveUserData.self, from: data)
                    printDebug(modelOnlineUserUpdate)
                    
                    let nc = NotificationCenter.default
                    nc.post(name: Notification.Name.liveUserUpdate, object: modelOnlineUserUpdate)
                } catch {
                    printDebug("Error Occured due to Live User Model not parsed correctly.")
                }
                
            }
        })
    }
    
    /// Method to listen Comments in joined room
    func listenPinnedComment() {
        self.socket?.on(SocketKeys.pinnedCommentInfo, callback: { data, _ in
            printDebug(data)
            let json = JSON(data)
            if let jsonString = json.arrayValue.first![ApiKey.data][ApiKey.pinnedCommentObject].rawString(), let data = jsonString.data(using: .utf8) {
                do {
                    let objComment = try JSONDecoder().decode(LiveStreamComment.self, from: data)
                    printDebug(objComment)
                    let nc = NotificationCenter.default
                    nc.post(name: Notification.Name.listenPinnedComments, object: objComment)
                } catch {
                    printDebug("Error Occured due to Live Pinned comment Model not parsed correctly.")
                }
            }
        })
    }
    
    /// Method to listen Comments in joined room
    func listenComments() {
        self.socket?.on(SocketKeys.commentResponse, callback: { data, _ in
            printDebug(data)
            let json = JSON(data)
            if let jsonString = json.arrayValue.first![ApiKey.data].rawString(), let data = jsonString.data(using: .utf8) {
                do {
                    let objComment = try JSONDecoder().decode(LiveStreamComment.self, from: data)
                    printDebug(objComment)
                    
                    let nc = NotificationCenter.default
                    nc.post(name: Notification.Name.listenComments, object: objComment)
                } catch {
                    printDebug("Error Occured due to Live User Model not parsed correctly.")
                }
            }
        })
    }
    
    /// Method to listen time over for broad caster
    func listenTimeOver() {
        self.socket?.on(SocketKeys.terminateLiveStream, callback: { data, _ in
            printDebug(data)
            let json = JSON(data)
            if let jsonString = json.arrayValue.first![ApiKey.data].rawString(), let data = jsonString.data(using: .utf8) {
                do {
                    let modelOnlineUserUpdate = try JSONDecoder().decode(LiveUserData.self, from: data)
                    printDebug(modelOnlineUserUpdate)
                } catch {
                    printDebug("Error")
                }
            }
        })
    }
}
// MARK: - Backend listener
// ==============================
// new lister
// MARK: - IM Sockets
// listen message data to socket server
extension SocketIOManager {
    func receiveNewDirectMessages() {
        self.socket?.on(SocketKeys.message, callback: { (arrAckData, ack) in
            printDebug("New Message")
            guard let dictMsg = arrAckData.first as? JSONDictionary else { return }
            self.receiveNewMessage(newMsgData: dictMsg)
            ack.with(true)
        })
    }
    // [Delivered, Seen, Delete]
    func receiveMessageStatus() {
        self.socket?.on(SocketKeys.messageStatus, callback: { (arrAckData, ack) in
            guard let dataDict = arrAckData.first as? JSONDictionary else { return }
            guard let msgList = dataDict[ApiKey.data] as? JSONDictionaryArray else { return }
            self.receiveMessageStatus(msgList: msgList)
        })
    }
    
    // Receive Any newly created chat threads here specifically group threads
    func receiveNewChatThread() {
        self.socket?.on(SocketKeys.chatThread, callback: { (arrAckData, ack) in
            printDebug(arrAckData)
            guard let dataDict = arrAckData.first as? JSONDictionary else { return }
            guard let responseDataList = dataDict[ApiKey.data] as? JSONDictionaryArray else { return }
            self.receiveChatThreads(responseDataList: responseDataList)
        })
    }
    
    public func receiveChatThreads(responseDataList: JSONDictionaryArray) {
        DispatchQueue.global(qos: .background).async {
            var chatIds = [String]()
            let chatModelList = responseDataList.map({ (responseData) -> InboxDBDetail in
                let chatModel = InboxDBDetail.initializeWith(localChatId: responseData[ApiKey.localChatId] as? String ?? "", inboxData: responseData)
                if responseData[ApiKey.chatId] as? String ?? "" != "" {
                    chatIds.append(responseData[ApiKey.chatId] as? String ?? "")
                }
                return chatModel
            })
            InboxDBDetail.writeInboxListToDB(chatModelList: chatModelList)
            DispatchQueue.main.async {
                SocketIOManager.shared.emitChatThreadDeliveryStatus(chatIds: chatIds, service: .chatStatus, statusAction: .delivered)
            }
        }
    }
    // Receive chat threads delete emit
    public func receiveChatThreadDeleteEmit() {
        self.socket?.on(SocketKeys.chatStatus, callback: { (arrAckData, ack) in
            printDebug(arrAckData)
            guard let dataDict = arrAckData.first as? JSONDictionary else { return }
            guard let responseDataList = dataDict[ApiKey.data] as? JSONDictionaryArray else { return }
            self.receiveChatThreadsDeleteForAck(responseDataList: responseDataList)
        })
    }
    // Receive chat threads pinned emit
    public func receiveChatThreadPinnedEmit() {
        self.socket?.on(SocketKeys.pin, callback: { (arrAckData, ack) in
            printDebug(arrAckData)
            guard let dataDict = arrAckData.first as? JSONDictionary else { return }
            guard let responseDataList = dataDict[ApiKey.data] as? JSONDictionaryArray else { return }
            DispatchQueue.main.async {
                let eventIds = responseDataList.map { (responseData) -> String in
                    var chatData : [String:Any] = [:]
                    chatData[ApiKey.isPin] = responseData[ApiKey.isPin] as? Int == 1 ? true : false
                    chatData[ApiKey.pinCreatedAt] = responseData[ApiKey.pinCreatedAt] as? Double
                    if let chatModel = InboxDBDetail.getChatModelFor(localChatId: responseData[ApiKey.localChatId] as? String ?? "") {
                        _ = InboxDBDetail.updateInboxData(localChatId: chatModel.localChatId, inboxData: chatData)
                    }
                    return responseData[ApiKey.underScoreId] as? String ?? ""
                }
                SocketIOManager.shared.emitPinnedAcknowledgement(eventIds: eventIds)
            }
        })
        
    }
}
