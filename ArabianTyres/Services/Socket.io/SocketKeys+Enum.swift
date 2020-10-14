//
//  SocketKeys+Enum.swift
//  ArabianTyres
//
//  Created by Admin on 08/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import Foundation
// Events to handle Livestreming and Chat
struct SocketKeys {
    static let newRequest = "NEW_REQUEST"
    static let didConnect = "connect"
    static let didDisconnect = "disconnect"
    static let subscribe = "subscribe"
    static let joinRoom = "joinRoom"
    static let usersList = "userList"
    static let leaveRoom = "leaveRoom"
    static let attendLiveRoom  = "view"
    static let viewersCount = "viewerCount"
    static let onlineUsers = "onlineUsers"
    static let terminateLiveStream = "terminateLiveStream"
    static let sendComment = "addComment"
    static let autoDisconnect = "broadcastStopLive"
    static let commentResponse = "commentResponse"
    static let socketService = "socket-service"
    static let newMsgResponse = "newMsgResponse"
    static let pinnedComment = "liveStreamings/pinned"
    static let pinnedCommentInfo = "pinnedCommentInfo"
    static let chatListUpdate = "chatList"
    static let updateChatStatus = "updateChatStatus"
    static let chatACKRequest = "chatACKRequest"
    static let chatACKResponse = "chatACKResponse"
    static let event = "event"
    static let getChatListUserAndGroup = "getChatListUserAndGroup"
    static let userInfo = "userInfo"
    static let groupInfo = "groupInfo"
    static let syncACK = "syncACK"
    static let messageInfo = "messageInfo"
    static let chatListInfo = "chatListInfo"
    static let message = "message"
    static let messageStatus = "message-status"
    static let chatThread = "chat"//"chat-thread"
    static let chatStatus = "chat-status"
    static let pin = "pin"
}

enum SocketCodes: Int {
    case SocketSuccess = 200
    case SocketLiveUserError = 422
    case BadRequest = 400
    case SocketNewEntitySuccess = 201
    case SocketSuccessContact = 1
}
