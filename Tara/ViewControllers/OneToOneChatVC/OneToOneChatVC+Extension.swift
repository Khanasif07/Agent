//
//  OneToOneChatVC+Extension.swift
//  Tara
//
//  Created by Admin on 25/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
extension OneToOneChatVC {
    
    public func  postMessageToFirestoreForPush(body: String = "",image:String = ""){
        db.collection(ApiKey.users)
            .document(inboxModel.userId).getDocument { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else{
                    print("============================")
                    guard let data = snapshot?.data() else { return }
                    let deviceToken = data[ApiKey.deviceToken] as? String ?? ""
                    let deviceType = data[ApiKey.deviceType] as? String ?? ""
                    self.chatViewModel.postMessageToFirestoreForPush(params: self.getDictForPushNotification(deviceType: deviceType, deviceToken: deviceToken, body: body,image: image))
                    printDebug(data)
                }
        }
    }
    
    private func getDictForPushNotification(deviceType: String = "IOS",deviceToken: String,body: String,image: String) -> [String:Any]{
        var dict =  JSONDictionary()
        dict["badge"] = 1
        dict["priority"] = "High"
        dict["forceShow"] = true
        dict["mutableContent"] = true
        dict["to"] = deviceToken
        dict[deviceType == "iOS" ? "notification" : "data"] = [
            "roomId":self.roomId,"senderId": self.currentUserId,"image": image,"badge":1,"title": UserModel.main.name,"body": body,ApiKey.requestId: self.requestId,ApiKey.bidRequestId: self.bidRequestId,ApiKey.userRole: chatUserType == .garage ? 1 : 2,ApiKey.type: "CHAT",ApiKey.userImage: UserModel.main.image]
        return dict
    }
    
    public func getOtherUserData(){
        db.collection(ApiKey.users)
            .document(inboxModel.userId).getDocument { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else{
                    print("============================")
                    guard let data = snapshot?.data() else { return }
                    let userImage = data[ApiKey.userImage] as? String ?? ""
                    if self.userImage.isEmpty{
                        self.userImage = userImage
                    }
                }
        }
    }
}
