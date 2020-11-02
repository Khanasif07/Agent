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
//    var viewModel = OneToOneChatViewModel()
    weak var delegate: SetLastMessageDelegate?

    private let db = Firestore.firestore()

    var inboxModel = Inbox()
    var firstName = ""
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
        let touchLocation = touch.location(in: self.view)
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        popToInboxView()
    }

    @IBAction func addAttachmentsButtonTapped(_ sender: UIButton) {
//        createMediaAlertSheet()
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
//        getBatchCount()
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


//    private func createMediaAlertSheet() {
//
////        let chooseOptionText = LocalizedString.K_CHOOSE_HOW_TO_SELECT_IMAGE.localized
//        alertController = UIAlertController(title: "chooseOptionText", message: nil, preferredStyle: .actionSheet, blurStyle: .dark)
////        alertController = UIAlertController(title: chooseOptionText, message: nil, preferredStyle: .actionSheet)
////        alertController.view.backgroundColor = .black
//        let chooseFromGalleryText =  LocalizedString.gallery.localized
//        let alertActionGallery = UIAlertAction(title: chooseFromGalleryText, style: .default) { _ in
//            ImagePicker.shared.imagePickerDelegate = self
//            ImagePicker.shared.checkAndOpenLibraryForPhotosAndVideo(on: self)
//        }
//        alertController.addAction(alertActionGallery)
//
//        let takePhotoText =  LocalizedString.camera.localized
//        let alertActionCamera = UIAlertAction(title: takePhotoText, style: .default) { action in
//            self.checkCameraAccess()
//        }
//        alertController.addAction(alertActionCamera)
//
//        let cancelText =  LocalizedString.cancel.localized
//        let alertActionCancel = UIAlertAction(title: cancelText, style: .cancel) { _ in
//        }
//        alertController.addAction(alertActionCancel)
//
//        self.present(alertController, animated: true, completion: nil)
//    }

    private func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
             presentCamera()
//            ImagePicker.shared.alertPromptToAllowCameraAccessViaSetting(LocalizedString.Please_change_your_privacy_setting_from_the_Settings_app_and_allow_access_to_library_for.localized, controller: self)
        case .restricted:
             presentCamera()
//            ImagePicker.shared.alertPromptToAllowCameraAccessViaSetting(LocalizedString.You_have_been_restricted_from_using_the_camera_on_this_device_without_camera_access_this_feature_wont_work.localized, controller: self)
        case .authorized:
            presentCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] success in
                guard let `self` = self else { return }
                if success {
                    self.presentCamera()
                } else {
//                    ImagePicker.shared.alertPromptToAllowCameraAccessViaSetting(LocalizedString.You_have_been_restricted_from_using_the_camera_on_this_device_without_camera_access_this_feature_wont_work.localized, controller: self)
                }
            }
        @unknown default:
            break
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
//        messagesTableView.registerCell(with: SenderMediaCell.self)
//        messagesTableView.registerCell(with: ReceiverMediaCell.self)
//        messagesTableView.registerCell(with: ReceiverVideoCell.self)
//        messagesTableView.registerCell(with: SenderVideoCell.self)
//        messagesTableView.registerCell(with: DayValueCell.self)
    }

    private func setupTextView() {
        titleLabel.text = firstName
        messageTextView.delegate = self
        messageTextView.tintColor = AppColors.appRedColor
    }

    private func sendMessage() {
//        self.view.endEditing(true)
        let txt = self.messageTextView.text.byRemovingLeadingTrailingWhiteSpaces
        guard !txt.isEmpty else { return }
            if isRoom {
                self.updateUnreadMessage()
                self.restoreDeletedNode()
                self.createMessage()
                self.updateInboxTimeStamp()
//                self.createBatch()
            } else {
                self.createRoom()
                self.createMessage()
                self.createInbox()
//                self.createBatch()
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

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let dayCell = tableView.dequeueCell(with: DayValueCell.self)
//        let dateVal =  messageListing[section].first?.messageTime.dateValue() ?? Date()
//        if dateVal.isToday {
//            dayCell.dateLabel.text = "Today"
//        } else if dateVal.isYesterday {
//            dayCell.dateLabel.text = "Yesterday"
//        } else {
//            dayCell.dateLabel.text = dateVal.convertToString()
//        }
//        return dayCell
//    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = messageListing[indexPath.section][indexPath.row]
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(titleLabelTapped(_:)))
        switch model.receiverId {
        case AppUserDefaults.value(forKey: .uid).stringValue:
            switch model.messageType {
//            case MessageType.image.rawValue:
//                let senderMediaCell = tableView.dequeueCell(with: SenderMediaCell.self)
//                senderMediaCell.configureCellWith(model: model)
//                senderMediaCell.senderImageView.sd_setImage(with: URL(string: userImage), placeholderImage: #imageLiteral(resourceName: StringConstants.eventImagePlaceHolder) , completed: nil)
//                setTapGesture(view: senderMediaCell.msgContainerView, indexPath: indexPath)
//                senderMediaCell.senderImageView.addGestureRecognizer(imgTap)
//                return senderMediaCell
//            case MessageType.video.rawValue:
//                let senderVideoCell = tableView.dequeueCell(with: SenderVideoCell.self)
//                senderVideoCell.configureCellWith(model: model)
//                senderVideoCell.playButton.addTarget(self, action: #selector(playVideo(_:)), for: .touchUpInside)
//                senderVideoCell.senderImageView.sd_setImage(with: URL(string: userImage), placeholderImage: #imageLiteral(resourceName: StringConstants.eventImagePlaceHolder) , completed: nil)
//                senderVideoCell.senderImageView.addGestureRecognizer(imgTap)
//                return senderVideoCell
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
//            case MessageType.image.rawValue:
//                let receiverMediaCell = tableView.dequeueCell(with: ReceiverMediaCell.self)
//                receiverMediaCell.configureCellWith(model: model)
//                self.setupLongPressGesture(view: receiverMediaCell.msgContainerView, indexPath: indexPath)
//                self.setTapGesture(view: receiverMediaCell.msgContainerView, indexPath: indexPath)
//                receiverMediaCell.msgContainerView.backgroundColor = selectedIndexPaths.contains(indexPath) ? AppColors.blackColor : AppColors.blueChatBubble
//                return receiverMediaCell
//            case MessageType.video.rawValue:
//                let receiverVideoCell = tableView.dequeueCell(with: ReceiverVideoCell.self)
//                receiverVideoCell.configureCellWith(model: model)
//                receiverVideoCell.playButton.addTarget(self, action: #selector(playVideo(_:)), for: .touchUpInside)
//                self.setupLongPressGesture(view: receiverVideoCell.msgContainerView, indexPath: indexPath)
//                self.setTapGesture(view: receiverVideoCell.msgContainerView, indexPath: indexPath)
//                receiverVideoCell.msgContainerView.backgroundColor = selectedIndexPaths.contains(indexPath) ? AppColors.blackColor : AppColors.blueChatBubble
//                return receiverVideoCell
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

////MARK: IMAGE PICKER DELEGATES
////============================
//extension OneToOneChatVC: ImagePickerDelegate, UploadMediaDelegate {
//
//    func cancelMediaUpload() {
//        return
//    }
//
//    func upload(isImage: Bool, image: UIImage, videoURL: String) {
//        switch isImage {
//        case true:
//            uploadImageToS3(image: image)
//        case false:
//            uploadToS3(image: image, ifImage: false, video: videoURL.description)
//        }
//    }
//
//    func getSelectedVideoWithThumbnail(image: UIImage, ifImage: Bool, videoURL: String) {
//        dismiss(animated: true, completion: nil)
//        AppRouter.presentUploadMediaPopUp(self, isImage: false, image: image, videoURL: videoURL.description)
////        uploadToS3(image: image, ifImage: false, video: videoURL.description)
//
//    }
//
//    func getSelectedImage(capturedImage image: UIImage) {
//        dismiss(animated: true, completion: nil)
//        AppRouter.presentUploadMediaPopUp(self, isImage: true, image: image, videoURL: "")
////        uploadImageToS3(image: image)
//    }
//
//    func imagePickerControllerDidCancel() {
//        dismiss(animated: true, completion: nil)
//    }
//
//    func removeImage() { }
//
//}


////MARK: IMAGE CROPPER DELEGATES
////=============================
//extension OneToOneChatVC: CropperDelegate {
//
//    private func uploadImageToS3(image: UIImage) {
//        let url = "\(Int(Date().timeIntervalSince1970)).png"
//        let imageURL = "\(S3_BASE_URL)\(BUCKET_NAME)/\(url)"
//
//        hasImageUploaded = false
//        self.updateData(image: imageURL)
//
//        image.uploadImageToS3(imageurl: url ,success: { [weak self] (success, url) in
//
//            guard let `self` = self else { return }
//            self.hasImageUploaded = true
//            ToastCenter.default.cancelAll()
//            if self.isBlockedByMe {
//                self.showAlert(msg: StringConstants.UnblockUserMessage)
//            } else {
//                if self.isRoom {
//                    self.updateUnreadMessage()
//                    self.restoreDeletedNode()
//                    self.createMediaMessage(url: url, imageURL: url, type: StringConstants.image)
//                    self.updateInboxTimeStamp()
////                    self.createBatch()
//                } else {
//                    self.createRoom()
//                    self.createMediaMessage(url: url, imageURL: url, type: StringConstants.image)
//                    self.createInbox()
////                    self.createBatch()
//                }
//            }
//            }, progress: { [weak self] (status) in
//                guard let `self` = self else { return }
//                printDebug(status)
//                if !self.hasImageUploaded { CommonFunctions.showToastWithMessage("\(Int(status * 100))% Uploaded") }
//            }, failure: { [weak self] (error) in
//                guard let `self` = self else { return }
//                self.showAlert(msg: error.localizedDescription)
//                self.removeImage()
//                self.hasImageUploaded = true
//        })
//    }

//    func imageCropper(didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
//        let url = "\(Int(Date().timeIntervalSince1970)).png"
//        let imageURL = "\(S3_BASE_URL)\(BUCKET_NAME)/\(url)"
//
//        hasImageUploaded = false
//        self.updateData(image: imageURL)
//
//        croppedImage.uploadImageToS3(imageurl: url ,success: { [weak self] (success, url) in
//
//            guard let `self` = self else { return }
//            self.hasImageUploaded = true
//            ToastCenter.default.cancelAll()
//            if self.isBlockedByMe {
//                self.showAlert(msg: StringConstants.UnblockUserMessage)
//            } else {
//                if self.isRoom {
//                    self.updateUnreadMessage()
//                    self.restoreDeletedNode()
//                    self.createMediaMessage(url: url, imageURL: url, type: StringConstants.image)
//                    self.updateInboxTimeStamp()
////                    self.createBatch()
//                } else {
//                    self.createRoom()
//                    self.createMediaMessage(url: url, imageURL: url, type: StringConstants.image)
//                    self.createInbox()
////                    self.createBatch()
//                }
//            }
//            }, progress: { [weak self] (status) in
//                guard let `self` = self else { return }
//                printDebug(status)
//                if !self.hasImageUploaded { CommonFunctions.showToastWithMessage("\(Int(status * 100))% Uploaded") }
//            }, failure: { [weak self] (error) in
//                guard let `self` = self else { return }
//                self.showAlert(msg: error.localizedDescription)
//                self.removeImage()
//                self.hasImageUploaded = true
//        })
//    }

//    func imageCropperDidCancelCrop() {
//        printDebug("Crop cancelled")
//    }
//
//    fileprivate func updateData(image: String) {
////        parametersDict[ApiKey.image] = image
//    }

//}

//MARK: IMAGEPICKER CONTEROLLER DELEGATE
//======================================
//extension OneToOneChatVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        if let choosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
//            AppRouter.presentUploadMediaPopUp(self, isImage: true, image: choosenImage, videoURL: "")
////            uploadImageToS3(image: choosenImage)
////            Cropper.shared.openCropper(withImage: choosenImage, mode: .square, on: self)
//        }
//
//        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
//            AVAsset(url: videoURL).generateThumbnail { [weak self] (image) in
//                DispatchQueue.main.async {
//                    guard let `self` = self, let image = image else { return }
//                    AppRouter.presentUploadMediaPopUp(self, isImage: false, image: image, videoURL: videoURL.description)
////                    self.uploadToS3(image: image, ifImage: false, video: videoURL.description)
//                }
//            }
//        }
//        self.dismiss(animated: true, completion: nil)
//
//    }


//    func uploadToS3(image: UIImage, ifImage: Bool, video: String = ""){
//        guard let url = URL(string: video) else {
//            showAlert(msg: "Video couldn't be uploaded!")
//            return
//        }
//        hasImageUploaded = false
//        let iurl = "\(Int(Date().timeIntervalSince1970)).png"
//
//        image.uploadImageToS3(imageurl: iurl,success: { [weak self] (complete, imageURL) in
//            guard let `self` = self else { return }
//            AWSController.uploadTOS3Video(url: url, success: { [weak self] (completion, url) in
//                guard let `self` = self else { return }
//                self.hasImageUploaded = true
//                if self.isBlockedByMe {
//                    self.showAlert(msg: StringConstants.UnblockUserMessage)
//                } else {
//                    if self.isRoom {
//                        self.updateUnreadMessage()
//                        self.restoreDeletedNode()
//                        self.createMediaMessage(url: url, imageURL: imageURL, type: StringConstants.video)
//                        self.updateInboxTimeStamp()
////                        self.createBatch()
//                    } else {
//                        self.createRoom()
//                        self.createMediaMessage(url: url, imageURL: imageURL, type: StringConstants.video)
//                        self.createInbox()
////                        self.createBatch()
//                    }
//                }
//                }, progress: { [weak self] (status) in
//                    guard let `self` = self else { return }
//                    printDebug(status)
//                    if !self.hasImageUploaded { CommonFunctions.showToastWithMessage("\(Int(status * 100))% Uploaded") }
//            }) { [weak self] (error) in
//                guard let `self` = self else { return }
//                self.hasImageUploaded = true
//                self.showAlert(msg: error.localizedDescription)
//            }
//        }, progress: { (status) in
//            print(status)
//        }) { [weak self] (error) in
//            guard let `self` = self else { return }
//            self.showAlert(msg: error.localizedDescription)
//            self.removeImage()
//            self.hasImageUploaded = true
//        }
//
//    }
//
//    private func setupVideoTap(view: UIImageView, indexPath: IndexPath) {
//        let videoTap = UITapGestureRecognizer(target: self, action: #selector(playVideoFromTap(_:)))
//        view.isUserInteractionEnabled = true
//        view.addGestureRecognizer(videoTap)
//    }
//
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
//    // To hide/unhide delete Button
//    func checkDeletBtnState() {
//        if self.selectedIndexPaths.isEmpty {
//            self.deleteMsgBtn.isHidden = true
//        } else {
//            self.deleteMsgBtn.isHidden = false
//        }
//    }
//
//    func showDeleteAlert() {
//        AppRouter.presentDeleteChatPopUp(self, deleteChat: false, userId: "")
//    }
//
//    private func showDeleteChatAlert() {
//        AppRouter.presentDeleteChatPopUp(self, deleteChat: true, userId: inboxModel.userId)
//    }
//
//    private func blockUser() {
//        AppRouter.presentBlockUserPopUp(self, toBlock: !isBlockedByMe)
//    }
//
//    private func hitBlockUserAPI() {
//        if isBlockedByMe {
//            viewModel.blockUnblockUser(parameters: [ApiKey.userId: inboxModel.userId,
//                                                    ApiKey.status: "unblock"])
//        } else {
//            viewModel.blockUnblockUser(parameters: [ApiKey.userId: inboxModel.userId,
//                                                    ApiKey.status: "block"])
//        }
//    }
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
        db.collection(ApiKey.inbox)
            .document(inboxModel.userId)
            .collection(ApiKey.chat)
            .document(currentUserId)
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
        let attachmentText = type == MessageType.image.rawValue ? "Photo Attachment" : "Video Attachment"
        FirestoreController.createLastMessageNode(roomId: self.roomId, messageText: attachmentText, messageTime: FieldValue.serverTimestamp(), messageId: self.getMessageId(), messageType: type, messageStatus: 1, senderId: self.currentUserId, receiverId: self.inboxModel.userId, mediaUrl: url, blocked: false, thumbNailURL: imageURL)
    }

    /// Mark:- Fetching the room Id values
    private func getRoomId()-> String{
        if currentUserId < inboxModel.userId {
            self.roomId = currentUserId + "_" + inboxModel.userId
            return self.roomId
        } else {
            self.roomId  = inboxModel.userId + "_" + currentUserId
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
        self.roomId = currentUserId < inboxModel.userId ? currentUserId + "_" + inboxModel.userId : inboxModel.userId + "_" + currentUserId

        AppUserDefaults.save(value: roomId, forKey: .roomId)
        print("sender " + currentUserId,"receiver " + inboxModel.userId,"roomcreated " + roomId)

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

