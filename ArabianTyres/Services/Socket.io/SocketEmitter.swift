//
//  SocketEmitter.swift
//  ArabianTyres
//
//  Created by Admin on 08/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON
//import SocketIO

// MARK: - Emitter for Live Stream
extension SocketIOManager {

        /// Emit at the time of joining Room for Live streaming
    func emitJoinRoom(_ strUserId: String, _ strRoomName: String, _ liveStreamingForFollower: Bool, _ completionHandler: @escaping((Bool, Int)) -> Void) {
            if SocketIOManager.isSocketConnected {
                
                let dict: NSDictionary = [ApiKey.channelName: strRoomName, ApiKey.liveStreamingForFollower: liveStreamingForFollower]
                // Create join room data packet to be sent to socket server
                var msgDataPacket = [String: Any]()
                msgDataPacket[ApiKey.type] = SocketService.joinRoom.type
                msgDataPacket[ApiKey.actionType] = SocketService.joinRoom.listenerType
                msgDataPacket[ApiKey.data] = dict
                
                let ack = self.socket?.emitWithAck(SocketKeys.socketService, msgDataPacket)
                ack?.timingOut(after: 20, callback: { (data) in
                printDebug(data)
                    let json = JSON(data.first ?? JSON())
                    completionHandler((json[ApiKey.status].boolValue, json[ApiKey.statusCode].intValue))
                    printDebug("Joined room successfully")
                })
            }
        }
        
        /// Emit at the time of watching Live streaming
        func emitViewRoom(_ strUserId: String, _ strRoomName: String) {
            if SocketIOManager.isSocketConnected {
    //            let dict: NSDictionary = [ApiKey.userId: strUserId, ApiKey.channelName: strRoomName]
                let dict: NSDictionary = [ApiKey.channelName: strRoomName]
                var msgDataPacket = [String: Any]()
                msgDataPacket[ApiKey.type] = SocketService.view.type
                msgDataPacket[ApiKey.actionType] = SocketService.view.listenerType
                msgDataPacket[ApiKey.data] = dict
                let ack = self.socket?.emitWithAck(SocketKeys.socketService, msgDataPacket)
                ack?.timingOut(after: 20, callback: { (_) in
                    printDebug("Joined room successfully")
                })
            }
        }
        
        /// Emit at the time of commenting on Live streaming
        func emitComment(_ strUserId: String, _ strRoomName: String, _ strCommentText: String, _ commentDate: Int64, _ completionHandler: @escaping(_ liveStreamComment: LiveStreamComment) -> Void) {
            if SocketIOManager.isSocketConnected {
    //            let dict: NSDictionary = [ApiKey.userId: strUserId, ApiKey.channelName: strRoomName, ApiKey.comment: strCommentText, ApiKey.commentDate: commentDate]
                let dict: NSDictionary = [ApiKey.channelName: strRoomName, ApiKey.comment: strCommentText, ApiKey.commentDate: commentDate]
                var msgDataPacket = [String: Any]()
                msgDataPacket[ApiKey.type] = SocketService.addComment.type
                msgDataPacket[ApiKey.actionType] = SocketService.addComment.listenerType
                msgDataPacket[ApiKey.data] = dict
                let ack = self.socket?.emitWithAck(SocketKeys.socketService, msgDataPacket)
                ack?.timingOut(after: 20, callback: { (data) in
                    let json = JSON(data)
                    if let jsonString = json.arrayValue.first![ApiKey.data].rawString(), let data = jsonString.data(using: .utf8) {
                        do {
                            let modelList = try JSONDecoder().decode(LiveStreamComment.self, from: data)
                            printDebug(modelList)
                            completionHandler(modelList)
                        } catch {
                            printDebug("Error")
                        }
                    }
                    printDebug("Comment posted successfully")
                })
            }
        }
        
        /// Emit at the time of leaving Room for Live streaming
        func emitLeaveRoom(_ strUserId: String, _ strRoomName: String, _ completionHandler: @escaping(_ objLiveUsers: [LiveUserData]) -> Void) {
            if SocketIOManager.isSocketConnected {
                //            let strChannelName = CompleteProfileModel.getProfileDetails.id + strRoomName
                let strChannelName = strRoomName
    //            let dict: NSDictionary = [ApiKey.userId: strUserId, ApiKey.channelName: strChannelName]
                let dict: NSDictionary = [ApiKey.channelName: strChannelName]
                var msgDataPacket = [String: Any]()
                msgDataPacket[ApiKey.type] = SocketService.leaveRoom.type
                msgDataPacket[ApiKey.actionType] = SocketService.leaveRoom.listenerType
                msgDataPacket[ApiKey.data] = dict
                let ack = self.socket?.emitWithAck(SocketKeys.socketService, msgDataPacket)
                ack?.timingOut(after: 20, callback: { (_) in
                    printDebug("Leave room successfully")
                })
            }
        }
        
        /// Emit at the time of attending Room for Live streaming
        func emitAttendLiveStreaming(_ strUserId: String, _ strRoomName: String) {
            let dict: NSDictionary = [ApiKey.userId: strUserId, ApiKey.channelName: strRoomName]
            var msgDataPacket = [String: Any]()
            msgDataPacket[ApiKey.type] = SocketService.view.type
            msgDataPacket[ApiKey.actionType] = SocketService.view.listenerType
            msgDataPacket[ApiKey.data] = dict
            
            self.socket?.emit(SocketKeys.attendLiveRoom, with: [msgDataPacket], completion: {
                printDebug("Success emit")
            })
        }
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
extension SocketIOManager {
    func emitMessageService(localChatId: String, localMsgId: String, msgData: [String: Any], messageServiceType: SocketService, completionHandler: ((Bool, String) -> Void)? = nil) {
        // Create Message data packet to be sent to socket server
        var msgDataPacket = [String: Any]()
        msgDataPacket[ApiKey.type] = messageServiceType.type
        msgDataPacket[ApiKey.actionType] = messageServiceType.listenerType
        let tempData = msgData
        let localCreatedAt = tempData[ApiKey.createdAt] as? String ?? "0.0"
        msgDataPacket[ApiKey.data] = tempData
        
        // send the messsage  data packet to socket server & wait for the acknowledgement
        if let chatModel = InboxDBDetail.getChatModelFor(localChatId: localChatId) {
            self.emit(with: SocketKeys.socketService, msgDataPacket) { (arrAckData) in
                DispatchQueue.main.async {
                    if let arrData = arrAckData as? [[String: AnyObject]], let dictMsg = arrData.first, let arrChatData = dictMsg[ApiKey.data] as? JSONDictionaryArray {
                        guard var chatData = arrChatData.first else { return }
                        chatData[ApiKey.createdAt] = localCreatedAt
                        var msgStatus = 1
                        if let statusARR = chatData[ApiKey.status] as? JSONDictionaryArray {
                            statusARR.forEach({ status in
                                if status[ApiKey.userId] as? String != CompleteProfileModel.getProfileDetails.id {
                                    if status["isSeen"] as? Bool == true {
                                        msgStatus = 3
                                    } else if status["isDelivered"] as? Bool == true {
                                        msgStatus = 2
                                    } else {
                                        msgStatus = 1
                                    }
                                }
                            })
                        }
                        _ = ChatMessageDBData.saveMessageData(msgData: chatData, localMsgId: localMsgId, localChatId: chatModel.localChatId, msgStatus: msgStatus, seenByMe: true)
                        _ = InboxDBDetail.saveInboxData(localChatId: localChatId, inboxData: chatData)
                        completionHandler?(true, "")
                    } else {
                        ChatMessageDBData.updateMsgStatus(localMsgId: localMsgId, msgStatus: 0)
                        completionHandler?(false, StringConstant.noInternetAvailable.value)
                    }
                }
            }
        } else {
            self.emit(with: SocketKeys.socketService, msgDataPacket) { (arrAckData) in
                DispatchQueue.main.async {
                    if let arrData = arrAckData as? [[String: AnyObject]], let dictMsg = arrData.first, let arrChatData = dictMsg[ApiKey.data] as? JSONDictionaryArray {
                        guard var chatData = arrChatData.first else { return }
                        chatData[ApiKey.createdAt] = localCreatedAt
                        var msgStatus = 1
                        if let statusARR = chatData[ApiKey.status] as? JSONDictionaryArray {
                            statusARR.forEach({ status in
                                if status[ApiKey.userId] as? String != CompleteProfileModel.getProfileDetails.id {
                                    if status["isSeen"] as? Bool == true {
                                        msgStatus = 3
                                    } else if status["isDelivered"] as? Bool == true {
                                        msgStatus = 2
                                    } else {
                                        msgStatus = 1
                                    }
                                }
                            })
                        }
                        _ = ChatMessageDBData.saveMessageData(msgData: chatData, localMsgId: localMsgId, localChatId: "", msgStatus: msgStatus, seenByMe: true)
                        _ = InboxDBDetail.saveInboxData(localChatId: localChatId, inboxData: chatData)
                        completionHandler?(true, "")
                    } else {
                        ChatMessageDBData.updateMsgStatus(localMsgId: localMsgId, msgStatus: 0)
                        completionHandler?(false, StringConstant.noInternetAvailable.value)
                    }
                }
            }
        }
    }
    //Emit Message Status [Seen, Deliverd, Delete]
    func emitMessageStatus(data: [[String: Any]], msgStatus: ChatMsgStatus) {
        
        // Create Message data packet to be sent to socket server
        var msgDataPacket = [String: Any]()
        msgDataPacket[ApiKey.type] = SocketService.messageStatus.type
        msgDataPacket[ApiKey.actionType] = SocketService.messageStatus.listenerType
        msgDataPacket[ApiKey.data] = [ApiKey.ackData: data]
        // send the messsage  data packet to socket server & wait for the acknowledgement
        printDebug(msgDataPacket)
        self.emit(with: SocketKeys.socketService, msgDataPacket) { (arrAckData) in
            
        }
    }
    
    public func updateMessageStatusFor(msgList: JSONDictionaryArray) {
        _ = CompleteProfileModel.getProfileDetails.id
        DispatchQueue.global(qos: .background).async {
            var msgModels = [ChatMessageDBData]()
            _ = [ChatMessageDBData]()
            for msgData in msgList {
                guard let actionType = msgData[ApiKey.statusAction] as? String, let _ = msgData[ApiKey.chatId] as? String, let msgStatusAction = ChatMsgStatus(rawValue: actionType) else { return }
                switch msgStatusAction {
                case .delivered:
                    if let msgId = msgData[ApiKey.messageId] as? String, let deliveredTo = msgData[ApiKey.deliveredTo] as? JSONDictionaryArray {
                        if let msgModel = ChatMessageDBData.getUpdateMsgForDelivery(msgId: msgId, deliveredTo: deliveredTo) {
                            msgModels.append(msgModel)
                        }
                    }
                case .seen:
                    if let msgId = msgData[ApiKey.messageId] as? String, let seenBy = msgData[ApiKey.seenBy] as? JSONDictionaryArray {
                        let deliveredTo = msgData[ApiKey.deliveredTo] as? JSONDictionaryArray
                        if let msgModel = ChatMessageDBData.getUpdateMsgForSeenDelivered(msgId: msgId, seenBy: seenBy, deliveredTo: deliveredTo) {
                            msgModels.append(msgModel)
                        }
                    }
                case .delete:
                    if let msgId = msgData[ApiKey.messageId] as? String {
                        if let msgModel = ChatMessageDBData.getDeletedChatMessageDBData(msgId: msgId) {
                            msgModels.append(msgModel)
                        }
                    }
                case .unDelivered, .ackMsgStatus, .deletedChatAck, .undeletedMsgAck, .deletedMsgAck, .undeletedChatAck, .unDeliveredBlockAck, .unDeliveredUnBlockAck, .deliveredBlockAck, .deliveredUnBlockAck, .deliveredUserInfo, .undeliveredUserInfo, .unDeliveredActionByAdminAck, .deliveredActionByAdminAck,.deletedSingLeMessageAck,.undeletedSingLeMessageAck,.deliveredPin,.unDeliveredPin: break
                 
                case .unDeliveredIsChat:
                    break
                case .deliveredIsChat:
                    break
                }
                
            }
            ChatMessageDBData.writeMessageListToRealm(msgList: msgModels)
        }
    }
    // Emit Message Acknowledgement: [AckMsg]
    func emitMessageAcknowledgement(msgIds: [String]) {
        
        // Create Message data packet to be sent to socket server
        var msgDataPacket = [String: Any]()
        msgDataPacket[ApiKey.type] = SocketService.messageStatusAck.type
        msgDataPacket[ApiKey.actionType] = SocketService.messageStatusAck.listenerType
        msgDataPacket[ApiKey.data] = [
            ApiKey.messageIds: msgIds,
            ApiKey.statusAction: ChatMsgStatus.ackMsgStatus.rawValue
        ]
        
        // send the messsage  data packet to socket server & wait for the acknowledgement
        self.emit(with: SocketKeys.socketService, msgDataPacket) { (arrAckData) in
            guard let dictMsg = arrAckData.first as? JSONDictionary else { return }
            guard let msgList = dictMsg[ApiKey.data] as? JSONDictionaryArray  else { return }
            SocketIOManager.shared.updateMessageStatusFor(msgList: msgList)
        }
    }
    // Emit Pinned Acknowledgement: [AckMsg]
    func emitPinnedAcknowledgement(eventIds: [String]) {
        
        // Create Message data packet to be sent to socket server
        var msgDataPacket = [String: Any]()
        msgDataPacket[ApiKey.type] = SocketService.pinnedAck.type
        msgDataPacket[ApiKey.actionType] = SocketService.pinnedAck.listenerType
        msgDataPacket[ApiKey.data] = [
            ApiKey.ackIds: eventIds,
            ApiKey.statusAction: ChatMsgStatus.deliveredPin.rawValue
        ]
        
        // send the messsage  data packet to socket server & wait for the acknowledgement
        self.emit(with: SocketKeys.socketService, msgDataPacket) { (arrAckData) in
            
        }
    }
    // Emit Acknowledgement for chat thread delivery
    func emitChatThreadDeliveryStatus(chatIds: [String], service: SocketService, statusAction: ChatMsgStatus) {
        
        // Create Message data packet to be sent to socket server
        var msgDataPacket = [String: Any]()
        msgDataPacket[ApiKey.type] = service.type
        msgDataPacket[ApiKey.actionType] = service.listenerType
        
        msgDataPacket[ApiKey.data] = [ApiKey.ackData: [[
            ApiKey.chatIds: chatIds,
            ApiKey.statusAction: statusAction.rawValue
            ]], ApiKey.deviceId: DeviceDetail.deviceId]
        
        // send the messsage  data packet to socket server & wait for the acknowledgement
        self.emit(with: SocketKeys.socketService, msgDataPacket) { (arrAckData) in
            
        }
    }
    // Emit Acknowledgement for chat thread delete
    func emitChatThreadDeleteStatus(eventIds: [String], service: SocketService, statusAction: ChatMsgStatus) {
        
        // Create Message data packet to be sent to socket server
        var msgDataPacket = [String: Any]()
        msgDataPacket[ApiKey.type] = service.type
        msgDataPacket[ApiKey.actionType] = service.listenerType
        
        msgDataPacket[ApiKey.data] = [
            ApiKey.ackIds: eventIds,
            ApiKey.statusAction: statusAction.rawValue
        ]
        
        // send the messsage  data packet to socket server & wait for the acknowledgement
        self.emit(with: SocketKeys.socketService, msgDataPacket) { (arrAckData) in
            
        }
    }
    // Emit Acknowledgement for ischat active
    func emitIsChatThreadActiveStatus(eventIds: [String], service: SocketService, statusAction: ChatMsgStatus) {
        
        // Create Message data packet to be sent to socket server
        var msgDataPacket = [String: Any]()
        msgDataPacket[ApiKey.type] = service.type
        msgDataPacket[ApiKey.actionType] = service.listenerType
        msgDataPacket[ApiKey.data] = [
            ApiKey.ackIds: eventIds,
            ApiKey.statusAction: statusAction.rawValue
        ]
        
        // send the messsage  data packet to socket server & wait for the acknowledgement
        self.emit(with: SocketKeys.socketService, msgDataPacket) { (arrAckData) in
            
        }
    }
    //Emit  Status for [Pin Chat, UnPin Chat]
    func emitPinnedStatus(data: [String: Any]) {
        
        // Create Message data packet to be sent to socket server
        var msgDataPacket = [String: Any]()
        msgDataPacket[ApiKey.type] = SocketService.pinnedChat.type
        msgDataPacket[ApiKey.actionType] = SocketService.pinnedChat.listenerType
        msgDataPacket[ApiKey.data] = data
        // send the messsage  data packet to socket server & wait for the acknowledgement
        printDebug(msgDataPacket)
        self.emit(with: SocketKeys.socketService, msgDataPacket) { (arrAckData) in
            printDebug(arrAckData)
            DispatchQueue.main.async {
                if let arrData = arrAckData as? [[String: AnyObject]], let dictMsg = arrData.first, let arrChatData = dictMsg[ApiKey.data] as? JSONDictionaryArray {
                    guard var chatData = arrChatData.first else { return }
                    chatData[ApiKey.isPin] = chatData[ApiKey.isPin] as? Int == 1 ? true : false
                    if let chatModel = InboxDBDetail.getChatModelFor(localChatId: chatData[ApiKey.localChatId] as! String) {
                        _ = InboxDBDetail.updateInboxData(localChatId: chatModel.localChatId, inboxData: chatData)
                    }
                   
                }
            }
        }
    }
}
