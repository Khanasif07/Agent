//
//  FirestoreController.swift
//  ArabianTyres
//
//  Created by Admin on 27/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Firebase
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FirestoreController:NSObject{
    
    static let db = Firestore.firestore()
    static var ownUnreadCount = 0
    static var otherUnreadCount = 0
    
    //MARK:- Login
    //============
    static func login(userId: String,
                      withEmail:String,
                      with password:String,
                      success: @escaping () -> Void,
                      failure: @escaping (_ message: String, _ code: Int) -> Void) {
        var emailId  = withEmail
        if emailId.isEmpty{
            emailId = "\(userId)" + "@tara.com"
        }
        let defaultPassword = "Tara@123"
        Auth.auth().signIn(withEmail: emailId, password: defaultPassword) { (result, error) in
            if let err = error {
                failure(err.localizedDescription, (err as NSError).code)
            } else {
                AppUserDefaults.save(value: userId, forKey: .uid)
                AppUserDefaults.save(value: withEmail, forKey: .defaultEmail)
                AppUserDefaults.save(value: password, forKey: .defaultPassword)
                if !userId.isEmpty {
                    print("login successfull")
                    db.collection(ApiKey.users).document(userId).updateData([ApiKey.onlineStatus: true, ApiKey.deviceToken: AppUserDefaults.value(forKey: .fcmToken).stringValue,
                                                                             ApiKey.deviceId:"2",
                                                                             ApiKey.deviceType: "iOS"])
                    success()
                } else {
                    failure("documentFetchingError", 110)
                }
            }
        }
    }
    
    //MARK:- CREATE ROOM NODE
    //=======================
    static func createRoomNode(roomId: String,
                               roomImage: String,
                               roomName: String,
                               roomType: String,
                               userInfo: [String:Any],
                               userTypingStatus: [String:Any]) {
        db.collection(ApiKey.roomInfo).document(roomId).setData([ApiKey.roomId : roomId,
                                                                 ApiKey.roomImage:roomImage,
                                                                 ApiKey.roomName:roomName,
                                                                 ApiKey.roomType:roomType,
                                                                 ApiKey.userInfo:userInfo,
                                                                 ApiKey.typingStatus:userTypingStatus])
    }
    
    //MARK:- CREATE USER NODE
    //=======================
    static func createUserNode(userId: String,
                               email: String,
                               password: String,
                               name: String,
                               imageURL: String,
                               phoneNo: String,
                               countryCode: String,
                               status: String,
                               completion: @escaping () -> Void,
                               failure: @escaping FailureResponse) {
        var emailId  = email
        if emailId.isEmpty{
            emailId = "\(userId)" + "@tara.com"
        }
        Auth.auth().createUser(withEmail: emailId, password: password) { (result, error) in
            if let err = error {
                failure(err)
            } else {
                AppUserDefaults.save(value: userId, forKey: .uid)
                AppUserDefaults.save(value: email, forKey: .defaultEmail)
                AppUserDefaults.save(value: password, forKey: .defaultPassword)
                db.collection(ApiKey.users).document(userId).setData([ApiKey.deviceType:"iOS",
                                                                      ApiKey.deviceId:"2",
                                                                      ApiKey.email: email,
                                                                      ApiKey.deviceToken:AppUserDefaults.value(forKey: .fcmToken).stringValue,
                                                                      ApiKey.userName:name,
                                                                      ApiKey.userImage: imageURL,
                                                                      ApiKey.onlineStatus:true,
                                                                      ApiKey.countryCode:countryCode,
                                                                      ApiKey.userId: userId,
                    ApiKey.phoneNo: phoneNo]){ err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                completion()
            }
        }
    }
    
    //MARK:- setFirebaseData
    //=======================
    static func setFirebaseData(userId: String,
                                email: String,
                                password: String,
                                name: String,
                                imageURL: String,
                                phoneNo: String,
                                countryCode: String,
                                status: String,
                                completion: @escaping () -> Void,
                                failure: @escaping FailureResponse){
        AppUserDefaults.save(value: userId, forKey: .uid)
        AppUserDefaults.save(value: email, forKey: .defaultEmail)
        AppUserDefaults.save(value: password, forKey: .defaultPassword)
        db.collection(ApiKey.users).document(userId).setData([ApiKey.deviceType:"iOS",
                                                              ApiKey.deviceId:"2",
                                                              ApiKey.email: email,
                                                              ApiKey.deviceToken:AppUserDefaults.value(forKey: .fcmToken).stringValue,
                                                              ApiKey.userName:name,
                                                              ApiKey.userImage: imageURL,
                                                              ApiKey.onlineStatus:true,
                                                              ApiKey.status: status,
                                                              ApiKey.userId: userId,
                                                              ApiKey.phoneNo: phoneNo,ApiKey.countryCode: countryCode]){ err in
                                                                if let err = err {
                                                                    failure(err)
                                                                    print("Error writing document: \(err)")
                                                                } else {
                                                                    completion()
                                                                    print("Document successfully written!")
                                                                }
        }
    }
    
    //MARK:- Update user data
    //=======================
    static func updateUserNode(name: String,
                               imageURL: String,
                               countryCode:String,
                               email:String,
                               phoneNo: String,
                               completion: @escaping () -> Void,
                               failure: @escaping FailureResponse) {
        let uid = AppUserDefaults.value(forKey: .uid).stringValue
        db.collection(ApiKey.users).document(uid).updateData([ApiKey.deviceType:"iOS",
                                                              ApiKey.deviceId:"2",
                                                              ApiKey.deviceToken:AppUserDefaults.value(forKey: .fcmToken).stringValue,
                                                              ApiKey.userName:name,
                                                              ApiKey.userImage: imageURL,
                                                              ApiKey.phoneNo: phoneNo,ApiKey.countryCode:countryCode,ApiKey.email: email])
        { (error) in
            if let err = error {
                failure(err)
            } else {
                completion()
            }
        }
    }
    
    //MARK:- Update user online status
    //================================
    static func updateUserOnlineStatus(isOnline: Bool) {
        let uid = AppUserDefaults.value(forKey: .uid).stringValue
        guard !uid.isEmpty else { return }
        db.collection(ApiKey.users).document(uid).updateData([ApiKey.onlineStatus:isOnline])
    }
    
    //MARK:- Update user online status
    //================================
    static func updateDeviceToken() {
        let uid = AppUserDefaults.value(forKey: .uid).stringValue
        guard !uid.isEmpty else { return }
        db.collection(ApiKey.users).document(uid).updateData([ApiKey.deviceToken: ""])
    }
    
    //MARK:-Fetching Listing
    //======================
    static func fetchingUserNode(listing: [String], dict: [String:Any], tableView: UITableView) {
        db.collection(ApiKey.users).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if document.data()["userId"] as? String != AppUserDefaults.value(forKey: .uid).stringValue {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
                tableView.reloadData()
            }
        }
    }
    
    //MARK:- CREATE LAST MESSAGE NODE
    //===============================
    static func createLastMessageNode(roomId:String,messageText:String,messageTime:FieldValue,messageId:String,messageType:String,messageStatus:Int,senderId:String,receiverId:String,mediaUrl:String,blocked: Bool, thumbNailURL: String,messageDuration: Int,price: Double, amIBlocked : Bool) {
        
        db.collection(ApiKey.lastMessage)
            .document(roomId)
            .collection(ApiKey.chat)
            .document(ApiKey.message)
            .setData([ApiKey.messageText:messageText,
                      ApiKey.messageId:messageId,
                      ApiKey.messageTime:FieldValue.serverTimestamp(),
                      ApiKey.messageStatus:messageStatus,
                      ApiKey.messageType:messageType,
                      ApiKey.senderId:senderId,
                      ApiKey.receiverId:receiverId,
                      ApiKey.roomId:roomId,
                      ApiKey.mediaUrl : mediaUrl,
                      ApiKey.blocked :blocked,
                      ApiKey.price: price,
                      ApiKey.messageDuration : messageDuration])
        
        if !amIBlocked {
            db.collection(ApiKey.lastMessage)
                .document(roomId)
                .collection(ApiKey.chat)
                .document(receiverId).delete()
        }
    }
    
    //MARK:- CREATE LAST MESSAGE NODE AFTER DELETE MESSAGE
    //===============================
    static func createLastMessageNodeAfterDeleteMessage(roomId:String,messageText:String,messageTime:Timestamp,messageId:String,messageType:String,messageStatus:Int,senderId:String,receiverId:String,mediaUrl:String,blocked: Bool, thumbNailURL: String,messageDuration: Int,price: Double, amIBlocked : Bool) {
        
        db.collection(ApiKey.lastMessage)
            .document(roomId)
            .collection(ApiKey.chat)
            .document(ApiKey.message)
            .setData([ApiKey.messageText:messageText,
                      ApiKey.messageId:messageId,
                      ApiKey.messageTime: messageTime,
                      ApiKey.messageStatus:messageStatus,
                      ApiKey.messageType:messageType,
                      ApiKey.senderId:senderId,
                      ApiKey.receiverId:receiverId,
                      ApiKey.roomId:roomId,
                      ApiKey.mediaUrl : mediaUrl,
                      ApiKey.blocked :blocked,
                      ApiKey.price: price,
                      ApiKey.messageDuration : messageDuration])
        
    }
    
    //MARK:- CREATE LAST MESSAGE OF BLOCKED USER
    //==========================================
    static func createLastMessageOfBlockedUser(roomId: String, senderId: String, messageModel: [String:Any]) {
        db.collection(ApiKey.lastMessage)
            .document(roomId)
            .collection(ApiKey.chat)
            .document(senderId).setData(messageModel)
    }
    
    //MARK:- CREATE TOTAL MESSAGE COUNT
    //=================================
    static func getTotalMessagesCount(senderId: String) {
        db.collection(ApiKey.batchCount).document(senderId).addSnapshotListener { (documentSnapshot, error) in
            if  let error = error {
                print(error.localizedDescription)
            }else{
                guard let documents = documentSnapshot?.data() else {return}
                for totalUnreadMessages in documents{
                    FirestoreController.otherUnreadCount = totalUnreadMessages.value as? Int ?? 0
                }
            }
        }
    }
    
    //MARK:- CREATE TOTAL MESSAGE NODE
    //================================
    static func createTotalMessageNode(receiverId: String) {
        db.collection(ApiKey.batchCount)
            .document(receiverId)
            .setData([ApiKey.unreadCount: FirestoreController.otherUnreadCount + 1])
    }
    
    //MARK:-GetUnreadMessages
    //=======================
    static func getUnreadMessageCount(receiverId: String, senderId: String) {
        db.collection(ApiKey.inbox)
            .document(senderId)
            .collection(ApiKey.chat)
            .document(receiverId)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else { print("Error fetching document: \(error!)")
                    return }
                guard let data = document.data() else { return }
                FirestoreController.otherUnreadCount =   data[ApiKey.unreadCount] as? Int ?? 0
        }
    }
    
    static func updateUnreadMessages(senderId: String, receiverId: String, unread: Int) {
        db.collection(ApiKey.inbox)
            .document(receiverId)
            .collection(ApiKey.chat)
            .document(senderId)
            .updateData([ApiKey.unreadCount : unread + 1])
        
        db.collection(ApiKey.batchCount).document(receiverId).getDocument { (document, error) in
                if let doc = document {
                    if doc.exists {
                        guard let count = doc.data()?[ApiKey.unreadCount] as? Int else { return }
                        db.collection(ApiKey.batchCount).document(receiverId).setData([ApiKey.unreadCount : count + 1])
                    } else {
                        db.collection(ApiKey.batchCount).document(receiverId).setData([ApiKey.unreadCount: 1])
                    }
            }
        }
    }
    
    static func updateUnreadMessagesAfterDeleteMessage(senderId: String, receiverId: String, unread: Int) {
        db.collection(ApiKey.inbox)
            .document(receiverId)
            .collection(ApiKey.chat)
            .document(senderId)
            .updateData([ApiKey.unreadCount : unread - 1])
        
        db.collection(ApiKey.batchCount).document(receiverId).getDocument { (document, error) in
                if let doc = document {
                    if doc.exists {
                        guard let count = doc.data()?[ApiKey.unreadCount] as? Int else { return }
                        db.collection(ApiKey.batchCount).document(receiverId).setData([ApiKey.unreadCount : count - 1])
                    } else {
                        db.collection(ApiKey.batchCount).document(receiverId).setData([ApiKey.unreadCount: 0])
                    }
            }
        }
    }
    
    static func uploadMedia(croppedImage: UIImage,completion: @escaping (_ url: String?) -> Void) {
        _ = Storage.storage().reference().child("images/\(croppedImage).png")
//        let image =  croppedImage.jpeg(.medium)
//        if let uploadData = image {
//            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
//                if error != nil {
//                    print("error")
//                    completion(nil)
//                } else {
//                    storageRef.downloadURL { (url, error) in
//                        completion(url?.absoluteString)
//                    }
//                }
//            }
//        }
    }
    
    static func uploadVideo(_ path: URL,
                            progressEsc: @escaping (Progress)->(),
                            completionEsc: @escaping ()->(),
                            errorEsc: @escaping (Error)->(),
                            completion: @escaping (_ url: String?) -> Void) {
        
        let localFile: URL = path
        let videoName = getName()
        let storageRef = Storage.storage().reference().child("videos/\(videoName).png")
        let metadata = StorageMetadata()
        metadata.contentType = "video"
        
        let uploadTask = storageRef.putFile(from: localFile, metadata: metadata) { metadata, error in
            if error != nil {
                errorEsc(error!)
            } else {
                storageRef.downloadURL { (url, error) in
                    completion(url?.absoluteString)
                    
                }
            }
        }
        
        _ = uploadTask.observe(.progress, handler: { snapshot in
            if let progressSnap = snapshot.progress {
                progressEsc(progressSnap)
            }
        })
        
        _ = uploadTask.observe(.success, handler: { snapshot in
            if snapshot.status == .success {
                uploadTask.removeAllObservers()
                completionEsc()
            }
        })
    }
    
    static func getName() -> String {
        let dateFormatter = DateFormatter()
        let dateFormat = "yyyyMMddHHmmss"
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.string(from: Date())
        let name = date.appending(".mp4")
        return name
    }
    
    //MARK:-CreateBlockNode
    static func createBlockNode(senderId:String,receiverId:String,success:@escaping()->()){
        db.collection(ApiKey.block).document(senderId).setData([receiverId :FieldValue.serverTimestamp()])
        success()
        
        
    }
    //MARK:-CheckIsBlock
    static func checkIsBlock(receiverId:String,_ completion :  @escaping(Bool)->()){
        db.collection(ApiKey.block).document(receiverId).getDocument { (documentSnapshot, error) in
            if  error != nil{
                
            }else{
                documentSnapshot?.data()?.forEach({ (blocedUser,blockedTime) in
                    if blocedUser == AppUserDefaults.value(forKey: .uid).stringValue{
                        completion(true)
                    }
                })
            }
        }
        
    }
    
    static func isReceiverBlocked(senderId:String,receiverId:String,_ completion :  @escaping(Bool)->()){
        db.collection(ApiKey.block).document(senderId).getDocument { (documentSnapshot, error) in
            if  error != nil{
                print(error?.localizedDescription ?? "Some error")
            } else{
                documentSnapshot?.data()?.forEach({ (userId,blockedTime) in
                    if userId == receiverId{
                        completion(true)
                    }
                })
            }
        }
    }
    
    //MARK:-UpdateLastMessagePath
    //===========================
    static func updateLastMessagePathInInbox(senderId:String,receiverId:String,roomId:String,success: @escaping ()-> ()){
        
        db.collection(ApiKey.inbox)
            .document(receiverId)
            .collection(ApiKey.chat)
            .document(senderId)
            .setData([ApiKey.roomId:roomId,
                      ApiKey.roomInfo: db.collection(ApiKey.roomInfo).document(roomId),
                      ApiKey.timeStamp: FieldValue.serverTimestamp(),
                      ApiKey.lastMessage: db.collection(ApiKey.lastMessage).document(roomId).collection(ApiKey.chat).document(senderId),
                      ApiKey.userDetails: db.collection(ApiKey.users).document(senderId)])
            { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Success")
                }
        }
    }
    
    //MARK:-CreateMessageNode
    //=======================
    static func createMessageNode(roomId:String,messageText:String,messageTime:FieldValue,messageId:String,messageType:String,messageStatus:Int,senderId:String,receiverId:String,mediaUrl:String,blocked: Bool, thumbNailURL: String,messageDuration: Int,price: Double){
        
        db.collection(ApiKey.messages).document(roomId).collection(ApiKey.chat).document(messageId).setData([ApiKey.messageText:messageText,
                                                                                                             ApiKey.messageId:messageId,
                                                                                                             ApiKey.messageTime:FieldValue.serverTimestamp(),
                                                                                                             ApiKey.messageStatus:messageStatus,
                                                                                                             ApiKey.messageType:messageType,
                                                                                                             ApiKey.senderId:senderId,
                                                                                                             ApiKey.receiverId:receiverId,
                                                                                                             ApiKey.roomId:roomId,
                                                                                                             ApiKey.mediaUrl : mediaUrl,
                                                                                                             ApiKey.blocked :blocked,
                                                                                                             ApiKey.price: price,
                                                                                                             ApiKey.messageDuration: messageDuration])
        /// States of the messages
        /// 0 - pending, 1 - sent, 2 - delivered, 3 - read
        
    }
    
    static func showAlert( title : String = "", msg : String,_ completion : (()->())? = nil) {
        
        let alertViewController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title:"ok", style: UIAlertAction.Style.default) { (action : UIAlertAction) -> Void in
            alertViewController.dismiss(animated: true, completion: nil)
            completion?()
        }
        alertViewController.addAction(okAction)
        AppDelegate.shared.window?.rootViewController?.present(alertViewController, animated: true, completion: nil)
    }
}
