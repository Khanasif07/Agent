//
//  FirestoreModel.swift
//  ArabianTyres
//
//  Created by Admin on 29/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON
import Firebase
import FirebaseFirestore

//MARK : - UserChatModel Structure
//============================
struct UserChatModel {
    
    //MARK:- Properties
    //===================
    public var userId: String = ""
    public var firstName: String = ""
    public var deviceId : String = ""
    public var deviceType : String = ""
    public var deviceToken : String = ""
    public var onlineStatus : String = ""
    public var email: String = ""
    public var pictureURL: String = ""
    public var lastMessage : String = ""
    public var image : String = ""
   
    //MARK:- Inits
    //=============
    init() { }
    
    init(_ dict: [String:Any]) {
         
        self.userId = dict[ApiKey.userId] as? String ?? ""
        self.firstName = dict[ApiKey.userName] as? String ?? ""
        self.deviceId =  dict[ApiKey.deviceId] as? String ?? ""
        self.deviceToken = dict[ApiKey.deviceToken] as? String ?? ""
        self.email = dict[ApiKey.email] as? String ?? ""
        self.image = dict[ApiKey.image] as? String ?? ""
        self.deviceType = dict[ApiKey.deviceType] as? String ?? ""
        let onlineStatusValue = dict[ApiKey.onlineStatus] as? Bool ?? false
        self.onlineStatus = onlineStatusValue ? "online" : "offline"
        self.lastMessage = dict[ApiKey.lastMessage] as? String ?? ""
     }

    
}

//MARK : - Room Info Structure
//============================
struct RoomInfo{
    
    //MARK:- Properties
    //=================
    public var roomId   : String = ""
    public var roomImage: String = ""
    public var roomType : String = ""
    public var roomName : String = ""
    public var userInfo : String = ""
    public var userTypingStatus : String = ""
    
    //MARK:- Inits
    //=============
    init() { }
    
    init(_ dict: [String:Any]) {
        self.roomId = dict[ApiKey.roomId] as? String ?? ""
        self.roomImage = dict[ApiKey.roomImage] as? String ?? ""
        self.roomType =  dict[ApiKey.roomType] as? String ?? ""
        self.roomName = dict[ApiKey.roomName] as? String ?? ""
        self.userInfo = dict[ApiKey.userInfo] as? String ?? ""
        self.userTypingStatus = dict[ApiKey.userTypingStatus] as? String ?? ""
      }
}

//MARK : - Inbox Structure
//========================
struct Inbox{
    
    //MARK:- Properties
    //===================
    public var lastMessageRef: DocumentReference?
    public var roomId: String = ""
    public var requestId: String = ""
    public var roomInfo : DocumentReference?
    public var timeStamp : Timestamp = Timestamp.init(date: Date())
    public var userDetails : DocumentReference?
    public var firstName : String = ""
    public var lastMessage : String = ""
    public var userId : String = ""
    public var receiverImgURL : String = ""
    public var unreadMessages : Int = 0
    public var userModel : UserChatModel = UserChatModel()
    public var chatType : String = "single"
    public var roomName : String = ""
    public var groupImage : String = ""
    public var isOnline : Bool = false

    //MARK:- Inits
    //=============
    init() { }
    
    init(_ dict: [String:Any]) {
        
        self.lastMessageRef = dict[ApiKey.lastMessage] as? DocumentReference
        self.roomId = dict[ApiKey.roomId] as? String ?? ""
        self.roomInfo =  dict[ApiKey.roomInfo] as? DocumentReference
        self.timeStamp = dict[ApiKey.timeStamp] as? Timestamp ?? Timestamp.init(date: Date())
        self.userDetails = dict[ApiKey.userDetails] as? DocumentReference
        self.firstName   = dict[ApiKey.firstName] as? String ?? ""
//        self.firstName   = dict[ApiKey.userName] as? String ?? ""
        self.lastMessage = dict[ApiKey.lastMessage] as? String ?? ""
       // self.blockedLastMessage = dict[ApiKey.lastMessage] as? String ?? StringConstants.defaultValue
        self.receiverImgURL = dict[ApiKey.image] as? String ?? ""
        self.userId = dict[ApiKey.userId] as? String ?? ""
        self.unreadMessages = dict[ApiKey.unreadMessages] as? Int ?? 0
        self.chatType = "single"
        self.roomName = dict[ApiKey.roomName] as? String ?? ""
        self.groupImage = dict[ApiKey.roomImage] as? String ?? ""
        self.requestId = dict[ApiKey.requestId] as? String ?? ""
      }
    
    private mutating func getUserModel(completeion: @escaping (_ model: UserChatModel) -> (),
                              failure: @escaping(_ error: Error) -> ()) {
        var model = UserChatModel()
        if let userRef = userDetails {
            userRef.getDocument(completion: { (doc, error) in
                if let err = error {
                    print(err.localizedDescription)
                    failure(err)
                } else {
                    if let data = doc?.data() {
                        model = UserChatModel(data)
                        completeion(model)
                    }
                }
            })
        }
    }
    
    public mutating func updateUnreadMessages(count: Int) {
        self.unreadMessages = count
    }
}

//MARK : - Message
//================
struct Message{
    
    //MARK:- Properties
    //===================
    public var messageId: String = ""
    public var messageStatus: Int  = -1
    public var messageText : String = ""
    public var messageTime : Timestamp = Timestamp(date: Date())
    public var messageType : String = ""
    public var receiverId : String = ""
    public var senderId : String = ""
    public var roomId : String = ""
    public var mediaUrl : String = ""
    public var blocked : Bool = false
    public var tempImage : UIImage = UIImage()
    public var thumbnailURL : String = ""
    public var messageDuration : Int = 0
    
    //MARK:- Inits
    //=============
    init() { }
    
    init(_ dict: [String:Any]) {
        
        self.messageId = dict[ApiKey.messageId] as? String ?? ""
        self.messageStatus = dict[ApiKey.messageStatus] as? Int ?? 1
        self.messageText =  dict[ApiKey.messageText] as? String ?? ""
        self.messageTime = dict[ApiKey.messageTime] as? Timestamp ?? Timestamp(date: Date())
        self.messageType = dict[ApiKey.messageType] as? String ?? ""
        self.receiverId   = dict[ApiKey.receiverId] as? String ?? ""
        self.senderId = dict[ApiKey.senderId] as? String ?? ""
        self.roomId = dict[ApiKey.roomId] as? String ?? ""
        self.mediaUrl = dict[ApiKey.mediaUrl] as? String ?? ""
        self.thumbnailURL = dict[ApiKey.thumbnail] as? String ?? ""
        self.blocked = dict[ApiKey.blocked] as? Bool ?? false
        self.messageDuration =  dict[ApiKey.messageDuration] as? Int ?? 0
      }
}

//MARK : - Batch Count
//====================
struct BatchCount {
    
    var unreadMessages : CLong = 0
    
    //MARK:- Inits
    //=============
    init() { }
    
    init(_ dict: [String:Any]) {
        self.unreadMessages = dict[ApiKey.unreadMessages] as? CLong ?? 0
    }
}

//MARK : - User Type
//==================
struct userType {
    public var receiverId :String = ""
    public var senderId : String = ""
}


//MARK : - Time Status
//====================
struct timeStatus {
    public var addedTime : Any
    public var deletedTime : Any
    public var leaveTime :  Any
}

//MARK : - Message Type
//=====================
enum MessageType: String {
    case text = "text"
    case image = "image"
    case audio = "audio"
    case location = "location"
    case offer = "offer"
    case payment = "payment"
}
