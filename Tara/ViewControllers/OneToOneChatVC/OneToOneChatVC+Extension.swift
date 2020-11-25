//
//  OneToOneChatVC+Extension.swift
//  Tara
//
//  Created by Admin on 25/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
extension OneToOneChatVC {
    
    public func  postMessageToFirestoreForPush(){
        db.collection(ApiKey.users)
            .document(inboxModel.userId).getDocument { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else{
                    print("============================")
                    guard let data = snapshot?.data() else { return }
                    let deviceToken = data[ApiKey.deviceToken] as? String ?? ""
                    let deviceType = data[ApiKey.deviceType] as? String ?? ""
                    printDebug(data)
                }
                self.chatViewModel.postMessageToFirestoreForPush(params: [:])
        }
        }
    
    private func getDictForPushNotification(deviceType: String = "IOS"){
        var dict =  JSONDictionary()
        dict["badge"] = 1
        dict["priority"] = 1
        dict["forceShow"] = 1
        dict["mutableContent"] = 1
        dict["to"] = 1
        dict[deviceType == "IOS" ? "notification" : "data"] = [
            "roomId":self.roomId,"senderId": self.currentUserId,"image": UserModel.main.image,"badge":1,"title": UserModel.main.name,"body": self.messageTextView.text.byRemovingLeadingTrailingWhiteSpaces,ApiKey.requestId: self.requestId,ApiKey.bidRequestId: self.bidRequestId,ApiKey.userRole:"",ApiKey.type: "CHAT"]
        }
        
}
