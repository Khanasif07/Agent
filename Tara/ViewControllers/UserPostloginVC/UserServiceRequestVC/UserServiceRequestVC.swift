//
//  UserServiceRequestVC.swift
//  ArabianTyres
//
//  Created by Admin on 07/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

protocol UserServiceRequestVCDelegate: class {
    func cancelUserMyRequestDetailSuccess(requestId: String)
    func rejectUserMyRequestDetailSuccess(requestId: String)
    func resendUserMyRequestDetailSuccess(requestId: String)
}

extension UserServiceRequestVCDelegate {
    func cancelUserMyRequestDetailSuccess(requestId: String){}
    func rejectUserMyRequestDetailSuccess(requestId: String){}
    func resendUserMyRequestDetailSuccess(requestId: String){}
}

class UserServiceRequestVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
 
    @IBOutlet weak var requestDetailLbl: UILabel!
    @IBOutlet weak var nearestBidLbl: UILabel!
    @IBOutlet weak var lowestBidLbl: UILabel!
    @IBOutlet weak var bidReceivedLbl: UILabel!
    @IBOutlet weak var requestSeenLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var requestSeenValueLbl: UILabel!
    @IBOutlet weak var bidRecivedValueLbl: UILabel!
    @IBOutlet weak var lowestBidValueLbl: UILabel!
    @IBOutlet weak var nearestBidderValueLbl: UILabel!
    @IBOutlet weak var sarLbl: UILabel!
    @IBOutlet weak var cancelBtn: AppButton!
    @IBOutlet weak var viewAllBtn: AppButton!
    @IBOutlet weak var requestNoValueLbl: UILabel!
    @IBOutlet weak var requestNoLbl: UILabel!
    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var brandsValueLbl: UILabel!
    @IBOutlet weak var brandsLbl: UILabel!
    @IBOutlet weak var unitValueLblb: UILabel!
    @IBOutlet weak var unitLbl: UILabel!
    @IBOutlet weak var tyreSizeValueLbl: UILabel!
    @IBOutlet weak var tyreSizeLbl: UILabel!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var countryAndBrandStackView: UIStackView!
    
    // MARK: - Variables
    //===========================
    var viewModel = UserServiceRequestVM()
    var brandsArray = [String]()
    var countryArray = [String]()
    weak var delegate: UserServiceRequestVCDelegate?
    var requestId : String = ""
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewAllBtn.round(radius: 4.0)
        productImgView.round(radius: 4.0)
        self.bottomContainerView.addShadow(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
         self.topContainerView.addShadow(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
    }
       
    // MARK: - IBActions
    //===========================
    @IBAction func cancelRequestBtnAction(_ sender: AppButton) {
        switch cancelBtn.titleLabel?.text {
        case LocalizedString.cancel.localized:
            self.viewModel.cancelUserMyRequestDetailData(params: [ApiKey.requestId: self.viewModel.requestId])
        case LocalizedString.resend.localized:
            self.viewModel.resendRequest(params: [ApiKey.requestId: self.viewModel.requestId])
        default:
            showAlert(msg: "Under Development")
        }
        
    }
    
    @IBAction func viewAllBtnAction(_ sender: AppButton) {
        if viewAllBtn.titleLabel?.text == LocalizedString.viewDetails.localized {
            AppRouter.goToUserServiceStatusVC(vc: self, requestId: viewModel.requestId)
        }else {
            AppRouter.goToUserAllOffersVC(vc: self, requestId: requestId)
            
        }
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func helpBtnAction(_ sender: UIButton) {
        AppRouter.goToOneToOneChatVC(self, userId: AppConstants.adminId, requestId: "", name: LocalizedString.supportChat.localized, image: "", unreadMsgs: 0, isSupportChat: true,garageUserId: isCurrentUserType == .garage ? UserModel.main.id : "" )
       // viewModel.getAdminId(dict: [:], loader: true)
    }
}

// MARK: - Extension For Functions
//===========================
extension UserServiceRequestVC {
    
    private func initialSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(paymentSucessfullyDone), name: Notification.Name.PaymentSucessfullyDone, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userServiceAcceptRejectSuccess), name: Notification.Name.UserServiceAcceptRejectSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestRejected), name: Notification.Name.RequestRejected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newBidSocketSuccess), name: Notification.Name.NewBidSocketSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BidCancelled), name: Notification.Name.BidCancelled, object: nil)
        viewModel.delegate = self
        textSetUp()
        addTapGesture()
        viewModel.getUserMyRequestDetailData(params: [ApiKey.requestId: self.viewModel.requestId])
    }
    
    private func textSetUp(){
        viewAllBtn.isEnabled = true
        [tyreSizeValueLbl,unitValueLblb,brandsValueLbl].forEach({$0?.textColor = AppColors.fontTertiaryColor})
        unitValueLblb.text = LocalizedString.unit.localized + ":"
        brandsLbl.text = LocalizedString.brands.localized
        titleLbl.text =  self.viewModel.serviceType == LocalizedString.tyres.localized ? LocalizedString.tyreServiceRequest.localized: self.viewModel.serviceType == LocalizedString.battery.localized ? LocalizedString.batteryServiceRequest.localized : LocalizedString.oilServiceRequest.localized
        tyreSizeLbl.text = self.viewModel.serviceType == LocalizedString.tyres.localized ? (LocalizedString.tyreSize.localized) : (LocalizedString.vehicleDetails.localized + ":")
        productImgView.isHidden = self.viewModel.serviceType == LocalizedString.tyres.localized
        let logoBackGroundColor =  self.viewModel.serviceType == LocalizedString.tyres.localized ? AppColors.blueLightColor : self.viewModel.serviceType == LocalizedString.battery.localized ? AppColors.redLightColor : AppColors.grayLightColor
        bottomLineView.isHidden = self.viewModel.serviceType == LocalizedString.tyres.localized
        self.productImgView.backgroundColor = logoBackGroundColor
        let logoImg =  self.viewModel.serviceType == LocalizedString.tyres.localized ? #imageLiteral(resourceName: "radialCarTireI151") : self.viewModel.serviceType == LocalizedString.battery.localized ? #imageLiteral(resourceName: "icBattery") : #imageLiteral(resourceName: "icOil")
        requestSeenLbl.text = LocalizedString.requestSeen.localized
        bidReceivedLbl.text = LocalizedString.bidReceived.localized
        lowestBidLbl.text = LocalizedString.lowest_Bid.localized
        nearestBidLbl.text = LocalizedString.nearest_Bid.localized
        requestDetailLbl.text = LocalizedString.request_Detail.localized
        self.mainImgView.image = logoImg
    }
    
    @objc func newBidSocketSuccess(){
        viewModel.getUserMyRequestDetailData(params: [ApiKey.requestId: self.viewModel.requestId])
    }
    
    @objc func requestRejected(){
        viewModel.getUserMyRequestDetailData(params: [ApiKey.requestId: self.viewModel.requestId])
    }
    
    @objc func paymentSucessfullyDone(){
        viewModel.getUserMyRequestDetailData(params: [ApiKey.requestId: self.viewModel.requestId])
    }
    
    func getMiles(meters: Double) -> Double {
         return meters * 0.000621371192
    }
    
    private func addTapGesture(){
        productImgView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTap))
        self.productImgView.addGestureRecognizer(tapGesture)
    }
    
    @objc func singleTap(){
        AppRouter.presentImageViewerVC(self, image: nil, imageURL: self.viewModel.userRequestDetail.images.first ?? "")
    }
    
    @objc func userServiceAcceptRejectSuccess(){
        viewModel.getUserMyRequestDetailData(params: [ApiKey.requestId: self.viewModel.requestId])
    }
    
    @objc func BidCancelled(){
        viewModel.getUserMyRequestDetailData(params: [ApiKey.requestId: self.viewModel.requestId])
    }
}

// MARK: - Extension For UserAllRequestVMDelegate
//===========================
extension UserServiceRequestVC: UserServiceRequestVMDelegate{
    func resendRequsetSuccess(message: String) {
        self.delegate?.resendUserMyRequestDetailSuccess(requestId: self.viewModel.requestId)
        self.pop()
    }
    
    func resendRequsetFailure(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func cancelUserMyRequestDetailSuccess(message: String) {
        self.delegate?.cancelUserMyRequestDetailSuccess(requestId: self.viewModel.requestId)
        self.pop()
    }
    
    func cancelUserMyRequestDetailFailed(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func getUserMyRequestDetailSuccess(message: String) {
        cancelBtn.isBorderSelected = true
        requestId = self.viewModel.userRequestDetail.id
        self.brandsArray = self.viewModel.userRequestDetail.preferredBrands.map({ (model) -> String in
            model.name
        })
        self.countryArray = self.viewModel.userRequestDetail.preferredCountries.map({ (model) -> String in
            model.name
        })
        let model = self.viewModel.userRequestDetail
        viewAllBtn.isHidden = viewModel.userRequestDetail.totalBids == 0
        if viewModel.userRequestDetail.status == .cancelled {
            cancelBtn.isHidden = true
            viewAllBtn.isHidden = true
        }
        if viewModel.userRequestDetail.status == .expired {
            cancelBtn.isHidden = false
            cancelBtn.setTitle(LocalizedString.resend.localized, for: .normal)
            viewAllBtn.isHidden = true
        }
        cancelBtn.isHidden = viewModel.userRequestDetail.isServiceStarted ?? cancelBtn.isHidden
        requestSeenValueLbl.text = viewModel.userRequestDetail.seenBy?.description
        if viewModel.userRequestDetail.lowestBid == 0 {
            lowestBidValueLbl.textColor = AppColors.fontPrimaryColor
            lowestBidValueLbl.text = LocalizedString.no.localized
            sarLbl.isHidden = true
        }else {
            lowestBidValueLbl.textColor = #colorLiteral(red: 0.1725490196, green: 0.7137254902, blue: 0.4549019608, alpha: 1)
            lowestBidValueLbl.text = viewModel.userRequestDetail.lowestBid?.description
        }
        bidRecivedValueLbl.text = viewModel.userRequestDetail.totalBids?.description
        let distance = viewModel.userRequestDetail.nearestBidder ?? 0.0
        nearestBidderValueLbl.text = "\(distance.truncate(places: 2))"
        if self.viewModel.serviceType == LocalizedString.tyres.localized{
            tyreSizeValueLbl.text = "\(model.width ?? 0)W " + "\(model.rimSize ?? 0)R " + "\(model.profile ?? 0)P"
        } else{
            tyreSizeValueLbl.text  =  "\(model.make ?? "") " + "\(model.model ?? "") " + "\(model.year ?? 0)"
        }
        requestNoValueLbl.text = "#" + "\(self.viewModel.userRequestDetail.requestID)"
        unitValueLblb.text = "\(model.quantity ?? 0)"
        brandsLbl.text = brandsArray.endIndex > 0 ? (LocalizedString.brands.localized + ":") : (LocalizedString.countries.localized + ":")
        brandsValueLbl.text = brandsArray.endIndex > 0 ? brandsArray.joined(separator: ",") : countryArray.joined(separator: ",")
        if brandsArray.isEmpty && countryArray.isEmpty {
            countryAndBrandStackView.isHidden = true
        }else {
            countryAndBrandStackView.isHidden = false
        }
        let logoImg =  self.viewModel.serviceType == LocalizedString.tyres.localized ? #imageLiteral(resourceName: "radialCarTireI151") : self.viewModel.serviceType == LocalizedString.battery.localized ? #imageLiteral(resourceName: "icBattery") : #imageLiteral(resourceName: "icOil")
        productImgView.isHidden = model.images.isEmpty
        bottomLineView.isHidden = model.images.isEmpty
        self.productImgView.setImage_kf(imageString: model.images.first ?? "", placeHolderImage: logoImg, loader: false)
        
        if viewModel.userRequestDetail.isServiceStarted ?? false {
            viewAllBtn.isHidden = false
            viewAllBtn.setTitle(LocalizedString.viewDetails.localized, for: .normal)
        }
        if let paymentStatus = viewModel.userRequestDetail.paymentStatus{
            if paymentStatus == .paid{
                cancelBtn.isHidden = true
            }
        }
        
    }
    
    func getUserMyRequestDetailFailed(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func getAdminIdSuccess(id: String, name: String, image: String){
        AppRouter.goToOneToOneChatVC(self, userId: id, requestId: "", name: LocalizedString.supportChat.localized, image: image, unreadMsgs: 0, isSupportChat: true,garageUserId: isCurrentUserType == .garage ? UserModel.main.id : "" )
    }
    
    func getAdminIdFailed(error:String){
        ToastView.shared.showLongToast(self.view, msg: error)
    }
}
