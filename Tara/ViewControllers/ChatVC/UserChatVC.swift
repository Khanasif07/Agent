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
    @IBOutlet weak var topViewHConst: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var searchTextField: ATCTextField!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var referenceToDB: Firestore?
    var inboxListing : [Inbox] = []
    var buttonView = UIButton()
    var searchText : String  = ""
    var isSearchOn: Bool  =  false
    var currentUserId = AppUserDefaults.value(forKey: .uid).stringValue
    var searchInboxListing : [Inbox] {
        if searchText.isEmpty{
            return inboxListing
        }
        return inboxListing.filter({$0.firstName.lowercased().contains(s: searchText.lowercased())})
    }
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
    }
    // MARK: - IBActions
    //===========================
    
    @IBAction func txtFieldChanged(_ sender: UITextField) {
        self.searchText = (sender.text?.byRemovingLeadingTrailingWhiteSpaces ?? "")
        self.isSearchOn = !self.searchText.isEmpty
        self.buttonView.isSelected =  self.isSearchOn
        mainTableView.reloadData()
    }
       
}

// MARK: - Extension For Functions
//===========================
extension UserChatVC {
    
    private func initialSetup() {
        self.tableViewSetUp()
        self.textFieldSetUp()
        self.topViewHConst.constant = isUserLoggedin ? 82.0 : 0.0
        self.buttonView.isHidden = !isUserLoggedin
        if isUserLoggedin {
        self.getInboxListing()
        }
    }
    
    private func tableViewSetUp(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.emptyDataSetSource = self
        self.mainTableView.emptyDataSetDelegate = self
        self.mainTableView.registerCell(with: ProfileGuestTableCell.self)
        self.mainTableView.registerCell(with: InboxTableViewCell.self)
    }
    
    private func textFieldSetUp(){
        self.titleLbl.text = LocalizedString.chat.localized
        buttonView.isHidden = false
        buttonView.addTarget(self, action: #selector(clear(_:)), for: .touchUpInside)
        buttonView.imageEdgeInsets = UIEdgeInsets(top: 0, left:  AppUserDefaults.value(forKey: .language) == 1 ? 10 : -10, bottom: 0, right:  AppUserDefaults.value(forKey: .language) == 1 ? -10 : 10)
        searchTextField.setButtonToRightView(btn: buttonView, selectedImage: #imageLiteral(resourceName: "cancel"), normalImage: #imageLiteral(resourceName: "icon"), size: CGSize(width: 20, height: 20))
        searchTextField.placeholder = LocalizedString.search.localized
    }
    
    @objc private func clear(_ sender: UIButton) {
        searchTextField.text = ""
        buttonView.isSelected = false
        self.searchText = searchTextField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        isSearchOn = false
        mainTableView.reloadData()
    }
    
    private func getNoOfRowsInSection() -> Int {
        if isUserLoggedin {
            self.mainTableView.isScrollEnabled = true
            return searchInboxListing.endIndex
        } else {
            self.mainTableView.isScrollEnabled = false
            return 1
        }
    }
    
    private func cellSelected(tableView: UITableView, indexPath: IndexPath) {
        if searchInboxListing[indexPath.row].chatType == ApiKey.single {
            updateBatch(userId: self.searchInboxListing[indexPath.row].userId, unreadMessages: self.searchInboxListing[indexPath.row].unreadCount,requestId: searchInboxListing[indexPath.row].requestId)
            let garageUserId = searchInboxListing[indexPath.row].garageUserId == UserModel.main.id ? searchInboxListing[indexPath.row].garageUserId : searchInboxListing[indexPath.row].userId
            AppRouter.goToOneToOneChatVC(self, userId: searchInboxListing[indexPath.row].userId,requestDetailId: self.searchInboxListing[indexPath.row].bidRequestId, requestId: searchInboxListing[indexPath.row].requestId, name: searchInboxListing[indexPath.row].firstName, image: searchInboxListing[indexPath.row].receiverImgURL, unreadMsgs: searchInboxListing[indexPath.row].unreadCount,garageUserId: garageUserId)
        } else {
        }
    }
    
    ///Mark:- Update the batch of the messages
    private func updateBatch(userId: String, unreadMessages: Int,requestId: String) {
        //roomId:string,timeStamp:Any,
        var inboxxUserId = ""
        if requestId.isEmpty{
            inboxxUserId = userId
        } else {
            inboxxUserId = userId + "_" + requestId
        }
        
        let diff = FirestoreController.ownUnreadCount - unreadMessages
        let db = Firestore.firestore()
        
        db.collection(ApiKey.batchCount)
            .document(AppUserDefaults.value(forKey: .uid).stringValue)
            .setData([ApiKey.unreadCount : diff])

        db.collection(ApiKey.inbox)
            .document(AppUserDefaults.value(forKey: .uid).stringValue)
            .collection(ApiKey.chat)
            .document(inboxxUserId)
            .updateData([ApiKey.unreadCount: 0])
    }
    
    private func populateCells(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if isUserLoggedin {
            let model = searchInboxListing[indexPath.row]
            let messageCell = mainTableView.dequeueCell(with: InboxTableViewCell.self)
            if model.chatType == ApiKey.single {
                messageCell.userNameLbl.text = (model.firstName == LocalizedString.supportChat.localized) ? LocalizedString.supportChat.localized : model.firstName
                messageCell.lastMsgLbl.text = model.lastMessage
                messageCell.userImgView.setImage_kf(imageString: model.receiverImgURL, placeHolderImage: #imageLiteral(resourceName: "placeHolder"), loader: true)
                messageCell.timeLbl.text = model.timeStamp.dateValue().convertToTimeString()
                messageCell.msgCountLbl.text = "\(model.unreadCount)"
                messageCell.msgCountView.isHidden = model.unreadCount == 0
            }
            return messageCell
        } else {
            let cell = tableView.dequeueCell(with: ProfileGuestTableCell.self, indexPath: indexPath)
            cell.loginBtnTapped = { [weak self] (sender) in
                guard let `self` = self else { return }
                AppRouter.goToLoginVC(vc: self)
            }
            cell.createAccountBtnTapped = { [weak self] (sender) in
                guard let `self` = self else { return }
                AppRouter.goToSignUpVC(vc: self)
            }
            return cell
        }
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
        if isUserLoggedin {
        cellSelected(tableView: tableView, indexPath: indexPath)
        }
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
        emptyData = LocalizedString.noDataFound.localized
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
//    private func deleteFullChat(userId : String) {
//        let currentUserId = AppUserDefaults.value(forKey: .uid).stringValue
//        let db = Firestore.firestore()
//        var roomId = ""
//        if currentUserId < userId {
//            roomId = currentUserId + "_" + userId
//        } else {
//            roomId  = userId + "_" + currentUserId
//        }
//        let documentRef = db.collection(ApiKey.roomInfo).document(roomId)
//
//        documentRef.getDocument { (document, error) in
//            if let document = document {
//                var userInfo = document.data()?[ApiKey.userInfo] as? [String: Any] ?? [:]
//                let userTypingStatus = document.data()?[ApiKey.typingStatus] as? [String: Any] ?? [:]
//
//                // to update delete time of current user when deleting chat
//                guard var userDetail = userInfo[AppUserDefaults.value(forKey: .uid).stringValue] as? [String: Any] else { return }
//
//                userDetail[ApiKey.deleteTime] = FieldValue.serverTimestamp()
//                userInfo[AppUserDefaults.value(forKey: .uid).stringValue] = userDetail
//                documentRef.updateData([ ApiKey.userInfo: userInfo,
//                                         ApiKey.typingStatus : userTypingStatus], completion: { (error) in
//                                            if error == nil {
//                                                self.referenceToDB?.collection(ApiKey.inbox).document(AppUserDefaults.value(forKey: .uid).stringValue).collection(ApiKey.chat).document(roomId).updateData([ApiKey.lastMessage : "", ApiKey.timeStamp: FieldValue.serverTimestamp()])
//                                                db.collection(ApiKey.inbox).document(currentUserId).collection(ApiKey.chat).document(userId).updateData([ApiKey.unreadCount: 0]) { (error) in
//                                                    if let err = error {
//                                                        printDebug("Error removing document: \(err)")
//                                                    }
//                                                    else {
//                                                        db.collection(ApiKey.inbox).document(currentUserId).collection(ApiKey.chat).document(userId).delete { [weak self] (error) in
//                                                            guard let `self` = self else { return }
//                                                            if let err = error {
//                                                                self.showAlert(msg: err.localizedDescription)
//                                                                printDebug("Error removing document: \(err)")
//                                                            } else {
//                                                                printDebug("Document successfully removed!")
//                                                            }
//                                                        }
//                                                    }
//                                                }
//                                            }
//                })
//
//            }
//        }
//
//    }
    
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
                                        currentInbox.firstName = (document.data()?[ApiKey.userName] as? String ?? "").isEmpty ? document.data()?[ApiKey.firstName] as? String ?? "" : document.data()?[ApiKey.userName] as? String ?? ""
                                        currentInbox.userId = document.data()?[ApiKey.userId] as? String ?? ""
                                        currentInbox.receiverImgURL = (document.data()?[ApiKey.userImage] as? String ?? "").isEmpty ? document.data()?[ApiKey.image] as? String ?? "" : document.data()?[ApiKey.userImage] as? String ?? ""
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
                                    self.inboxListing[index].unreadCount = inbox.unreadCount
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
                                    self.inboxListing[index].unreadCount = inbox.unreadCount
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
