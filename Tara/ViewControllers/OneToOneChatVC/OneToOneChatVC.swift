//
//  OneToOneChatVC.swift
//  Tara
//
//  Created by Admin on 02/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit
import AVKit
import Photos
import Toaster
import AVFoundation
import FirebaseStorage
import FirebaseFirestore

protocol SetLastMessageDelegate : AnyObject {
    func setLastMessages(lastMsg:String)
}

class OneToOneChatVC: BaseVC {
    
    //MARK: VARIABLES
    //===============
    weak var delegate: SetLastMessageDelegate?
    var chatViewModel = OneToOneChatViewModel()
    private let db = Firestore.firestore()
    var isSupportChat : Bool = false
    var inboxModel = Inbox()
    var firstName = ""
    var requestId = ""
    var garageUserId = ""
    var bidRequestId = ""
    var requestDetailId = ""
    var userImage = ""
    var chatUserType: UserType = .user
    var imageController = UIImagePickerController()
    var alertController = UIAlertController()
    var indexVal = 0
    var tempTime = Timestamp.init(date: Date())
    var recordedUrl : URL?
    lazy var titleTap = UITapGestureRecognizer(target: self, action: #selector(titleLabelTapped(_:)))
    private var deleteTime = Timestamp.init(date: Date())
    private var userInfo = [String:Any]()
    var roomId = ""
    var lastMessageModel : [String:Any] = [:]
    let currentUserId = AppUserDefaults.value(forKey: .uid).stringValue
    var messageListing = [[Message]]()
    var isRoom = false
    
    var messageId :String = ""
    var acceptedRejectBtnStatus: Bool = false
    
    fileprivate var hasImageUploaded = true {
        didSet {
            if hasImageUploaded {
                CommonFunctions.showToastWithMessage("Upload Completed")
            }
        }
    }
    var selectedIndexPaths : [IndexPath] = []
    var selectedIndexPath: IndexPath?
    var listeners = [ListenerRegistration]()
 
    //Audio messages
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var timeObserver: Any?
    
    //for block case
    var isBlockedByMe = false {
        didSet {
            unblockBtn.setTitle(isBlockedByMe ? "Unblock User" : "Block User", for: .normal)
        }
    }
    var amIBlocked = false

    //MARK: OUTLETS
    //=============
    @IBOutlet var typingStatusFooterView: UIView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var unblockBtn: UIButton!
    @IBOutlet weak var editBidBtn: UIButton!
    @IBOutlet weak var btnContaninerView: UIView!

    @IBOutlet weak var progressVIew: UIProgressView!
    @IBOutlet weak var audioCancelBtn: UIButton!
    @IBOutlet weak var audioRecordBtn: UIButton!
    @IBOutlet weak var audioBtn: UIButton!
    @IBOutlet weak var addDocumentBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textContainerInnerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var timerView: UIView!
    
    //MARK:- TopView Outlets for User Detail(Garage End)
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var previousServiceLbl: UILabel!
    @IBOutlet weak var numberOfServiceLbl: UILabel!
    @IBOutlet weak var payableAmtLbl: UILabel!
    @IBOutlet weak var amountValueLbl: UILabel!
    @IBOutlet weak var userRequestView: UIView!
    @IBOutlet weak var userImgView: UIImageView!
    
    //MARK:- TopView Outlets for Garage Detail(User End)
    @IBOutlet weak var garageNameLbl: UILabel!
    @IBOutlet weak var garageAddressLbl: UILabel!
    @IBOutlet weak var garageRatingLbl: UILabel!
    @IBOutlet weak var garageAmountValueLbl: UILabel!
    @IBOutlet weak var garagePayableAmountLbl: UILabel!
    @IBOutlet weak var garageRequestNoLbl: UILabel!
    @IBOutlet weak var garageRequestNoValueLbl: UILabel!
    @IBOutlet weak var garageImgView: UIImageView!
    @IBOutlet weak var garageTopView: UIView!
    

    //MARK: VIEW LIFE CYCLE
    //=====================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addDocumentBtn.round()
        audioBtn.round()
        sendButton.round()
        audioCancelBtn.round()
        audioRecordBtn.round()
        garageImgView.round()
        userImgView.round()
        btnContaninerView.addShadow(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        textContainerInnerView.round(radius: 4.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: ACTIONS
    //=============
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        _ = touch.location(in: self.view)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func addAttachmentsButtonTapped(_ sender: UIButton) {
        createMediaAlertSheet()
    }
    
    @IBAction func addAudioMsgBtnTapped(_ sender: UIButton) {
        timerView.isHidden = false
        audioRecordBtn.setImage(#imageLiteral(resourceName: "audioBtnWhite"), for: .normal)
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        typingDisable()
        sendMessage(msgType: MessageType.text.rawValue)
    }
    
    @IBAction func sendAudioToFirestire(_ sender: UIButton) {
        typingDisable()
        if sender.imageView?.image !=  #imageLiteral(resourceName: "audioBtnWhite")  {
            self.uploadAudioFileToFirestore(self.recordedUrl!)
            self.audioRecordCancelBtnAction(audioCancelBtn)
        } }
    
    @IBAction func audioRecordCancelBtnAction(_ sender: UIButton) {
        timerView.isHidden = true
        timerLbl.text = "0:00"
        self.progressVIew.progress = 0.0
        self.recordedUrl = nil
        audioRecordBtn.setImage(#imageLiteral(resourceName: "audioMsg"), for: .normal)
    }
    
    @IBAction func editBtnAction(_ sender: UIButton) {
        btnContaninerView.isHidden.toggle()
    }
    
    @IBAction func editBidBtnAction(_ sender: UIButton) {
        btnContaninerView.isHidden = true
        AppRouter.goToChatEditBidVC(vc: self,requestId: requestDetailId)
    }
    
    @IBAction func blockBtnAction(_ sender: UIButton) {
        btnContaninerView.isHidden = true
        if unblockBtn.titleLabel?.text == "Block User"{
         db.collection(ApiKey.block)
            .document(currentUserId)
            .collection(ApiKey.chat)
            .document(inboxModel.userId)
            .setData([ApiKey.userId: inboxModel.userId,
                      ApiKey.userName: firstName,
            ])
        }else {
            db.collection(ApiKey.block)
                .document(currentUserId)
                .collection(ApiKey.chat)
                .document(inboxModel.userId)
                .delete()
        }
    }
}

//MARK: PRIVATE FUNCTIONS
//=======================
extension OneToOneChatVC {
    
    private func initialSetup() {
        //        backgroundView.isHidden = false
        //        CommonFunctions.showActivityLoader()
        NotificationCenter.default.addObserver(self, selector: #selector(editedBidAccepted), name: Notification.Name.EditedBidAccepted, object: nil)
        btnContaninerView.isHidden = true
        self.isSupportChat = self.requestId.isEmpty
        userRequestView.isHidden = true
        garageTopView.isHidden = true
        chatViewModel.delegate = self
        textContainerInnerView.borderColor = AppColors.fontTertiaryColor.withAlphaComponent(0.5)
        textContainerInnerView.borderWidth = 1.0
        checkRoomAvailability()
        containerScrollView.delegate = self
        bottomContainerView.isUserInteractionEnabled = true
        addTapGestureToAudioBtn()
        startSenderBlockListener()
        startReceiverBlockListener()
        setupTableView()
        setupTextView()
        fetchDeleteTime()
        getBatchCount()
        setupAudioMessages()
        getChatData()
        setUpChatUserType()
        editBtn.isHidden = isSupportChat
        self.sendButton.backgroundColor = AppColors.fontTertiaryColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped(_:)))
        containerScrollView.addGestureRecognizer(tap)
        let topViewTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped(_:)))
        topView.addGestureRecognizer(topViewTap)
    }
    
    private func footerViewSetUp(isFooter: Bool = true){
        self.messagesTableView.tableFooterView = isFooter ? typingStatusFooterView : nil
        self.messagesTableView.tableFooterView?.height =  isFooter ? 50.0 : 0.0
    }
    
    private func setUpChatUserType(){
        if UserModel.main.id == self.garageUserId{
            self.chatUserType = .garage
        } else {
            self.chatUserType = .user
        }
        editBidBtn.isHidden = !(self.chatUserType == .garage)
    }
    
    private func addTapGestureToAudioBtn() {
        let longGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(longTap))
        audioRecordBtn.addGestureRecognizer(longGesture)
        audioRecordBtn.isUserInteractionEnabled = true
    }
    
    @objc private func titleLabelTapped(_ sender: UITapGestureRecognizer) {
       
    }
    
    @objc func editedBidAccepted(){
        self.getChatData()
    }
    
    @objc private func scrollViewTapped(_ sender: UITapGestureRecognizer) {
        btnContaninerView.isHidden = true
    }
    
    @objc   func longTap(_ sender : UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            audioRecordBtn.setImage(#imageLiteral(resourceName: "group3603"), for: .normal)
            finishRecording(success: true)
            endTimer()
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            if audioRecorder == nil {
                startTimer()
                startRecording()
            } else {
                finishRecording(success: true)
            }
        }
    }
    
    private func getChatData() {
        if !requestId.isEmpty {
            let dict = [ApiKey.requestId : self.requestId]
            chatViewModel.getChatData(params: dict,loader: false)
        }
        else {
            //            backgroundView.isHidden = true
            tableViewTopConstraint.constant = 0.0
        }
    }
    
    private func createMediaAlertSheet() {
        self.captureImage(delegate: self,removedImagePicture: false )
    }
    
    private func setupAudioMessages() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        self.timerView.isHidden = true
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        printDebug("Loaded Succesfull")
                    } else {
                        // failed to record
                    }
                }
            }
        } catch {
            // failed to record
        }
    }
    
    private func setupTableView() {
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
        messagesTableView.registerCell(with: SenderOfferCell.self)
        messagesTableView.registerCell(with: SenderLocationCell.self)
        messagesTableView.registerCell(with: ReceiverLocationCell.self)
        messagesTableView.registerCell(with: SenderMessageCell.self)
        messagesTableView.registerCell(with: ReceiverMessageCell.self)
        messagesTableView.registerCell(with: SenderMediaCell.self)
        messagesTableView.registerCell(with: ReceiverMediaCell.self)
        messagesTableView.registerCell(with: SenderAudioCell.self)
        messagesTableView.registerCell(with: ReceiverAudioCell.self)
        messagesTableView.registerCell(with: ReceiverOfferCell.self)
        messagesTableView.registerCell(with: DayValueCell.self)
    }
    
    private func setupTextView() {
        titleLabel.text = firstName
        messageTextView.delegate = self
        messageTextView.tintColor = AppColors.appRedColor
    }
    
    private func sendMessage(msgType: String = MessageType.text.rawValue ,price: Int = 0) {
        self.view.endEditing(true)
        let txt = self.messageTextView.text.byRemovingLeadingTrailingWhiteSpaces
        if isBlockedByMe {
            CommonFunctions.showToastWithMessage( LocalizedString.PLEASEUNBLOCKUSERTOSENDMESSAGES.localized)
            return
        }
        guard !txt.isEmpty else { return }
        if isRoom {
            self.updateUnreadMessage()
            self.restoreDeletedNode()
            self.createMessage(msgType: msgType,price: price)
            self.updateInboxTimeStamp()
        } else {
            self.createRoom()
            self.createMessage(msgType: msgType,price: price)
            self.createInbox()
        }
        messageTextView.text = ""
        messageLabel.isHidden = false
        sendButton.setImage(#imageLiteral(resourceName: "group3603"), for: .normal)
        sendButton.backgroundColor = AppColors.fontTertiaryColor
        resetFrames()
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        containerScrollView.isScrollEnabled = true
        guard let info = sender.userInfo, let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height, let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        scrollMsgToBottom()
        tableViewTopConstraint.constant = keyboardSize - 20
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        guard let info = sender.userInfo, let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        scrollMsgToBottom()
        if requestId.isEmpty{tableViewTopConstraint.constant = 0.0}
        tableViewTopConstraint.constant =  isCurrentUserType == .garage ? (chatViewModel.chatData.id.isEmpty ? 0.0 : 80.0)  : (chatViewModel.chatData.id.isEmpty ? 0.0 : 124.0)

        
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        if let ob = self.timeObserver {
            self.player?.removeTimeObserver(ob)
        }
        self.removeAVPlayerInstance()
    }
    
    private func removeAVPlayerInstance(){
        self.player = nil
        self.playerItem = nil
        if let senderAudioCell = self.messagesTableView.cellForRow(at: self.selectedIndexPath ?? IndexPath.init(row: 0, section: 0)) as? SenderAudioCell {
            senderAudioCell.customSlider.value = 0.0
            senderAudioCell.loadingView.isHidden = true
            senderAudioCell.playBtn.isHidden = false
            senderAudioCell.playBtn.setImage(#imageLiteral(resourceName: "playButton"), for: .normal)
        }
        if let receiverAudioCell = self.messagesTableView.cellForRow(at: self.selectedIndexPath ?? IndexPath.init(row: 0, section: 0)) as? ReceiverAudioCell {
            receiverAudioCell.customSlider.value = 0.0
            receiverAudioCell.loadingView.isHidden = true
            receiverAudioCell.playBtn.isHidden = false
            receiverAudioCell.playBtn.setImage(#imageLiteral(resourceName: "playButton"), for: .normal)
        }
        self.selectedIndexPath = nil
        self.messagesTableView.reloadData()
    }
}

//MARK:- TEXT VIEW DELEGATES
//==========================
extension OneToOneChatVC: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        self.messageLabel.isHidden = !text.isEmpty
        if text.byRemovingLeadingTrailingWhiteSpaces.isEmpty {
            self.sendButton.setImage(#imageLiteral(resourceName: "group3603"), for: .normal)
            self.sendButton.backgroundColor = AppColors.fontTertiaryColor
            if text.isEmpty {
                self.resetFrames()
                return
            }
        } else {
            self.sendButton.backgroundColor = AppColors.appRedColor
            sendButton.setImage(#imageLiteral(resourceName: "group3603"), for: .normal)
        }
        let height = text.heightOfText(self.messageTextView.bounds.width - 10, font: AppFonts.NunitoSansRegular.withSize(16)) + 10
        if height >= 40 && height < 120 {
            textViewHeightConstraint.constant = height
        }
    }
    
    @objc func typingDisable() {
        if self.isRoom {
            self.setTypingUser(isTyping: false)
        }
    }
    
    //MARK: ---------------Setting Typing Status for Single Chat-------------------
    @objc func setTypingUser(isTyping : Bool) {
        /// Mark:- Typing status info abouthe the user
        let userTypingStatus: [String: Any] = [currentUserId: isTyping,
                                               inboxModel.userId: false]
        db.collection(ApiKey.roomInfo).document(roomId).setData([
            ApiKey.typingStatus:userTypingStatus],merge: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.isRoom {
        self.setTypingUser(isTyping: true)
        }
        messageLabel.isHidden = true
        textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        typingDisable()
        messageLabel.isHidden = !textView.text.byRemovingLeadingTrailingWhiteSpaces.isEmpty
        if messageLabel.isHidden {
            self.sendButton.backgroundColor = AppColors.appRedColor
            sendButton.setImage(#imageLiteral(resourceName: "group3603"), for: .normal)
        } else {
            self.sendButton.backgroundColor = AppColors.fontTertiaryColor
            sendButton.setImage(#imageLiteral(resourceName: "group3603"), for: .normal)
        }
    }
    
    //MARK: Reset frame function
    fileprivate func resetFrames() {
        UIView.animate(withDuration: 0.3) {
            self.textViewHeightConstraint.constant = 40
            self.view.layoutIfNeeded()
        }
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d",minutes, seconds)
    }
    
    private func addPeriodicTimerForAudioPlayer(senderAudioCell: UITableViewCell,receiverAudioCell: UITableViewCell){
        if let audioTableCell = senderAudioCell as? SenderAudioCell{
            self.player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
                if self.player!.currentItem?.status == .readyToPlay {
                    let time : Float64 = CMTimeGetSeconds(self.player!.currentTime())
                    audioTableCell.customSlider.value = Float ( time )
                    audioTableCell.timeLbl.text = self.stringFromTimeInterval(interval: time)
                }
                
                let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
                if playbackLikelyToKeepUp == false{
                    print("IsBuffering")
                    audioTableCell.playBtn.isHidden = true
                    audioTableCell.loadingView.startAnimating()
                    audioTableCell.loadingView.isHidden = false
                } else {
                    //stop the activity indicator
                    print("Buffering completed")
                    audioTableCell.playBtn.isHidden = false
                    audioTableCell.loadingView.stopAnimating()
                    audioTableCell.loadingView.isHidden = true
                }
            }
        }
        if let audioTableCell = receiverAudioCell as? ReceiverAudioCell{
            self.player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
                if self.player!.currentItem?.status == .readyToPlay {
                    let time : Float64 = CMTimeGetSeconds(self.player!.currentTime())
                    audioTableCell.customSlider.value = Float ( time )
                    audioTableCell.timeLbl.text = self.stringFromTimeInterval(interval: time)
                }
                
                let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
                if playbackLikelyToKeepUp == false{
                    print("IsBuffering")
                    audioTableCell.playBtn.isHidden = true
                    audioTableCell.loadingView.startAnimating()
                    audioTableCell.loadingView.isHidden = false
                } else {
                    //stop the activity indicator
                    print("Buffering completed")
                    audioTableCell.playBtn.isHidden = false
                    audioTableCell.loadingView.stopAnimating()
                    audioTableCell.loadingView.isHidden = true
                }
            }
        }
    }
}

//MARK:- TABLEVIEW DELEGATES AND DATASOURCE
//=========================================
extension OneToOneChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageListing[section].endIndex
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messageListing.endIndex
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dayCell = tableView.dequeueCell(with: DayValueCell.self)
        let dateVal =  messageListing[section].first?.messageTime.dateValue() ?? Date()
        if dateVal.isToday {
            dayCell.dateLabel.text = "Today"
        } else if dateVal.isYesterday {
            dayCell.dateLabel.text = "Yesterday"
        } else {
            dayCell.dateLabel.text = dateVal.convertToDefaultString()
        }
        return dayCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = messageListing[indexPath.section][indexPath.row]
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(titleLabelTapped(_:)))
        switch model.receiverId {
        case AppUserDefaults.value(forKey: .uid).stringValue:
            switch model.messageType {
            case MessageType.image.rawValue:
                let senderMediaCell = tableView.dequeueCell(with: SenderMediaCell.self)
                senderMediaCell.configureCellWith(model: model)
                senderMediaCell.layoutSubviews()
                senderMediaCell.layoutIfNeeded()
                senderMediaCell.setNeedsLayout()
                senderMediaCell.senderImageView.setImage_kf(imageString: userImage, placeHolderImage: isSupportChat ? #imageLiteral(resourceName: "splashUpdated") : #imageLiteral(resourceName: "placeHolder"), loader: false)
                senderMediaCell.senderImageView.backgroundColor = AppColors.fontTertiaryColor
                setTapGesture(view: senderMediaCell.msgContainerView, indexPath: indexPath)
                senderMediaCell.senderImageView.addGestureRecognizer(imgTap)
                senderMediaCell.senderNameLabel.text = self.firstName
                return senderMediaCell
            case MessageType.audio.rawValue:
                let receiverAudioCell = tableView.dequeueCell(with: ReceiverAudioCell.self)
                receiverAudioCell.setSlider(model: model)
                setTapGesture(view: receiverAudioCell.dataContainerView, indexPath: indexPath)
                receiverAudioCell.receiverNameLbl.text = self.firstName
                receiverAudioCell.receiverImgView.setImage_kf(imageString: userImage, placeHolderImage: isSupportChat ? #imageLiteral(resourceName: "splashUpdated") : #imageLiteral(resourceName: "placeHolder"), loader: false)
                receiverAudioCell.receiverImgView.backgroundColor = AppColors.fontTertiaryColor
                receiverAudioCell.receiverImgView.addGestureRecognizer(imgTap)
                
                receiverAudioCell.playBtnTapped = { [weak self]  in
                    guard let `self` = self else { return }
                    let url = URL(string: model.mediaUrl)
                    //
                    if self.selectedIndexPath != nil && self.selectedIndexPath != indexPath{
                        self.removeAVPlayerInstance()
                    }
                    //
                    if self.player == nil {
                        self.playerItem = AVPlayerItem(url: url!)
                        self.player = AVPlayer(playerItem: self.playerItem)
                    }
                    if self.player?.rate == 0.0 {
                        self.player!.play()
                        receiverAudioCell.playBtn.isHidden = true
                        receiverAudioCell.loadingView.isHidden = false
                        receiverAudioCell.loadingView.startAnimating()
                        receiverAudioCell.playBtn.setImage(#imageLiteral(resourceName: "pauseButton"), for: UIControl.State.normal)
                    } else {
                        self.player!.pause()
                        receiverAudioCell.playBtn.setImage(#imageLiteral(resourceName: "playButton"), for: UIControl.State.normal)
                    }
                    if  self.selectedIndexPath != indexPath {
                        self.addPeriodicTimerForAudioPlayer(senderAudioCell: UITableViewCell(), receiverAudioCell: receiverAudioCell)
                    }
                    self.selectedIndexPath = indexPath
                }
                
                receiverAudioCell.sliderValueChangedAction = { [weak self] (sender)  in
                    guard let `self` = self else { return }
                    let url = URL(string: model.mediaUrl)
                    //
                    if self.selectedIndexPath != nil && self.selectedIndexPath != indexPath{
                        self.removeAVPlayerInstance()
                    }
                    //
                    if self.player == nil {
                        self.playerItem = AVPlayerItem(url: url!)
                        self.player = AVPlayer(playerItem: self.playerItem)
                    }
                    let seconds : Int64 = Int64(sender.value)
                    let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
                    self.player!.seek(to: targetTime)
                    if self.player!.rate == 0 {
                        self.player?.play()
                        receiverAudioCell.playBtn.setImage(#imageLiteral(resourceName: "pauseButton"), for: UIControl.State.normal)
                    }
                    if  self.selectedIndexPath != indexPath {
                        self.addPeriodicTimerForAudioPlayer(senderAudioCell: UITableViewCell(), receiverAudioCell: receiverAudioCell)
                    }
                    self.selectedIndexPath = indexPath
                }
                return receiverAudioCell
            case MessageType.offer.rawValue:
                let receiverOfferCell = tableView.dequeueCell(with: ReceiverOfferCell.self)
                receiverOfferCell.acceptBtnTapped = {[weak self] in
                    guard let `self` = self else { return }
                    self.messageId = model.messageId
                    self.acceptedRejectBtnStatus = true
                    self.chatViewModel.acceptRejectEditedBid(params: [ApiKey.requestId: self.requestId,ApiKey.status: true], loader: true)
                }
                
                receiverOfferCell.rejectBtnTapped = {[weak self] in
                    guard let `self` = self else { return }
                    self.acceptedRejectBtnStatus = false
                    self.messageId = model.messageId
                    self.chatViewModel.acceptRejectEditedBid(params: [ApiKey.requestId: self.requestId,ApiKey.status: true], loader: false)
                }
                
                if model.messageStatus == 1 {// show both button
                    receiverOfferCell.acceptBtn.isHidden = false
                    receiverOfferCell.rejectBtn.isHidden = false
                    receiverOfferCell.acceptBtn.isUserInteractionEnabled = true
                    receiverOfferCell.acceptBtn.setTitle("Accept", for: .normal)
                    receiverOfferCell.rejectBtn.setTitle("Reject", for: .normal)

                    
                }
                else if model.messageStatus == 2 { //offer accpted
                    receiverOfferCell.acceptBtn.isHidden = false
                    receiverOfferCell.acceptBtn.isUserInteractionEnabled = false
                    receiverOfferCell.acceptBtn.setTitle("Offer Accepted", for: .normal)
                    receiverOfferCell.rejectBtn.isHidden = true
                }
                else if model.messageStatus == 3 { //offer rejected
                    receiverOfferCell.acceptBtn.isHidden = false
                    receiverOfferCell.acceptBtn.isUserInteractionEnabled = false
                    receiverOfferCell.acceptBtn.setTitle("Offer Rejected", for: .normal)
                    receiverOfferCell.rejectBtn.isHidden = true
                }
                
                receiverOfferCell.userNameLbl.text = self.firstName
                receiverOfferCell.userImgView.setImage_kf(imageString: userImage, placeHolderImage: isSupportChat ? #imageLiteral(resourceName: "splashUpdated") : #imageLiteral(resourceName: "placeHolder"), loader: false)
                receiverOfferCell.userImgView.backgroundColor = AppColors.fontTertiaryColor
                receiverOfferCell.priceLbl.text = "\(model.price)" + "SAR"
                receiverOfferCell.userImgView.addGestureRecognizer(imgTap)
                return receiverOfferCell
            default:
                let receiverCell = tableView.dequeueCell(with: ReceiverMessageCell.self)
                receiverCell.configureCellWith(model: model)
                receiverCell.receiverNameLbl.text = self.firstName
                receiverCell.receiverImgView.setImage_kf(imageString: userImage, placeHolderImage: isSupportChat ? #imageLiteral(resourceName: "splashUpdated") : #imageLiteral(resourceName: "placeHolder"), loader: false)
                receiverCell.receiverImgView.backgroundColor = AppColors.fontTertiaryColor
                self.setTapGesture(view: receiverCell.msgContainerView, indexPath: indexPath)
                receiverCell.receiverImgView.addGestureRecognizer(imgTap)
                return receiverCell
            }
        default:
            switch model.messageType {
         
            case MessageType.image.rawValue:
                let receiverMediaCell = tableView.dequeueCell(with: ReceiverMediaCell.self)
                receiverMediaCell.configureCellWith(model: model)
                self.setTapGesture(view: receiverMediaCell.msgContainerView, indexPath: indexPath)
                return receiverMediaCell
                
            case MessageType.audio.rawValue:
                let senderAudioCell = tableView.dequeueCell(with: SenderAudioCell.self)
                senderAudioCell.setSlider(model: model)
                setTapGesture(view: senderAudioCell.dataContainerView, indexPath: indexPath)
                //
                senderAudioCell.playBtnTapped = { [weak self]  in
                    guard let `self` = self else { return }
                    let url = URL(string: model.mediaUrl)
                    //
                    if self.selectedIndexPath != nil && self.selectedIndexPath != indexPath{
                        self.removeAVPlayerInstance()
                    }
                    //
                    if self.player == nil {
                        self.playerItem = AVPlayerItem(url: url!)
                        self.player = AVPlayer(playerItem: self.playerItem)
                    }
                    if self.player?.rate == 0.0 {
                        self.player!.play()
                        senderAudioCell.playBtn.isHidden = true
                        senderAudioCell.loadingView.isHidden = false
                        senderAudioCell.loadingView.startAnimating()
                        senderAudioCell.playBtn.setImage(#imageLiteral(resourceName: "pauseButton"), for: UIControl.State.normal)
                    } else {
                        self.player!.pause()
                        senderAudioCell.playBtn.setImage(#imageLiteral(resourceName: "playButton"), for: UIControl.State.normal)
                    }
                    if  self.selectedIndexPath != indexPath {
                        self.addPeriodicTimerForAudioPlayer(senderAudioCell: senderAudioCell, receiverAudioCell: UITableViewCell())
                    }
                    self.selectedIndexPath = indexPath
                    
                }
                
                senderAudioCell.sliderValueChangedAction = { [weak self] (sender)  in
                    guard let `self` = self else { return }
                    let url = URL(string: model.mediaUrl)
                    //
                    if self.selectedIndexPath != nil && self.selectedIndexPath != indexPath{
                        self.removeAVPlayerInstance()
                    }
                    //
                    if self.player == nil {
                        self.playerItem = AVPlayerItem(url: url!)
                        self.player = AVPlayer(playerItem: self.playerItem)
                    }
                    let seconds : Int64 = Int64(sender.value)
                    let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
                    self.player!.seek(to: targetTime)
                    if self.player!.rate == 0 {
                        self.player?.play()
                        senderAudioCell.playBtn.setImage(#imageLiteral(resourceName: "pauseButton"), for: UIControl.State.normal)
                    }
                    if  self.selectedIndexPath != indexPath {
                        self.addPeriodicTimerForAudioPlayer(senderAudioCell: senderAudioCell, receiverAudioCell: UITableViewCell())
                    }
                    self.selectedIndexPath = indexPath
                }
                return senderAudioCell
                
            case MessageType.offer.rawValue:
                let senderOfferCell = tableView.dequeueCell(with: SenderOfferCell.self)
            
                if model.messageStatus == 1 {// hide both button
                    senderOfferCell.btnStackView.isHidden = true
                }
                else if model.messageStatus == 2 { //offer accpted
                    senderOfferCell.btnStackView.isHidden = false
                    senderOfferCell.acceptBtn.isHidden = false
                    senderOfferCell.acceptBtn.isUserInteractionEnabled = false
                    senderOfferCell.acceptBtn.setTitle("Offer Accepted", for: .normal)
                    senderOfferCell.rejectBtn.isHidden = true
                }
                else if model.messageStatus == 3 { //offer rejected
                    senderOfferCell.btnStackView.isHidden = false
                    senderOfferCell.acceptBtn.isHidden = false
                    senderOfferCell.acceptBtn.isUserInteractionEnabled = false
                    senderOfferCell.acceptBtn.setTitle("Offer Rejected", for: .normal)
                    senderOfferCell.rejectBtn.isHidden = true
                }
                senderOfferCell.userNameLbl.text = self.firstName
                senderOfferCell.userImgView.setImage_kf(imageString: UserModel.main.image, placeHolderImage: #imageLiteral(resourceName: "placeHolder"), loader: false)
                senderOfferCell.priceLbl.text = "\(model.price)" + "SAR"
                self.setTapGesture(view: senderOfferCell.msgContainerView, indexPath: indexPath)
                senderOfferCell.userImgView.addGestureRecognizer(imgTap)
                return senderOfferCell
            default:
                let senderCell = tableView.dequeueCell(with: SenderMessageCell.self)
                senderCell.configureCellWith(model: model)
                self.setTapGesture(view: senderCell.dataContainerView, indexPath: indexPath)
                return senderCell
            }
        }
    }
    
    private func reloadTableViewToBottom() {
        messagesTableView.reloadData()
        self.view.layoutIfNeeded()
        scrollMsgToBottom()
    }
    
    private func scrollMsgToBottom(animated: Bool = false) {
        guard messageListing.endIndex > 0, messageListing[messageListing.endIndex - 1].endIndex > 0 else { return }
            self.messagesTableView.scrollToRow(at: IndexPath(row: self.messageListing[self.messageListing.endIndex - 1].endIndex - 1, section: self.messageListing.endIndex - 1), at: .bottom, animated: animated)
    }
}

//MARK: IMAGE PICKER DELEGATES
//============================
extension OneToOneChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate , RemovePictureDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        hasImageUploaded = false
        CommonFunctions.showActivityLoader()
        image?.upload(progress: { [weak self] (status) in
            guard let `self` = self else { return }
            printDebug(status)
            if !self.hasImageUploaded { CommonFunctions.showToastWithMessage("\(Int(status * 100))% Uploaded") }
            }, completion: { (response,error) in
                if let url = response {
                    CommonFunctions.hideActivityLoader()
                    self.hasImageUploaded = true
                    if self.isRoom {
                        self.updateUnreadMessage()
                        self.restoreDeletedNode()
                        self.createMediaMessage(url: url, imageURL: url, type: "image")
                        self.updateInboxTimeStamp()
                    } else {
                        self.createRoom()
                        self.createMediaMessage(url: url, imageURL: url, type: "image")
                        self.createInbox()
                    }
                }
                if let _ = error{
                    self.showAlert(msg: LocalizedString.imageUploadingFailed.localized)
                }
        })
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func removepicture() {
    }
    
    func setTapGesture(view: UIView, indexPath: IndexPath) {
        let pressGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        view.addGestureRecognizer(pressGesture)
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(self.tapLongGesture))
        view.addGestureRecognizer(longPressGesture)
    }
    
    func openImageViewer(indexPath: IndexPath) {
        let message = self.messageListing[indexPath.section][indexPath.row]
        guard message.messageType == MessageType.image.rawValue else { return }
        if let tableViewCell = messagesTableView.cellForRow(at: indexPath) as? ReceiverMediaCell {
            AppRouter.presentImageViewerVC(self, image: tableViewCell.mediaImageView.image, imageURL: message.mediaUrl)
        }
        if let tableViewCell = messagesTableView.cellForRow(at: indexPath) as? SenderMediaCell {
            AppRouter.presentImageViewerVC(self, image: tableViewCell.mediaImageView.image, imageURL: message.mediaUrl)
        }
        print(message.mediaUrl)
    }
    //
    @objc func tapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let indexPath = self.messagesTableView.indexPath(forItem: gestureRecognizer.view ?? UIView()) else { return }
        guard !selectedIndexPaths.isEmpty else {
            openImageViewer(indexPath: indexPath)
            return
        }
    }
    
    @objc func tapLongGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
        //roomId:string,timeStamp:Any,
        var inboxUserId = ""
        if self.requestId.isEmpty{
            inboxUserId = currentUserId
        } else {
            inboxUserId = currentUserId + "_" + self.requestId
        }
        guard let indexPath = self.messagesTableView.indexPath(forItem: gestureRecognizer.view ?? UIView()) else { return }
        if self.messageListing[indexPath.section][indexPath.row].senderId != self.currentUserId { return }
        guard !selectedIndexPaths.isEmpty else {
            showAlertWithAction(title: "Delete Message", msg: "Do you want to delete message?", cancelTitle: "No", actionTitle: "Delete", actioncompletion: {
                if indexPath.section == self.messageListing.endIndex - 1 &&  indexPath.row == self.messageListing[indexPath.section].endIndex - 1{
                    self.deleteMessages(index: indexPath)
                    self.updateInboxTimeStamp()
                    let prevMsgModel =  indexPath.row > 0 ? self.messageListing[indexPath.section][indexPath.row - 1] : (indexPath.section > 0 ? self.messageListing[indexPath.section - 1][indexPath.row] : Message())
                    //Assign previous LastMessage model to Last Message
                    if prevMsgModel.messageId.isEmpty {
                        self.db.collection(ApiKey.lastMessage)
                            .document(self.roomId)
                            .collection(ApiKey.chat)
                            .document(ApiKey.message).delete()
                    }else {
                    FirestoreController.createLastMessageNodeAfterDeleteMessage(roomId: prevMsgModel.roomId, messageText: prevMsgModel.messageText, messageTime: prevMsgModel.messageTime, messageId: prevMsgModel.messageId, messageType: prevMsgModel.messageType, messageStatus: prevMsgModel.messageStatus, senderId: prevMsgModel.senderId, receiverId: prevMsgModel.receiverId, mediaUrl: prevMsgModel.mediaUrl, blocked: prevMsgModel.blocked, thumbNailURL: prevMsgModel.thumbnailURL, messageDuration: prevMsgModel.messageDuration, price: prevMsgModel.price, amIBlocked: self.amIBlocked)
                    }
                } else {
                    if self.messageListing[indexPath.section][indexPath.row].messageStatus == 1 || self.messageListing[indexPath.section][indexPath.row].messageStatus == 2{
                        self.deleteMessages(index: indexPath)
                        self.updateInboxTimeStamp()
                        self.db.collection(ApiKey.inbox)
                            .document(self.inboxModel.userId)
                            .collection(ApiKey.chat)
                            .document(inboxUserId)
                            .getDocument { (snapshot, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else{
                                    print("============================")
                                    guard let data = snapshot?.data() else { return }
                                    print(data[ApiKey.unreadCount] as? Int ?? 0)
                                    self.inboxModel.unreadCount = data[ApiKey.unreadCount] as? Int ?? 0
                                    if !self.amIBlocked {
                                        FirestoreController.updateUnreadMessagesAfterDeleteMessage(senderId: inboxUserId, receiverId: self.inboxModel.userId, unread: data[ApiKey.unreadCount] as? Int ?? 0)
                                    }
                                }
                        }
                    }else{
                        self.deleteMessages(index: indexPath)
                        self.updateInboxTimeStamp()
                    }
                }
            } ) {}
            return
        }
    }
    //
    // Delete full chat
    private func deleteFullChat() {
        db.collection(ApiKey.inbox).document(currentUserId).collection(ApiKey.chat).document(inboxModel.userId).delete { [weak self] (error) in
            guard let `self` = self else { return }
            if let err = error {
                self.showAlert(msg: err.localizedDescription)
                printDebug("Error removing document: \(err)")
            } else {
                self.pop()
                printDebug("Document successfully removed!")
            }
        }
    }
    
    // Delete selected messages
    func deleteMessages(index: IndexPath) {
        //        selectedIndexPaths.sort()
        //        selectedIndexPaths.reverse()
        //        for index in selectedIndexPaths {
        let id = self.messageListing[index.section][index.row].messageId
        self.db.collection(ApiKey.messages).document(self.getRoomId()).collection(ApiKey.chat).document(id).delete() { (err) in
            if let err = err {
                printDebug("Error removing document: \(err)")
            } else {
                printDebug("Document successfully removed!")
            }
        }
        //        }
    }
}

//MARK: CHAT FUNCTIONS
//====================
extension OneToOneChatVC{
    
    
    ///Mark:- Checking send button
    private func fetchUnreadMessages(){
        FirestoreController.getUnreadMessageCount(receiverId: inboxModel.userId, senderId: currentUserId)
    }
    
    ///Mark:- Batch count fetching
    private func getBatchCount(){
        FirestoreController.getTotalMessagesCount(senderId: self.inboxModel.userId)
    }
    
    ///Mark:- Update unread messages
    private func updateUnreadMessage() {
        //roomId:string,timeStamp:Any,
         var inboxUserId = ""
         if self.requestId.isEmpty{
             inboxUserId = currentUserId
         } else {
             inboxUserId = currentUserId + "_" + self.requestId
         }
        
        db.collection(ApiKey.inbox)
            .document(inboxModel.userId)
            .collection(ApiKey.chat)
            .document(inboxUserId)
            .getDocument { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else{
                    print("============================")
                    guard let data = snapshot?.data() else { return }
                    print(data[ApiKey.unreadCount] as? Int ?? 0)
                    self.inboxModel.unreadCount = data[ApiKey.unreadCount] as? Int ?? 0
                    if !self.amIBlocked {
                        FirestoreController.updateUnreadMessages(senderId: inboxUserId, receiverId: self.inboxModel.userId, unread: data[ApiKey.unreadCount] as? Int ?? 0)
                }
            }
        }
    }
    
    private func restoreDeletedNode() {
        //roomId:string,timeStamp:Any,
        var inboxxUserId = ""
        if self.requestId.isEmpty{
            inboxxUserId = inboxModel.userId
        } else {
            inboxxUserId = inboxModel.userId + "_" + self.requestId
        }
        //roomId:string,timeStamp:Any,
        var inboxUserId = ""
        if self.requestId.isEmpty{
            inboxUserId = currentUserId
        } else {
            inboxUserId = currentUserId + "_" + self.requestId
        }
        db.collection(ApiKey.inbox)
            .document(currentUserId)
            .collection(ApiKey.chat)
            .document(inboxxUserId)
            .setData([ApiKey.requestId: self.requestId,
                      ApiKey.garageUserId: self.garageUserId,
                      ApiKey.bidRequestId: self.bidRequestId,ApiKey.chatType: ApiKey.single,
                      ApiKey.roomId: roomId,
                      ApiKey.roomInfo: db.collection(ApiKey.roomInfo).document(roomId),
                      ApiKey.timeStamp: FieldValue.serverTimestamp(),
                      ApiKey.lastMessage: db.collection(ApiKey.lastMessage).document(roomId).collection(ApiKey.chat).document(ApiKey.message),
                      ApiKey.userDetails: db.collection(ApiKey.users).document(inboxModel.userId)])
            { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("success")
                }
        }
        
        db.collection(ApiKey.inbox).document(inboxModel.userId).collection(ApiKey.chat).document(inboxUserId).getDocument { (doc, error) in
            if let document = doc {
                if !document.exists {
                    self.db.collection(ApiKey.inbox)
                        .document(self.inboxModel.userId)
                        .collection(ApiKey.chat)
                        .document(inboxUserId)
                        .setData([ApiKey.requestId: self.requestId,
                                  ApiKey.garageUserId: self.garageUserId,
                                  ApiKey.bidRequestId: self.bidRequestId,ApiKey.chatType: ApiKey.single,
                                  ApiKey.roomId:self.roomId,
                                  ApiKey.roomInfo: self.db.collection(ApiKey.roomInfo).document(self.roomId),
                                  ApiKey.timeStamp: FieldValue.serverTimestamp(),
                                  ApiKey.lastMessage: self.db.collection(ApiKey.lastMessage).document(self.roomId).collection(ApiKey.chat).document(ApiKey.message),
                                  ApiKey.userDetails: self.db.collection(ApiKey.users).document(self.currentUserId),
                                  ApiKey.unreadCount: self.inboxModel.unreadCount + 1])
                        { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("success")
                            }
                    }
                }
            }
        }
        
    }
    
    /// Mark:- Create Inbox
    private func createInbox(){
        //roomId:string,timeStamp:Any,
        var inboxUserId = ""
        if self.requestId.isEmpty{
            inboxUserId = currentUserId
        } else {
            inboxUserId = currentUserId + "_" + self.requestId
        }
        db.collection(ApiKey.inbox)
            .document(inboxModel.userId)
            .collection(ApiKey.chat)
            .document(inboxUserId)
            .setData([ApiKey.requestId: self.requestId,
                      ApiKey.garageUserId: self.garageUserId,
                      ApiKey.bidRequestId: self.bidRequestId,
                      ApiKey.roomId:roomId,
                      ApiKey.roomInfo: db.collection(ApiKey.roomInfo).document(roomId),
                      ApiKey.timeStamp: FieldValue.serverTimestamp(),
                      ApiKey.lastMessage: db.collection(ApiKey.lastMessage).document(roomId).collection(ApiKey.chat).document(ApiKey.message),
                      ApiKey.userDetails: db.collection(ApiKey.users).document(currentUserId),
                      ApiKey.unreadCount: inboxModel.unreadCount + 1])
            { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("success")
                }
        }
        //roomId:string,timeStamp:Any,
        var inboxxUserId = ""
        if self.requestId.isEmpty{
            inboxxUserId = inboxModel.userId
        } else {
            inboxxUserId = inboxModel.userId + "_" + self.requestId
        }
        db.collection(ApiKey.inbox)
            .document(currentUserId)
            .collection(ApiKey.chat)
            .document(inboxxUserId)
            .setData([ApiKey.requestId: self.requestId,
                      ApiKey.garageUserId: self.garageUserId,
                      ApiKey.bidRequestId: self.bidRequestId,
                      ApiKey.roomId: roomId,
                      ApiKey.roomInfo: db.collection(ApiKey.roomInfo).document(roomId),
                      ApiKey.timeStamp: FieldValue.serverTimestamp(),
                      ApiKey.lastMessage: db.collection(ApiKey.lastMessage).document(roomId).collection(ApiKey.chat).document(ApiKey.message),
                      ApiKey.userDetails: db.collection(ApiKey.users).document(inboxModel.userId)])
            { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("success")
                }
        }
        if !isRoom && !amIBlocked {
            FirestoreController.updateUnreadMessages(senderId: inboxUserId, receiverId: inboxModel.userId, unread: 0)
        }
    }
    
    
    /// Mark:- Fetch the last message from a blocked user
    
//    private func getLastMessageBeforeBlock(){
//
//        let uid = AppUserDefaults.value(forKey: .uid).string ?? ""
//        let listener = db.collection(ApiKey.inbox).document(uid).collection(ApiKey.chat).addSnapshotListener { querySnapshot, error in
//            querySnapshot?.documentChanges.forEach({ (newUser) in
//                let inbox = Inbox(newUser.document.data())
//                if newUser.type == .added{
//                    inbox.lastMessageRef?.getDocument(completion: { (document, error) in
//                        FirestoreController.createLastMessageOfBlockedUser(roomId: self.roomId, senderId: self.currentUserId, messageModel: (document?.data())! )
//                    })
//
//                } else if newUser.type == .modified {
//
//                }
//                else if newUser.type == .removed {
//
//                } else {
//
//                }
//            })
//        }
//        listeners.append(listener)
//    }
    
    private func getLastMessageBeforeBlock(){
        db.collection(ApiKey.lastMessage).document(roomId).collection(ApiKey.chat).document(ApiKey.message).getDocument { [weak self] (snapshot, error) in
            if let err = error {
            print(err.localizedDescription)
        } else {
                if let data = snapshot?.data() {
                printDebug(data)
                    
              FirestoreController.createLastMessageOfBlockedUser(roomId: self?.roomId ?? "", senderId: self?.currentUserId ?? "", messageModel: (data))

            }
        }
    }
}
    
    /// Mark:- Create a new batch
    private func createBatch(){
        FirestoreController.createTotalMessageNode(receiverId: inboxModel.userId)
    }
    
    /// Mark:- Fetching the message ID
    private func getMessageId() -> String {
        let messageId = Firestore.firestore().collection(ApiKey.roomInfo).document().documentID
        return messageId
    }
    
    /// Mark:- Creating a message node
    private func createMessage(msgType: String = "text",price: Int = 0){
        
        if msgType == "payment" {
             FirestoreController.createLastMessageNode(roomId:roomId,messageText: messageTextView.text.byRemovingLeadingTrailingWhiteSpaces ,messageTime:FieldValue.serverTimestamp(), messageId:getMessageId(),messageType: msgType, messageStatus:1,senderId:inboxModel.userId , receiverId: currentUserId, mediaUrl: "",blocked:amIBlocked, thumbNailURL: "", messageDuration: 0,price: price, amIBlocked: amIBlocked)
        }
        else {
            FirestoreController.createLastMessageNode(roomId:roomId,messageText: messageTextView.text.byRemovingLeadingTrailingWhiteSpaces ,messageTime:FieldValue.serverTimestamp(), messageId:getMessageId(),messageType: msgType, messageStatus:1,senderId:currentUserId,receiverId:inboxModel.userId, mediaUrl: "",blocked:amIBlocked, thumbNailURL: "", messageDuration: 0,price: price, amIBlocked: amIBlocked)
        }
        
        
        if msgType == "payment" {
             FirestoreController.createMessageNode(roomId:roomId,messageText: messageTextView.text.byRemovingLeadingTrailingWhiteSpaces ,messageTime:FieldValue.serverTimestamp(), messageId:getMessageId(),messageType: msgType, messageStatus:1,senderId: inboxModel.userId, receiverId: currentUserId , mediaUrl: "",blocked: amIBlocked, thumbNailURL: "", messageDuration: 0,price: price)
        }else {
            FirestoreController.createMessageNode(roomId:roomId,messageText: messageTextView.text.byRemovingLeadingTrailingWhiteSpaces ,messageTime:FieldValue.serverTimestamp(), messageId:getMessageId(),messageType: msgType, messageStatus:1,senderId:currentUserId, receiverId:inboxModel.userId, mediaUrl: "",blocked: amIBlocked, thumbNailURL: "", messageDuration: 0,price: price)
        }
    }
    
    private func createMediaMessage(url: String, imageURL: String = "", type: String) {
        FirestoreController.createMessageNode(roomId: self.roomId, messageText: "", messageTime: FieldValue.serverTimestamp(), messageId: self.getMessageId(), messageType: type, messageStatus: 1, senderId: self.currentUserId, receiverId: self.inboxModel.userId, mediaUrl: url, blocked: amIBlocked, thumbNailURL: imageURL,messageDuration: self.chatViewModel.totalTime, price: 0)
        let attachmentText = type == MessageType.image.rawValue ? "Photo Attachment" : "Audio Attachment"
        FirestoreController.createLastMessageNode(roomId: self.roomId, messageText: attachmentText, messageTime: FieldValue.serverTimestamp(), messageId: self.getMessageId(), messageType: type, messageStatus: 1, senderId: self.currentUserId, receiverId: self.inboxModel.userId, mediaUrl: url, blocked: amIBlocked, thumbNailURL: imageURL,messageDuration: self.chatViewModel.totalTime,price: 0, amIBlocked: amIBlocked)
    }
    
    /// Mark:- Fetching the room Id values
    private func getRoomId()-> String{
        if currentUserId < inboxModel.userId {
            if !requestId.isEmpty{
                self.roomId =  currentUserId + "_" + self.requestId + "_" + inboxModel.userId
            } else {
                self.roomId = currentUserId + "_" + inboxModel.userId
            }
            return self.roomId
        } else {
            if !requestId.isEmpty{
                self.roomId =  inboxModel.userId + "_" + self.requestId + "_" + currentUserId
            } else {
                self.roomId = inboxModel.userId + "_" + currentUserId
            }
            return self.roomId
        }
    }
    
    /// Mark:- Updating the inbox time stamp
    private func updateInboxTimeStamp(){
        //roomId:string,timeStamp:Any,
        var inboxUserId = ""
        if self.requestId.isEmpty{
            inboxUserId = currentUserId
        } else {
            inboxUserId = currentUserId + "_" + self.requestId
        }
        db.collection(ApiKey.inbox).document(inboxModel.userId).collection(ApiKey.chat).document(inboxUserId).updateData([ApiKey.timeStamp : FieldValue.serverTimestamp()])
        //roomId:string,timeStamp:Any,
        var inboxxUserId = ""
        if self.requestId.isEmpty{
            inboxxUserId = inboxModel.userId
        } else {
            inboxxUserId = inboxModel.userId + "_" + self.requestId
        }
        db.collection(ApiKey.inbox).document(currentUserId).collection(ApiKey.chat).document(inboxxUserId).updateData([ApiKey.timeStamp : FieldValue.serverTimestamp()])
    }
    
    /// Mark:- Update the status of sender if it is blocked
    private func updateIfSenderIsBlocked(){
        FirestoreController.updateLastMessagePathInInbox(senderId: currentUserId, receiverId: inboxModel.userId, roomId: roomId) {
            print("=================updateLastMessageCompletion===========================")
            
        }
    }
    
    /// Mark:- Fetch the last message of the blocked user
    private func fetchLastMessageOfBlockUser(){
        db.collection(ApiKey.messages).document(roomId).collection(ApiKey.chat).document(getRoomId())
    }
    
    /// Mark:- Update delete time in room when deleting full chat
    private func updateDeleteTime() {
        guard var currentUserDict = userInfo[currentUserId] as? [String: Any] else { return }
        deleteTime = Timestamp()
        currentUserDict[ApiKey.deleteTime] = Timestamp()
        userInfo[currentUserId] = currentUserDict
        db.collection(ApiKey.roomInfo).document(roomId).updateData([ApiKey.userInfo: userInfo]) { [weak self] (error) in
            guard let `self` = self else { return }
            if let err = error {
                print(err.localizedDescription)
            } else {
                //                self.deleteFullChat()
            }
        }
    }
    
    /// Mark:-  Creating a new room
    private func createRoom() {
        if !self.requestId.isEmpty {
            self.roomId = currentUserId < inboxModel.userId ? currentUserId + "_" + self.requestId + "_" + inboxModel.userId : inboxModel.userId + "_" + self.requestId + "_" + currentUserId
        }else{
            self.roomId = currentUserId < inboxModel.userId ? currentUserId + "_" + inboxModel.userId : inboxModel.userId + "_" + currentUserId
        }
        AppUserDefaults.save(value: roomId, forKey: .roomId)
        print("sender " + currentUserId,"receiver " + inboxModel.userId,"requestId " + requestId,"roomcreated " + roomId)
        
        /// Mark:- Details relating to the current user
        let currentUserIdDict: [String: Any] = [ApiKey.addedTime:FieldValue.serverTimestamp(),
                                                ApiKey.deleteTime:FieldValue.serverTimestamp(),
                                                ApiKey.leaveTime: ""]
        
        /// Mark:- Details relating to the general user
        let userIdDict: [String: Any] = [ApiKey.addedTime:FieldValue.serverTimestamp(),
                                         ApiKey.leaveTime:"",
                                         ApiKey.deleteTime:FieldValue.serverTimestamp()]
        
        /// Mark:- Information about the user
        let userInfoDict: [String: Any] = [currentUserId: currentUserIdDict,
                                           inboxModel.userId: userIdDict]
        
        /// Mark:- Typing status info abouthe the user
        let userTypingStatus: [String: Any] = [currentUserId:true,
                                               inboxModel.userId:false]
        
        let roomImageURL = "https://console.firebase.google.com"
        
        /// Mark:- Parameter dictionary of the user details
        let _ : [String: Any] = [ApiKey.roomId : roomId,
                                 ApiKey.roomImage: roomImageURL,
                                 ApiKey.roomName:"",
                                 ApiKey.roomType:"single",
                                 ApiKey.userInfo: userInfoDict,
                                 ApiKey.typingStatus: userTypingStatus]
        
        FirestoreController.createRoomNode(roomId: roomId, roomImage: roomImageURL, roomName: "", roomType: "single", userInfo: userInfoDict, userTypingStatus: userTypingStatus)
        
    }
    
    
    private func fetchDeleteTime() {
        db.collection(ApiKey.roomInfo).document(getRoomId()).addSnapshotListener { [weak self]  (snapshot, error) in
            guard let `self` = self else { return }
            if let document = snapshot?.data() {
                if let dictonary = document[ApiKey.userInfo] as? [String : Any] {
                    self.userInfo = dictonary
                    if let dict = dictonary[self.currentUserId] as? [String: Any] {
                        if let time = dict[ApiKey.deleteTime] as? Timestamp {
                            if   self.deleteTime != time {
                            self.deleteTime = time
                            self.fetchMessageListing()
                            }
                        }
                    }
                    //Typing status observer.....
                    if let typingDict = document[ApiKey.typingStatus] as? [String : Any]{
                        if let senderTypingStatus =  typingDict[self.inboxModel.userId] as? Bool{
                            if (senderTypingStatus) {
                                self.footerViewSetUp(isFooter: true)
                                self.reloadTableViewToBottom()
                            } else {
                                self.footerViewSetUp(isFooter: false)
                                self.reloadTableViewToBottom()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func checkRoomAvailability() {
        let listenerOne = db.collection(ApiKey.roomInfo).document(getRoomId()).addSnapshotListener { [weak self]  (snapshot, error) in
            guard let `self` = self else { return }
            self.isRoom = (snapshot?.data() != nil)
        }
        listeners.append(listenerOne)
    }
    
    /// Mark:- Fetch the listing of the message
    private func fetchMessageListing(){
        
        let listenerTwo = db.collection(ApiKey.messages).document(getRoomId()).collection(ApiKey.chat).order(by: ApiKey.messageTime, descending: false).start(at: [deleteTime]).addSnapshotListener { [weak self] querySnapshot, error in
            guard let `self` = self else { return }
            querySnapshot?.documentChanges.forEach({ [weak self] (newMessage) in
                guard let `self` = self else { return }

                if newMessage.type == .added {
                    let message = Message(newMessage.document.data())
                    if message.blocked && message.receiverId == self.currentUserId {
                        return
                    }
//                    if !message.blocked {
                    if message.messageType != "offer" && message.messageType != "payment" {
                       if message.senderId == self.inboxModel.userId {                            self.db.collection(ApiKey.messages).document(self.getRoomId()).collection(ApiKey.chat).document(message.messageId).updateData([ApiKey.messageStatus : 3]) { (error) in
                            if let err = error {
                                print(err.localizedDescription)
                            } else {
                                //                                self.db.collection(ApiKey.inbox).document(self.currentUserId).collection(ApiKey.chat).document(self.inboxModel.userId).updateData([ApiKey.unreadMessages: 0])
                               }
                            }
                        }
                    }
                        
                        if (message.messageTime.dateValue().convertToDefaultString() == self.tempTime.dateValue().convertToDefaultString() || self.messageListing.isEmpty) {
                            self.tempTime = message.messageTime
                            if self.messageListing.isEmpty {
                                self.messageListing.append([message])
                            } else {
                                self.messageListing[self.indexVal].removeAll { (msg) -> Bool in
                                    return msg.messageId == message.messageId
                                }
                                self.messageListing[self.indexVal].append(message)
                            }
                        } else {
                            self.indexVal += 1
                            self.tempTime = message.messageTime
                            self.messageListing.append([message])
                        }
//                    }
                    DispatchQueue.main.async {
                        self.reloadTableViewToBottom()
                    }
                }
                else if newMessage.type == .modified {
                    let message = Message(newMessage.document.data())
                    if message.blocked && message.receiverId == self.currentUserId {
                        return
                    }
                    //                    if !message.blocked  {
                    if message.messageType != "offer" && message.messageType != "payment" {
                        
                        if message.senderId == self.inboxModel.userId {
                            
                            self.db.collection(ApiKey.messages).document(self.getRoomId()).collection(ApiKey.chat).document(message.messageId).updateData([ApiKey.messageStatus : 3]) { (error) in
                                if let err = error {
                                    print(err.localizedDescription)
                                } else {
                                    //                                self.db.collection(ApiKey.inbox).document(self.currentUserId).collection(ApiKey.chat).document(self.inboxModel.userId).updateData([ApiKey.unreadMessages: 0])
                                }
                            }
                        }
                    }
                        for (off, section) in self.messageListing.enumerated() {
                            if let msgIndex = section.firstIndex(where: {$0.messageId == message.messageId}) {
                                self.messageListing[off][msgIndex] = message
                                break
                            }
                        }
//                    }
                    DispatchQueue.main.async {
                        self.reloadTableViewToBottom()
                    }
                } else {
                    for (offset, section) in self.messageListing.enumerated() {
                        let indexOfDeletedMsg = section.firstIndex { (msgModel) -> Bool in
                            return msgModel.messageId == (newMessage.document.data()[ApiKey.messageId] as? String ?? "" )
                        }
                        if let index = indexOfDeletedMsg {
                            self.messageListing[offset].remove(at: index)
                            self.updateInbox(section: offset)
                            DispatchQueue.main.async {
                                self.messagesTableView.reloadData()
                            }
                            break
                        }
                    }
                }
                self.selectedIndexPaths = []
            })
            DispatchQueue.main.async {
                //                self.reloadTableViewToBottom()
            }
        }
        listeners.append(listenerTwo)
    }
    
    // Mark:- Update Inbox
    private func updateInbox(section: Int) {
        //roomId:string,timeStamp:Any,
        var inboxxUserId = ""
        if self.requestId.isEmpty{
            inboxxUserId = inboxModel.userId
        } else {
            inboxxUserId = inboxModel.userId + "_" + self.requestId
        }
        
        //roomId:string,timeStamp:Any,
        var inboxUserId = ""
        if self.requestId.isEmpty{
            inboxUserId = currentUserId
        } else {
            inboxUserId = currentUserId + "_" + self.requestId
        }
        
        printDebug(self.messageListing.last)
        db.collection(ApiKey.lastMessage).document(roomId).collection(ApiKey.chat).document(ApiKey.message).updateData([ApiKey.messageTime: self.messageListing[section].last?.messageTime ?? Timestamp(), ApiKey.messageText: self.messageListing[section].last?.messageText ?? ""])
        
        let lastMessageReference = db.collection(ApiKey.lastMessage).document(roomId).collection(ApiKey.chat).document(ApiKey.message)
        
        db.collection(ApiKey.inbox)
            .document(inboxModel.userId)
            .collection(ApiKey.chat)
            .document(inboxUserId).updateData([ApiKey.lastMessage : lastMessageReference, ApiKey.timeStamp: FieldValue.serverTimestamp()])
        
        db.collection(ApiKey.inbox)
            .document(currentUserId)
            .collection(ApiKey.chat)
            .document(inboxxUserId).updateData([ApiKey.lastMessage : lastMessageReference, ApiKey.timeStamp: FieldValue.serverTimestamp()])
        
    }
    
    private func startReceiverBlockListener() {
        db.collection(ApiKey.block).document(currentUserId).collection(ApiKey.chat).document(inboxModel.userId).addSnapshotListener { [weak self] (snapshot, error) in
            guard let `self` = self else { return }
            if let err = error {
                print(err.localizedDescription)
            } else {
                if let data = snapshot?.data() {
                    self.getLastMessageBeforeBlock()
                    self.isBlockedByMe = true
                    printDebug(self.isBlockedByMe)
                    printDebug(data.keys.contains(self.inboxModel.userId))
                    
                }else {
                    self.isBlockedByMe = false

                }
            }
        }
    }
    
    private func startSenderBlockListener() {
        let listener = db.collection(ApiKey.block).document(inboxModel.userId).collection(ApiKey.chat).document(currentUserId).addSnapshotListener { [weak self] (snapshot, error) in
            guard let `self` = self else { return }
            if let err = error {
                print(err.localizedDescription)
            } else {
                if let data = snapshot?.data() {
                    self.amIBlocked = true
                    printDebug(self.amIBlocked)
                    printDebug(data.keys.contains(self.inboxModel.userId))
                    
                }else {
                    self.amIBlocked = false
                }
            }
        }
        listeners.append(listener)
    }
    
}

extension OneToOneChatVC: UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard scrollView === containerScrollView else { return }
        let vel = scrollView.panGestureRecognizer.velocity(in: scrollView).y
        if vel < 0 {
            
        } else if vel > 0 {
            scrollView.isScrollEnabled = false
            
        } else {
            
        }
    }
}

// Mark:- Audio Messages Inbox
extension OneToOneChatVC:  AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    func startRecording() {
        let audioFilename = getFileURL()
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        if let recorder = audioRecorder {
            recorder.stop()
        }
//        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            //            recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            //            recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        return path as URL
    }
    
    //MARK: Delegates
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            self.recordedUrl = recorder.url
        }else {
            finishRecording(success: false)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
    
    
    private func startTimer() {
        timerLbl.isHidden = false
        timerView.isHidden = false
        chatViewModel.totalTime = 00
        chatViewModel.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTime() {
        let time  = "\(chatViewModel.timeFormatted(chatViewModel.totalTime))"
        timerLbl.text = time
        if chatViewModel.totalTime != 300 {
            chatViewModel.totalTime += 1
            progressVIew.setProgress(Float(chatViewModel.totalTime) * 1/300, animated: true)
        } else {
            audioRecordBtn.setImage(#imageLiteral(resourceName: "group3603"), for: .normal)
            finishRecording(success: true)
            endTimer()
        }
    }
    
    private func endTimer() {
        chatViewModel.countdownTimer.invalidate()
    }
    
    private func uploadAudioFileToFirestore(_ url: URL){
        CommonFunctions.showActivityLoader()
        UIImage().uploadAudioFile(audioUrl: url, progress: { [weak self] (status) in
            guard let `self` = self else { return }
            printDebug(status)
            if !self.hasImageUploaded { ToastView.shared.showLongToast(self.view, msg: "\(Int(status * 100))% Uploaded")}
            }, completion: { (response,error) in
                if let url = response {
                    self.hasImageUploaded = true
                    CommonFunctions.hideActivityLoader()
                    if self.isRoom {
                        self.updateUnreadMessage()
                        self.restoreDeletedNode()
                        self.createMediaMessage(url: url, imageURL: url, type: "audio")
                        self.updateInboxTimeStamp()
                    } else {
                        self.createRoom()
                        self.createMediaMessage(url: url, imageURL: url, type: "audio")
                        self.createInbox()
                    }
                }
                if let _ = error{
                    self.showAlert(msg: LocalizedString.imageUploadingFailed.localized)
                }
        })
    }
    
}

// Chat View Model
extension OneToOneChatVC : OneToOneChatViewModelDelegate{
    func chatDataSuccess(msg: String) {
        if self.chatUserType == .garage {
            self.editBidBtn.isHidden = (chatViewModel.chatData.isServiceStarted ?? true)
            tableViewTopConstraint.constant = chatViewModel.chatData.id.isEmpty ? 0.0 : 80.0
            userRequestView.isHidden = false
            userNameLbl.text = chatViewModel.chatData.userName
            numberOfServiceLbl.text = chatViewModel.chatData.totalRequests.description + " Services"
            userImgView.setImage_kf(imageString: chatViewModel.chatData.userImage, placeHolderImage: #imageLiteral(resourceName: "placeHolder"), loader: false)
            var str: NSMutableAttributedString = NSMutableAttributedString()
            str = NSMutableAttributedString(string: chatViewModel.chatData.totalAmount?.description ?? "\(0)", attributes: [
                .font: AppFonts.NunitoSansBold.withSize(17.0),
                .foregroundColor: AppColors.successGreenColor
            ])
            
            str.append(NSAttributedString(string: "SAR", attributes: [NSAttributedString.Key.foregroundColor: AppColors.successGreenColor,NSAttributedString.Key.font: AppFonts.NunitoSansSemiBold.withSize(12.0)]))
            amountValueLbl.attributedText = str
        }
        else if chatUserType == .user{
            tableViewTopConstraint.constant = chatViewModel.chatData.id.isEmpty  ? 0.0 : 124.0
            garageTopView.isHidden = false
            garageImgView.setImage_kf(imageString: chatViewModel.chatData.garageImage, placeHolderImage: #imageLiteral(resourceName: "placeHolder"), loader: false)
            garageRequestNoValueLbl.text = chatViewModel.chatData.requestId
            garageAmountValueLbl.text = chatViewModel.chatData.totalAmount?.description
            garageRatingLbl.text = (chatViewModel.chatData.garageRating?.truncate(places: 1).description ?? "") + "/5"
            garageAddressLbl.text = chatViewModel.chatData.garageAddress
            garageNameLbl.text = chatViewModel.chatData.garageName
        }
        CommonFunctions.delay(delay: 0.2) {
            self.scrollMsgToBottom(animated: true)
        }
    }
    
    func chatDataFailure(msg: String) {
        userRequestView.isHidden = true
        CommonFunctions.showToastWithMessage(msg)
    }
    
    func acceptRejectEditedBidSuccess(msg: String) {
        if acceptedRejectBtnStatus {
            self.db.collection(ApiKey.messages).document(self.getRoomId()).collection(ApiKey.chat).document(self.messageId).updateData([ApiKey.messageStatus : 2]) { (error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    //                                self.db.collection(ApiKey.inbox).document(self.currentUserId).collection(ApiKey.chat).document(self.inboxModel.userId).updateData([ApiKey.unreadMessages: 0])
                }
                self.getChatData()
            }
        }else {
            self.db.collection(ApiKey.messages).document(self.getRoomId()).collection(ApiKey.chat).document(self.messageId).updateData([ApiKey.messageStatus : 3]) { (error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    //                                self.db.collection(ApiKey.inbox).document(self.currentUserId).collection(ApiKey.chat).document(self.inboxModel.userId).updateData([ApiKey.unreadMessages: 0])
                }
            }
        }
    }
    
    func acceptRejectEditedBidFailure(msg: String) {
        
    }
}

//MARK:- ChatEditBidVCDelegate
extension OneToOneChatVC : ChatEditBidVCDelegate {
    func bidEditSuccess(price: Int) {
        self.messageTextView.text = "Offer"
        sendMessage(msgType: MessageType.offer.rawValue,price: price)
    }
}
