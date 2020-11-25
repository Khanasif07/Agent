//
//  OneToOneChatVC+Extension.swift
//  Tara
//
//  Created by Admin on 25/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
extension OneToOneChatVC {
    
    public func  postMessageToFirestoreForPush(body: String){
        db.collection(ApiKey.users)
            .document(inboxModel.userId).getDocument { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else{
                    print("============================")
                    guard let data = snapshot?.data() else { return }
                    let deviceToken = data[ApiKey.deviceToken] as? String ?? ""
                    let deviceType = data[ApiKey.deviceType] as? String ?? ""
                    self.chatViewModel.postMessageToFirestoreForPush(params: self.getDictForPushNotification(deviceType: deviceType, deviceToken: deviceToken, body: body))
                    printDebug(data)
                }
        }
    }
    
    private func getDictForPushNotification(deviceType: String = "IOS",deviceToken: String,body: String) -> [String:Any]{
        var dict =  JSONDictionary()
        dict["badge"] = 1
        dict["priority"] = "High"
        dict["forceShow"] = true
        dict["mutableContent"] = true
        dict["to"] = deviceToken
        dict[deviceType == "IOS" ? "notification" : "data"] = [
            "roomId":self.roomId,"senderId": self.currentUserId,"image": UserModel.main.image,"badge":1,"title": UserModel.main.name,"body": body,ApiKey.requestId: self.requestId,ApiKey.bidRequestId: self.bidRequestId,ApiKey.userRole: chatUserType == .garage ? 1 : 2,ApiKey.type: "CHAT"]
        return dict
    }
   
    
}
