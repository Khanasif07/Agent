//
//  UserChatVC.swift
//  ArabianTyres
//
//  Created by Admin on 27/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import UIKit
import Firebase
import DZNEmptyDataSet
import FirebaseFirestore

class UserChatVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var searchTextField: ATCTextField!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var referenceToDB: Firestore?
    var inboxListing : [Inbox] = []
    var buttonView = UIButton()
    var currentUserId = AppUserDefaults.value(forKey: .uid).stringValue
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    
    
}

// MARK: - Extension For Functions
//===========================
extension UserChatVC {
    
    private func initialSetup() {
        self.tableViewSetUp()
        self.textFieldSetUp()
        self.getInboxListing()
    }
    
    private func tableViewSetUp(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.emptyDataSetSource = self
        self.mainTableView.emptyDataSetDelegate = self
        self.mainTableView.registerCell(with: InboxTableViewCell.self)
    }
    
    private func textFieldSetUp(){
        buttonView.isHidden = true
        buttonView.addTarget(self, action: #selector(clear(_:)), for: .touchUpInside)
        buttonView.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        searchTextField.setButtonToRightView(btn: buttonView, selectedImage: #imageLiteral(resourceName: "icon"), normalImage: #imageLiteral(resourceName: "icon"), size: CGSize(width: 20, height: 20))
    }
    
    @objc private func clear(_ sender: UIButton) {
        searchTextField.text = ""
        //        viewModel.searchText = searchTextField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        //        self.searchText = searchTextField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        //        isSearchOn = !viewModel.searchText.isEmpty
        //        buttonView.isHidden = viewModel.searchText.isEmpty
        //        tableView.reloadData()
    }
    
    private func getNoOfRowsInSection() -> Int {
        return inboxListing.endIndex
    }
    
    private func cellSelected(tableView: UITableView, indexPath: IndexPath) {
        if inboxListing[indexPath.row].chatType == ApiKey.single {
            updateBatch(userId: self.inboxListing[indexPath.row].userId, unreadMessages: self.inboxListing[indexPath.row].unreadMessages)
            AppRouter.goToOneToOneChatVC(self, userId: inboxListing[indexPath.row].userId, name: inboxListing[indexPath.row].firstName, image: inboxListing[indexPath.row].receiverImgURL, unreadMsgs: inboxListing[indexPath.row].unreadMessages)
        } else {
            //                AppRouter.goToGroupChatVC(self, model: inboxListing[indexPath.row])
        }
    }
    
    ///Mark:- Update the batch of the messages
    private func updateBatch(userId: String, unreadMessages: Int) {
        let diff = FirestoreController.ownUnreadCount - unreadMessages
        let db = Firestore.firestore()
        
        db.collection(ApiKey.batchCount)
            .document(AppUserDefaults.value(forKey: .uid).stringValue)
            .setData([ApiKey.unreadMessages : diff])
        
        db.collection(ApiKey.inbox)
            .document(AppUserDefaults.value(forKey: .uid).stringValue)
            .collection(ApiKey.chat)
            .document(userId)
            .updateData([ApiKey.unreadMessages: 0])
    }
    
    private func populateCells(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let model = inboxListing[indexPath.row]
        let messageCell = mainTableView.dequeueCell(with: InboxTableViewCell.self)
        if model.chatType == ApiKey.single {
            messageCell.userNameLbl.text = model.firstName
            messageCell.lastMsgLbl.text = model.lastMessage
            messageCell.userImgView.setImage_kf(imageString: model.receiverImgURL, placeHolderImage: #imageLiteral(resourceName: "placeHolder"), loader: true)
        } else {
            messageCell.userNameLbl.text = model.roomName
            messageCell.lastMsgLbl.text = model.lastMessage
            messageCell.userImgView.setImage_kf(imageString: model.receiverImgURL, placeHolderImage: #imageLiteral(resourceName: "placeHolder"), loader: true)
        }
        //            messageCell.onlineStatusView.isHidden = !model.isOnline
        //            messageCell.senderTextLabel.text = model.lastMessage
        //            messageCell.timeLabel.text = model.timeStamp.dateValue().convertToTimeString()
        //            messageCell.unreadMessageLabel.text = "\(model.unreadMessages)"
        //            messageCell.unreadMessageLabel.isHidden = model.unreadMessages == 0
        //            setupLongPressGesture(view: messageCell.contentView, indexPath: indexPath)
        return messageCell
    }
    
}

// MARK: - Extension For TableView
//===========================
extension UserChatVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNoOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        printDebug("Do Nothing")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return populateCells(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelected(tableView: tableView, indexPath: indexPath)
    }
}


//MARK: DZNEmptyDataSetSource and DZNEmptyDataSetDelegate
//================================
extension UserChatVC : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return  #imageLiteral(resourceName: "layerX00201")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var emptyData = ""
        emptyData =   "No data found"
        return NSAttributedString(string: emptyData , attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontTertiaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(18)])
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldBeForced(toDisplay scrollView: UIScrollView!) -> Bool {
        return false
    }
}

//MARK: Extension
//================================
extension UserChatVC {
    private func deleteFullChat(userId : String) {
        let currentUserId = AppUserDefaults.value(forKey: .uid).stringValue
        let db = Firestore.firestore()
        var roomId = ""
        if currentUserId < userId {
            roomId = currentUserId + "_" + userId
        } else {
            roomId  = userId + "_" + currentUserId
        }
        let documentRef = db.collection(ApiKey.roomInfo).document(roomId)
        
        documentRef.getDocument { (document, error) in
            if let document = document {
                var userInfo = document.data()?[ApiKey.userInfo] as? [String: Any] ?? [:]
                let userTypingStatus = document.data()?[ApiKey.userTypingStatus] as? [String: Any] ?? [:]
                
                // to update delete time of current user when deleting chat
                guard var userDetail = userInfo[AppUserDefaults.value(forKey: .uid).stringValue] as? [String: Any] else { return }
                
                userDetail[ApiKey.deleteTime] = FieldValue.serverTimestamp()
                userInfo[AppUserDefaults.value(forKey: .uid).stringValue] = userDetail
                documentRef.updateData([ ApiKey.userInfo: userInfo,
                                         ApiKey.userTypingStatus : userTypingStatus], completion: { (error) in
                                            if error == nil {
                                                self.referenceToDB?.collection(ApiKey.inbox).document(AppUserDefaults.value(forKey: .uid).stringValue).collection(ApiKey.chat).document(roomId).updateData([ApiKey.lastMessage : "", ApiKey.timeStamp: FieldValue.serverTimestamp()])
                                                db.collection(ApiKey.inbox).document(currentUserId).collection(ApiKey.chat).document(userId).updateData([ApiKey.unreadMessages: 0]) { (error) in
                                                    if let err = error {
                                                        printDebug("Error removing document: \(err)")
                                                    }
                                                    else {
                                                        db.collection(ApiKey.inbox).document(currentUserId).collection(ApiKey.chat).document(userId).delete { [weak self] (error) in
                                                            guard let `self` = self else { return }
                                                            if let err = error {
                                                                self.showAlert(msg: err.localizedDescription)
                                                                printDebug("Error removing document: \(err)")
                                                            } else {
                                                                printDebug("Document successfully removed!")
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                })
                
            }
        }
        
    }
    
    ///Mark:- Fetch the inbox listing
    private func getInboxListing() {
        let db = Firestore.firestore()
        let uid = AppUserDefaults.value(forKey: .uid).stringValue
        db.collection(ApiKey.inbox)
            .document(uid)
            .collection(ApiKey.chat)
            .order(by: ApiKey.timeStamp, descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                guard let querySnap = querySnapshot else { return }
                querySnap.documentChanges.forEach({ (newUser) in
                    var inbox = Inbox(newUser.document.data())
                    if newUser.type == .added {
                        if inbox.chatType == ApiKey.single {
                            self.inboxListing.removeAll(where: { $0.roomId == inbox.roomId })
                            self.inboxListing.append(inbox)
                            inbox.userDetails?.addSnapshotListener({ (document, error) in
                                if let document = document {
                                    if var currentInbox = self.inboxListing.first(where: { $0.roomId == inbox.roomId }) {
                                        currentInbox.firstName = document.data()?[ApiKey.firstName] as? String ?? ""
                                        currentInbox.userId = document.data()?[ApiKey.userId] as? String ?? ""
                                        currentInbox.receiverImgURL = document.data()?[ApiKey.image] as? String ?? ""
                                        currentInbox.isOnline = document.data()?[ApiKey.onlineStatus] as? Bool ?? false
                                        currentInbox.lastMessageRef?.getDocument(completion: { (document, error) in
                                            if let document = document {
                                                currentInbox.lastMessage = document.data()?[ApiKey.messageText] as? String ?? ""
                                                currentInbox.timeStamp = document.data()?[ApiKey.messageTime] as? Timestamp ?? Timestamp()
                                                self.inboxListing.removeAll(where: { $0.roomId == currentInbox.roomId })
                                                self.inboxListing.append(currentInbox)
                                                self.inboxListing.sort { (ib1, ib2) -> Bool in
                                                    ib1.timeStamp.dateValue() > ib2.timeStamp.dateValue()
                                                }
                                                self.mainTableView.reloadData()
                                            }
                                        })
                                    }
                                } else {
                                    FirestoreController.showAlert(msg: "StringConstants.documentFetchingError")
                                }
                            })
                        } else {
                            printDebug(inbox)
                            inbox.roomInfo?.getDocument(completion: { (document, error) in
                                if let doc = document {
                                    inbox.groupImage = doc.data()?[ApiKey.roomImage] as? String ?? ""
                                    inbox.roomName = doc.data()?[ApiKey.roomName] as? String ?? ""
                                    guard let userIds = doc.data()?[ApiKey.userInfo] as? [String: Any] else { return }
                                    let userDetail = userIds[self.currentUserId] as? [String: Any]
                                    if userDetail?[ApiKey.leaveTime] as? Timestamp != nil {
                                        inbox.lastMessage = "\(AppUserDefaults.value(forKey: .name).stringValue) left the group"
                                        self.inboxListing.append(inbox)
                                        self.inboxListing.sort { (ib1, ib2) -> Bool in
                                            ib1.timeStamp.dateValue() > ib2.timeStamp.dateValue()
                                        }
                                        CommonFunctions.hideActivityLoader()
                                        self.mainTableView.reloadData()
                                    } else {
                                        inbox.lastMessageRef?.getDocument(completion: { (document, error) in
                                            if let document = document {
                                                inbox.lastMessage = document.data()?[ApiKey.messageText] as? String ?? ""
                                                self.inboxListing.append(inbox)
                                                self.inboxListing.sort { (ib1, ib2) -> Bool in
                                                    ib1.timeStamp.dateValue() > ib2.timeStamp.dateValue()
                                                }
                                                CommonFunctions.hideActivityLoader()
                                                self.mainTableView.reloadData()
                                            }
                                        })
                                    }
                                    
                                }
                            })
                        }
                    } else if newUser.type == .modified {
                        
                        for index in 0..<self.inboxListing.count {
                            if self.inboxListing[index].roomId == inbox.roomId {
                                if self.inboxListing[index].chatType == ApiKey.single {
                                    self.inboxListing[index].timeStamp = inbox.timeStamp
                                    self.inboxListing[index].unreadMessages = inbox.unreadMessages
                                    guard let lastMessage = inbox.lastMessageRef else { continue }
                                    lastMessage.getDocument(completion: { (document, error) in
                                        if error != nil{
                                            print(error!)
                                        } else {
                                            if let document = document {
                                                inbox.lastMessage = document.data()?[ApiKey.messageText] as? String ?? ""
                                                self.inboxListing[index].lastMessage = inbox.lastMessage
                                                DispatchQueue.main.async {
                                                    self.inboxListing.sort { (ib1, ib2) -> Bool in
                                                        ib1.timeStamp.dateValue() > ib2.timeStamp.dateValue()
                                                    }
                                                    self.mainTableView.reloadData()
                                                }
                                            }
                                        }
                                    })
                                } else {
                                    self.inboxListing[index].timeStamp = inbox.timeStamp
                                    self.inboxListing[index].unreadMessages = inbox.unreadMessages
                                    guard let lastMessage = inbox.lastMessageRef else {
                                        inbox.lastMessage = ""
                                        self.inboxListing[index].lastMessage = inbox.lastMessage
                                        DispatchQueue.main.async {
                                            self.inboxListing.sort { (ib1, ib2) -> Bool in
                                                ib1.timeStamp.dateValue() > ib2.timeStamp.dateValue()
                                            }
                                            self.mainTableView.reloadData()
                                        }
                                        continue
                                    }
                                    inbox.roomInfo?.getDocument(completion: { (document, error) in
                                        if let doc = document {
                                            self.inboxListing[index].roomName = doc.data()?[ApiKey.roomName] as? String ?? ""
                                            self.inboxListing[index].groupImage = doc.data()?[ApiKey.roomImage] as? String ?? ""
                                            guard let userIds = doc.data()?[ApiKey.userInfo] as? [String: Any] else { return }
                                            let userDetail = userIds[self.currentUserId] as? [String: Any]
                                            if userDetail?[ApiKey.leaveTime] as? Timestamp != nil {
                                                self.inboxListing[index].lastMessage = "\(AppUserDefaults.value(forKey: .name).stringValue) left the group"
                                                self.mainTableView.reloadData()
                                            } else {
                                                lastMessage.getDocument(completion: { (document, error) in
                                                    if error != nil{
                                                        print(error!)
                                                    } else {
                                                        if let document = document {
                                                            inbox.lastMessage = document.data()?[ApiKey.messageText] as? String ?? ""
                                                            self.inboxListing[index].lastMessage = inbox.lastMessage
                                                            DispatchQueue.main.async {
                                                                self.inboxListing.sort { (ib1, ib2) -> Bool in
                                                                    ib1.timeStamp.dateValue() > ib2.timeStamp.dateValue()
                                                                }
                                                                self.mainTableView.reloadData()
                                                            }
                                                        }
                                                    }
                                                })
                                            }
                                            
                                        }
                                    })
                                }
                            }
                        }
                    }
                    else if newUser.type == .removed{
                        let index = self.inboxListing.firstIndex { $0.roomId == inbox.roomId }
                        if let indexVal = index {
                            self.inboxListing.remove(at: indexVal)
                            DispatchQueue.main.async {
                                self.inboxListing.sort { (ib1, ib2) -> Bool in
                                    ib1.timeStamp.dateValue() > ib2.timeStamp.dateValue()
                                }
                                self.mainTableView.reloadData()
                            }
                        }
                    } else {
                        
                    }
                })
        }
    }
}
