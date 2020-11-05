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
    var viewModel = OtpVerificationVM()
    weak var delegate: SetLastMessageDelegate?

    private let db = Firestore.firestore()

    var inboxModel = Inbox()
    var firstName = ""
    var requestId = ""
    var userImage = ""
    var imageController = UIImagePickerController()
    var alertController = UIAlertController()
    lazy var titleTap = UITapGestureRecognizer(target: self, action: #selector(titleLabelTapped(_:)))

    var indexVal = 0
    var tempTime = Timestamp.init(date: Date())

    private var deleteTime = Timestamp.init(date: Date())
    private var userInfo = [String:Any]()
    var roomId = ""
    var lastMessageModel : [String:Any] = [:]
    let currentUserId = AppUserDefaults.value(forKey: .uid).stringValue
    var messageListing = [[Message]]()
    var isRoom = false
    
    fileprivate var hasImageUploaded = true {
        didSet {
            if hasImageUploaded {
                CommonFunctions.showToastWithMessage("Upload Completed")
            }
        }
    }
    var selectedIndexPaths: [IndexPath] = []
    var listeners = [ListenerRegistration]()
    //Audio messages
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var player:AVPlayer?
    var playerItem:AVPlayerItem?

    //MARK: OUTLETS
    //=============
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
        self.backgroundView.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIApplication.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addDocumentBtn.round()
        audioBtn.round()
        sendButton.round()
        textContainerInnerView.round(radius: 10)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.db.collection(ApiKey.inbox).document(AppUserDefaults.value(forKey: .uid).stringValue).collection(ApiKey.chat).document(inboxModel.userId).getDocument(completion: { (document, error) in
            if let doc = document {
                let unreadMsgs = doc.data()?[ApiKey.unreadMessages] as? Int ?? 0
                var diff = FirestoreController.ownUnreadCount - unreadMsgs
                diff = diff <= 0 ? 0 : diff

                self.db.collection(ApiKey.inbox).document(self.currentUserId).collection(ApiKey.chat).document(self.inboxModel.userId).updateData([ApiKey.unreadMessages: 0])

                self.db.collection(ApiKey.batchCount)
                    .document(AppUserDefaults.value(forKey: .uid).stringValue)
                    .setData([ApiKey.unreadMessages : (diff)])
            }})
        //        listeners.forEach({$0.remove()})
    }

    //MARK: ACTIONS
    //=============
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        _ = touch.location(in: self.view)
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        popToInboxView()
    }

    @IBAction func addAttachmentsButtonTapped(_ sender: UIButton) {
        createMediaAlertSheet()
    }

    @IBAction func addAudioMsgBtnTapped(_ sender: UIButton) {
        if audioRecorder == nil {
            startTimer()
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        sendMessage()
    }

}

//MARK: PRIVATE FUNCTIONS
//=======================
extension OneToOneChatVC {

    private func initialSetup() {
        checkRoomAvailability()
        containerScrollView.delegate = self
        bottomContainerView.isUserInteractionEnabled = true
        addTapGestureToTitle()
//        viewModel.delegate = self
        setupTableView()
        setupImageController()
        setupTextView()
        fetchDeleteTime()
        getBatchCount()
        setupAudioMessages()
    }

    private func addTapGestureToTitle() {
        titleLabel.isUserInteractionEnabled = true
        titleLabel.addGestureRecognizer(titleTap)
    }

    @objc private func titleLabelTapped(_ sender: UITapGestureRecognizer) {
//        AppRouter.goToMyGarageVC(self, userId: inboxModel.userId,userName: inboxModel.firstName, comeFromOtherProfile: true)
    }

    private func popToInboxView() {
        guard let nvc = self.navigationController else { return }
        for vc in nvc.viewControllers {
            if vc is UserChatVC {
//                self.navigationController?.popToViewControllerOfType(classForCoder: vc.self)
            }
        }
        self.pop()
    }

    private func setupImageController(){
//        imageController.delegate = self
        imageController.allowsEditing = false
        imageController.sourceType = UIImagePickerController.SourceType.photoLibrary
        imageController.mediaTypes = ["public.image", "public.movie"]
    }


    private func createMediaAlertSheet() {
         self.captureImage(delegate: self,removedImagePicture: false )
    }

    private func setupAudioMessages() {
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

    private func presentCamera() {
        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
        imagePicker.navigationBar.barTintColor = AppColors.appRedColor
        imagePicker.navigationBar.isTranslucent = false
        imagePicker.navigationBar.tintColor = .white
        let sourceType = UIImagePickerController.SourceType.camera
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? ["public.image", "public.movie"]
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }

    private func setupTableView() {
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messagesTableView.registerCell(with: SenderMessageCell.self)
        messagesTableView.registerCell(with: ReceiverMessageCell.self)
        messagesTableView.registerCell(with: SenderMediaCell.self)
        messagesTableView.registerCell(with: ReceiverMediaCell.self)
        messagesTableView.registerCell(with: SenderAudioCell.self)
        messagesTableView.registerCell(with: ReceiverAudioCell.self)
        messagesTableView.registerCell(with: DayValueCell.self)
    }

    private func setupTextView() {
        titleLabel.text = firstName
        messageTextView.delegate = self
        messageTextView.tintColor = AppColors.appRedColor
    }

    private func sendMessage() {
        self.view.endEditing(true)
        let txt = self.messageTextView.text.byRemovingLeadingTrailingWhiteSpaces
        guard !txt.isEmpty else { return }
            if isRoom {
                self.updateUnreadMessage()
                self.restoreDeletedNode()
                self.createMessage()
                self.updateInboxTimeStamp()
            } else {
                self.createRoom()
                self.createMessage()
                self.createInbox()
            }
        messageTextView.text = ""
        messageLabel.isHidden = false
        sendButton.setImage(#imageLiteral(resourceName: "group3603"), for: .normal)
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
        tableViewTopConstraint.constant = 0
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    @objc private func playVideo(_ sender: UIButton){
        guard let index = messagesTableView.indexPath(forItem: sender) else { return }
        let videoURLStr = messageListing[index.section][index.row].mediaUrl
        guard let videoURL = URL(string: videoURLStr) else { return }
        let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player

        present(playerViewController, animated: true) {
            guard let player = playerViewController.player else { return }
            player.play()
        }
    }

    @objc private func playVideoFromTap(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view, let index = messagesTableView.indexPath(forItem: view) else { return }
        let videoURLStr = messageListing[index.section][index.row].mediaUrl
        guard let videoURL = URL(string: videoURLStr) else { return }
        let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player

        present(playerViewController, animated: true) {
            guard let player = playerViewController.player else { return }
            player.play()
        }
    }
}

//MARK:- TEXT VIEW DELEGATES
//==========================
extension OneToOneChatVC: UITextViewDelegate{

    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        self.messageLabel.isHidden = !text.isEmpty
        if text.byRemovingLeadingTrailingWhiteSpaces.isEmpty {
            sendButton.setImage(#imageLiteral(resourceName: "group3603"), for: .normal)
            if text.isEmpty {
                self.resetFrames()
                return
            }
        } else {
            sendButton.setImage(#imageLiteral(resourceName: "group3603"), for: .normal)
        }
        let height = text.heightOfText(self.messageTextView.bounds.width - 10, font: AppFonts.NunitoSansRegular.withSize(16)) + 10
        if height >= 40 && height < 120 {
            textViewHeightConstraint.constant = height
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        messageLabel.isHidden = true
        textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        messageLabel.isHidden = !textView.text.byRemovingLeadingTrailingWhiteSpaces.isEmpty
        if messageLabel.isHidden {
            sendButton.setImage(#imageLiteral(resourceName: "group3603"), for: .normal)
        } else {
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
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
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
                senderMediaCell.senderImageView.setImage_kf(imageString: userImage, placeHolderImage: #imageLiteral(resourceName: "placeHolder"), loader: false)
                //                setTapGesture(view: senderMediaCell.msgContainerView, indexPath: indexPath)
                senderMediaCell.senderImageView.addGestureRecognizer(imgTap)
                senderMediaCell.senderNameLabel.text = self.firstName
                return senderMediaCell
            case MessageType.audio.rawValue:
                let receiverAudioCell = tableView.dequeueCell(with: ReceiverAudioCell.self)
                receiverAudioCell.receiverNameLbl.text = self.firstName
                return receiverAudioCell
            default:
                let receiverCell = tableView.dequeueCell(with: ReceiverMessageCell.self)
                receiverCell.configureCellWith(model: model)
                receiverCell.receiverNameLbl.text = self.firstName
                //                self.setupLongPressGesture(view: receiverCell.msgContainerView, indexPath: indexPath)
                //                self.setTapGesture(view: receiverCell.msgContainerView, indexPath: indexPath)
                return receiverCell
            }
        default:
            switch model.messageType {
            case MessageType.image.rawValue:
                let receiverMediaCell = tableView.dequeueCell(with: ReceiverMediaCell.self)
                receiverMediaCell.configureCellWith(model: model)
                return receiverMediaCell
            case MessageType.audio.rawValue:
                let senderAudioCell = tableView.dequeueCell(with: SenderAudioCell.self)
                //
                let url = URL(string: model.mediaUrl)
                self.playerItem = AVPlayerItem(url: url!)
                self.player = AVPlayer(playerItem: self.playerItem)
                senderAudioCell.playBtn.setImage(#imageLiteral(resourceName: "group3"), for: .normal)
                senderAudioCell.playBtnTapped = { [weak self]  in
                    guard let `self` = self else { return }
                    if self.player?.rate == 0
                    {
                        self.player!.play()
                        senderAudioCell.playBtn.isHidden = false
                        //            self.loadingView.isHidden = false
                        senderAudioCell.playBtn.setImage(#imageLiteral(resourceName: "group3714"), for: UIControl.State.normal)
                    } else {
                        self.player!.pause()
                        senderAudioCell.playBtn.setImage(#imageLiteral(resourceName: "group3"), for: UIControl.State.normal)
                    }
                }
//                let url = URL(string: model.mediaUrl)
//                self.playerItem = AVPlayerItem(url: url!)
//                self.player = AVPlayer(playerItem: playerItem)
                senderAudioCell.customSlider.minimumValue = 0
//                let duration : CMTime = (self.playerItem?.asset.duration)!
//                        let seconds : Float64 = CMTimeGetSeconds(duration)
//                senderAudioCell.customSlider.maximumValue = Float(seconds)
//                senderAudioCell.customSlider.isContinuous = true
//                senderAudioCell.customSlider.tintColor = AppColors.appRedColor
//                senderAudioCell.timeLbl.text = self.stringFromTimeInterval(interval: seconds)
                       
//                       lblcurrentText.text = self.stringFromTimeInterval(interval: seconds1)
                       
//                       player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
//                           if self.player!.currentItem?.status == .readyToPlay {
//                               let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
//                               senderAudioCell.customSlider.value = Float ( time );
//
//                //               self.lblcurrentText.text = self.stringFromTimeInterval(interval: time)
//                           }
//
//                           let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
//                           if playbackLikelyToKeepUp == false{
//                               print("IsBuffering")
//                               senderAudioCell.playBtn.isHidden = false
//                //               self.loadingView.isHidden = false
//                           } else {
//                               //stop the activity indicator
//                               print("Buffering completed")
//                               senderAudioCell.playBtn.isHidden = false
//                //               self.loadingView.isHidden = true
//                           }
//                        }
                
                return senderAudioCell
            default:
                let senderCell = tableView.dequeueCell(with: SenderMessageCell.self)
                senderCell.configureCellWith(model: model)
                senderCell.senderImgView.setImage_kf(imageString: userImage, placeHolderImage: #imageLiteral(resourceName: "placeHolder"), loader: false)
                senderCell.senderImgView.addGestureRecognizer(imgTap)
                return senderCell
            }
        }
    }

    private func reloadTableViewToBottom() {
        messagesTableView.reloadData()
        self.view.layoutIfNeeded()
        scrollMsgToBottom()
    }

    private func scrollMsgToBottom() {
        guard messageListing.endIndex > 0, messageListing[messageListing.endIndex - 1].endIndex > 0 else { return }
        messagesTableView.scrollToRow(at: IndexPath(row: messageListing[messageListing.endIndex - 1].endIndex - 1, section: messageListing.endIndex - 1), at: .bottom, animated: true)
    }
}

//MARK: IMAGE PICKER DELEGATES
//============================
extension OneToOneChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate , RemovePictureDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        hasImageUploaded = false
        image?.upload(progress: { [weak self] (status) in
        guard let `self` = self else { return }
        printDebug(status)
             if !self.hasImageUploaded { CommonFunctions.showToastWithMessage("\(Int(status * 100))% Uploaded") }
        }, completion: { (response,error) in
            if let url = response {
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
    
}

//    // Long Press Gesture to delete message
    func setupLongPressGesture(view: UIView, indexPath: IndexPath) {
//        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
//        longPressGesture.minimumPressDuration = 1.0 // 1 second press
//        view.addGestureRecognizer(longPressGesture)
    }
//
//    func setTapGesture(view: UIView, indexPath: IndexPath) {
//        let longPressGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
//        view.addGestureRecognizer(longPressGesture)
//    }
//
//    func openImageViewer(indexPath: IndexPath) {
//        let message = messageListing[indexPath.section][indexPath.row]
//        guard message.messageType == MessageType.image.rawValue else { return }
//        if let tableViewCell = messagesTableView.cellForRow(at: indexPath) as? ReceiverMediaCell {
//            AppRouter.presentImageViewerVC(self, image: tableViewCell.mediaImageView.image, imageURL: message.mediaUrl)
//        }
//        if let tableViewCell = messagesTableView.cellForRow(at: indexPath) as? SenderMediaCell {
//            AppRouter.presentImageViewerVC(self, image: tableViewCell.mediaImageView.image, imageURL: message.mediaUrl)
//        }
//        print(message.mediaUrl)
//    }
//
//    @objc func tapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
//
//        guard let indexPath = self.messagesTableView.indexPath(forItem: gestureRecognizer.view ?? UIView()) else { return }
//        guard !selectedIndexPaths.isEmpty else {
//            openImageViewer(indexPath: indexPath)
//            return
//        }
//        guard selectedIndexPaths.contains(indexPath) else {
//            if let messageCell = self.messagesTableView.cellForRow(at: indexPath) as? ReceiverMessageCell {
//                messageCell.msgContainerView.backgroundColor = AppColors.blackColor
//                messageCell.msgLabel.textColor = AppColors.whiteColor
//                self.selectedIndexPaths.append(indexPath)
//                self.checkDeletBtnState()
//            }
//            if let imageCell = self.messagesTableView.cellForRow(at: indexPath) as? ReceiverMediaCell {
//                imageCell.msgContainerView.backgroundColor = AppColors.blackColor
//                self.selectedIndexPaths.append(indexPath)
//                self.checkDeletBtnState()
//            }
//            if let videoCell = self.messagesTableView.cellForRow(at: indexPath) as? ReceiverVideoCell {
//                videoCell.msgContainerView.backgroundColor = AppColors.blackColor
//                self.selectedIndexPaths.append(indexPath)
//                self.checkDeletBtnState()
//            }
//            printDebug(self.selectedIndexPaths)
//            return
//        }
//        if let messageCell = self.messagesTableView.cellForRow(at: indexPath) as? ReceiverMessageCell {
//            messageCell.msgContainerView.backgroundColor = AppColors.blueChatBubble
//            messageCell.msgLabel.textColor = AppColors.darkGreyColorTwo
//            self.selectedIndexPaths.removeAll { (index) -> Bool in
//                return index == indexPath
//            }
//            self.checkDeletBtnState()
//        }
//        if let imageCell = self.messagesTableView.cellForRow(at: indexPath) as? ReceiverMediaCell {
//            imageCell.msgContainerView.backgroundColor = AppColors.blueChatBubble
//            self.selectedIndexPaths.removeAll { (index) -> Bool in
//                return index == indexPath
//            }
//            self.checkDeletBtnState()
//        }
//        if let videoCell = self.messagesTableView.cellForRow(at: indexPath) as? ReceiverVideoCell {
//            videoCell.msgContainerView.backgroundColor = AppColors.blueChatBubble
//            self.selectedIndexPaths.removeAll { (index) -> Bool in
//                return index == indexPath
//            }
//            self.checkDeletBtnState()
//        }
//        printDebug(self.selectedIndexPaths)
//    }
//
//    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
//
//        if gestureRecognizer.state == .began {
//            guard let indexPath = self.messagesTableView.indexPath(forItem: gestureRecognizer.view ?? UIView()) else { return }
//            if let messageCell = self.messagesTableView.cellForRow(at: indexPath) as? ReceiverMessageCell {
//                messageCell.msgContainerView.backgroundColor = AppColors.blackColor
//                messageCell.msgLabel.textColor = AppColors.whiteColor
//                self.selectedIndexPaths.append(indexPath)
//                self.checkDeletBtnState()
//            }
//            if let imageCell = self.messagesTableView.cellForRow(at: indexPath) as? ReceiverMediaCell {
//                imageCell.msgContainerView.backgroundColor = AppColors.blackColor
//                self.selectedIndexPaths.append(indexPath)
//                self.checkDeletBtnState()
//            }
//            if let videoCell = self.messagesTableView.cellForRow(at: indexPath) as? ReceiverVideoCell {
//                videoCell.msgContainerView.backgroundColor = AppColors.blackColor
//                self.selectedIndexPaths.append(indexPath)
//                self.checkDeletBtnState()
//            }
//            printDebug(self.selectedIndexPaths)
//        }
//    }
//
//    // Delete full chat
//    private func deleteFullChat() {
//        db.collection(ApiKey.inbox).document(currentUserId).collection(ApiKey.chat).document(inboxModel.userId).delete { [weak self] (error) in
//                guard let `self` = self else { return }
//                if let err = error {
//                    self.showAlert(msg: err.localizedDescription)
//                    printDebug("Error removing document: \(err)")
//                } else {
//                    self.popToInboxView()
//                    printDebug("Document successfully removed!")
//                }
//        }
//    }
//
//    // Delete selected messages
//    func deleteMessages() {
//        selectedIndexPaths.sort()
//        selectedIndexPaths.reverse()
//        for index in selectedIndexPaths {
//            let id = self.messageListing[index.section][index.row].messageId
//            self.db.collection(ApiKey.messages).document(self.getRoomId()).collection(ApiKey.chat).document(id).delete() { (err) in
//                if let err = err {
//                    printDebug("Error removing document: \(err)")
//                } else {
//                    printDebug("Document successfully removed!")
//                }
//            }
//        }
//    }
//
//}
//

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
        db.collection(ApiKey.inbox)
            .document(inboxModel.userId)
            .collection(ApiKey.chat)
            .document(currentUserId)
            .getDocument { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else{
                    print("============================")
                    guard let data = snapshot?.data() else { return }
                    print(data[ApiKey.unreadMessages] as? Int ?? 0)
                    self.inboxModel.unreadMessages = data[ApiKey.unreadMessages] as? Int ?? 0
                    FirestoreController.updateUnreadMessages(senderId: self.currentUserId, receiverId: self.inboxModel.userId, unread: data[ApiKey.unreadMessages] as? Int ?? 0)
                }
        }
    }

    private func restoreDeletedNode() {
        db.collection(ApiKey.inbox)
            .document(currentUserId)
            .collection(ApiKey.chat)
            .document(inboxModel.userId)
            .setData([ApiKey.chatType: ApiKey.single,
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

    db.collection(ApiKey.inbox).document(inboxModel.userId).collection(ApiKey.chat).document(currentUserId).getDocument { (doc, error) in
            if let document = doc {
                if !document.exists {
                    self.db.collection(ApiKey.inbox)
                        .document(self.inboxModel.userId)
                        .collection(ApiKey.chat)
                        .document(self.currentUserId)
                        .setData([ApiKey.chatType: ApiKey.single,
                                  ApiKey.roomId:self.roomId,
                                  ApiKey.roomInfo: self.db.collection(ApiKey.roomInfo).document(self.roomId),
                                  ApiKey.timeStamp: FieldValue.serverTimestamp(),
                                  ApiKey.lastMessage: self.db.collection(ApiKey.lastMessage).document(self.roomId).collection(ApiKey.chat).document(ApiKey.message),
                                  ApiKey.userDetails: self.db.collection(ApiKey.users).document(self.currentUserId),
                                  ApiKey.unreadMessages: self.inboxModel.unreadMessages + 1])
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
            .setData([ApiKey.chatType: ApiKey.single,
                      ApiKey.roomId:roomId,
                      ApiKey.roomInfo: db.collection(ApiKey.roomInfo).document(roomId),
                      ApiKey.timeStamp: FieldValue.serverTimestamp(),
                      ApiKey.lastMessage: db.collection(ApiKey.lastMessage).document(roomId).collection(ApiKey.chat).document(ApiKey.message),
                      ApiKey.userDetails: db.collection(ApiKey.users).document(currentUserId),
                      ApiKey.unreadMessages: inboxModel.unreadMessages + 1])
            { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("success")
                }
        }

        db.collection(ApiKey.inbox)
            .document(currentUserId)
            .collection(ApiKey.chat)
            .document(inboxModel.userId)
            .setData([ApiKey.chatType: ApiKey.single,
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
        if !isRoom {
            FirestoreController.updateUnreadMessages(senderId: currentUserId, receiverId: inboxModel.userId, unread: 0)
        }
    }


    /// Mark:- Fetch the last message from a blocked user
    private func getLastMessageBeforeBlock(){

        let uid = AppUserDefaults.value(forKey: .uid).string ?? ""
        let listener = db.collection(ApiKey.inbox).document(uid).collection(ApiKey.chat).addSnapshotListener { querySnapshot, error in
            querySnapshot?.documentChanges.forEach({ (newUser) in
                let inbox = Inbox(newUser.document.data())
                if newUser.type == .added{
                    inbox.lastMessageRef?.getDocument(completion: { (document, error) in
                        FirestoreController.createLastMessageOfBlockedUser(roomId: self.roomId, senderId: self.currentUserId, messageModel: (document?.data())! )
                    })

                } else if newUser.type == .modified {

                }
                else if newUser.type == .removed {

                } else {

                }
            })
        }
        listeners.append(listener)
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
    private func createMessage(){
        FirestoreController.createLastMessageNode(roomId:roomId,messageText:messageTextView.text.byRemovingLeadingTrailingWhiteSpaces ,messageTime:FieldValue.serverTimestamp(), messageId:getMessageId(),messageType:"text", messageStatus:1,senderId:currentUserId,receiverId:inboxModel.userId, mediaUrl: "",blocked:false, thumbNailURL: "")
        FirestoreController.createMessageNode(roomId:roomId,messageText:messageTextView.text.byRemovingLeadingTrailingWhiteSpaces ,messageTime:FieldValue.serverTimestamp(), messageId:getMessageId(),messageType:"text", messageStatus:1,senderId:currentUserId,receiverId:inboxModel.userId, mediaUrl: "",blocked:false, thumbNailURL: "")

    }

    private func createMediaMessage(url: String, imageURL: String = "", type: String) {
        FirestoreController.createMessageNode(roomId: self.roomId, messageText: "", messageTime: FieldValue.serverTimestamp(), messageId: self.getMessageId(), messageType: type, messageStatus: 1, senderId: self.currentUserId, receiverId: self.inboxModel.userId, mediaUrl: url, blocked: false, thumbNailURL: imageURL)
        let attachmentText = type == MessageType.image.rawValue ? "Photo Attachment" : "Audio Attachment"
        FirestoreController.createLastMessageNode(roomId: self.roomId, messageText: attachmentText, messageTime: FieldValue.serverTimestamp(), messageId: self.getMessageId(), messageType: type, messageStatus: 1, senderId: self.currentUserId, receiverId: self.inboxModel.userId, mediaUrl: url, blocked: false, thumbNailURL: imageURL)
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
        db.collection(ApiKey.inbox).document(inboxModel.userId).collection(ApiKey.chat).document(currentUserId).updateData([ApiKey.timeStamp : FieldValue.serverTimestamp()])
        db.collection(ApiKey.inbox).document(currentUserId).collection(ApiKey.chat).document(inboxModel.userId).updateData([ApiKey.timeStamp : FieldValue.serverTimestamp()])
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
        let userTypingStatus: [String: Any] = [currentUserId:"true",
                                               inboxModel.userId:"true"]

        let roomImageURL = "https://console.firebase.google.com"

        /// Mark:- Parameter dictionary of the user details
        let _ : [String: Any] = [ApiKey.roomId : roomId,
                                          ApiKey.roomImage: roomImageURL,
                                          ApiKey.roomName:"",
                                          ApiKey.roomType:"single",
                                          ApiKey.userInfo: userInfoDict,
                                          ApiKey.userTypingStatus: userTypingStatus]

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
                            self.deleteTime = time
                        }
                    }
                    self.fetchMessageListing()
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
                    if !message.blocked {
                        if message.senderId == self.inboxModel.userId {                            self.db.collection(ApiKey.messages).document(self.getRoomId()).collection(ApiKey.chat).document(message.messageId).updateData([ApiKey.messageStatus : 2]) { (error) in
                                if let err = error {
                                    print(err.localizedDescription)
                                } else {
//                                self.db.collection(ApiKey.inbox).document(self.currentUserId).collection(ApiKey.chat).document(self.inboxModel.userId).updateData([ApiKey.unreadMessages: 0])
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
                    }
                    DispatchQueue.main.async {
                        self.reloadTableViewToBottom()
                    }
                }
                else if newMessage.type == .modified {
                    let message = Message(newMessage.document.data())
                    if !message.blocked  {
                        if message.senderId == self.inboxModel.userId {                            self.db.collection(ApiKey.messages).document(self.getRoomId()).collection(ApiKey.chat).document(message.messageId).updateData([ApiKey.messageStatus : 2]) { (error) in
                                if let err = error {
                                    print(err.localizedDescription)
                                } else {
//                                self.db.collection(ApiKey.inbox).document(self.currentUserId).collection(ApiKey.chat).document(self.inboxModel.userId).updateData([ApiKey.unreadMessages: 0])
                                }
                            }
                        }
                        for (off, section) in self.messageListing.enumerated() {
                            if let msgIndex = section.firstIndex(where: {$0.messageId == message.messageId}) {
                                self.messageListing[off][msgIndex] = message
                                break
                            }
                        }
                    }
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

            printDebug(self.messageListing.last)
        db.collection(ApiKey.lastMessage).document(roomId).collection(ApiKey.chat).document(ApiKey.message).updateData([ApiKey.messageTime: self.messageListing[section].last?.messageTime ?? Timestamp(), ApiKey.messageText: self.messageListing[section].last?.messageText ?? ""])

            let lastMessageReference = db.collection(ApiKey.lastMessage).document(roomId).collection(ApiKey.chat).document(ApiKey.message)

        db.collection(ApiKey.inbox)
            .document(inboxModel.userId)
            .collection(ApiKey.chat)
            .document(currentUserId).updateData([ApiKey.lastMessage : lastMessageReference, ApiKey.timeStamp: FieldValue.serverTimestamp()])

        db.collection(ApiKey.inbox)
            .document(currentUserId)
            .collection(ApiKey.chat)
            .document(inboxModel.userId).updateData([ApiKey.lastMessage : lastMessageReference, ApiKey.timeStamp: FieldValue.serverTimestamp()])

    }

    private func startReceiverBlockListener() {
        db.collection(ApiKey.block).document(currentUserId).getDocument { [weak self] (snapshot, error) in
            guard let `self` = self else { return }
            if let err = error {
                print(err.localizedDescription)
            } else {
                if let data = snapshot?.data() {
//                    self.isBlockedByMe = data.keys.contains(self.inboxModel.userId)
                }
            }
        }
    }

    private func startSenderBlockListener() {
        let listener = db.collection(ApiKey.block).document(inboxModel.userId).addSnapshotListener { [weak self] (snapshot, error) in
            guard let `self` = self else { return }
            if let err = error {
                print(err.localizedDescription)
            } else {
                if let data = snapshot?.data() {
//                    self.amIBlocked = data.keys.contains(self.currentUserId)
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
            
//            recordButton.setTitle("Tap to Stop", for: .normal)
//            playButton.isEnabled = false
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
//            recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
//            recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
        
//        playButton.isEnabled = true
//        recordButton.isEnabled = true
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
        endTimer()
        if flag {
            UIImage().uploadAudioFile(audioUrl: recorder.url, progress: { [weak self] (status) in
            guard let `self` = self else { return }
            printDebug(status)
                 if !self.hasImageUploaded { CommonFunctions.showToastWithMessage("\(Int(status * 100))% Uploaded") }
            }, completion: { (response,error) in
                if let url = response {
                    self.hasImageUploaded = true
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
        }else {
             finishRecording(success: false)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        recordButton.isEnabled = true
//        playButton.setTitle("Play", for: .normal)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
    
    
    private func startTimer() {
           timerLbl.isHidden = false
           timerView.isHidden = false
           viewModel.totalTime = 00
           viewModel.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
       }
       @objc private func updateTime() {
           let time  = "\(viewModel.timeFormatted(viewModel.totalTime))"
           timerLbl.text = time
           if viewModel.totalTime != 120 {
               viewModel.totalTime += 1
           } else {
               endTimer()
               self.audioBtn.isEnabled = true
           }
       }
       
    private func endTimer() {
        timerLbl.isHidden = true
        timerView.isHidden = true
        viewModel.countdownTimer.invalidate()
    }
       
}
