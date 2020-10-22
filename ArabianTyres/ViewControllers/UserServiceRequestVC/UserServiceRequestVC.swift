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
}

class UserServiceRequestVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
 
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
        self.viewModel.cancelUserMyRequestDetailData(params: [ApiKey.requestId:
            self.viewModel.requestId])
    }
    
    @IBAction func viewAllBtnAction(_ sender: AppButton) {
        AppRouter.goToUserAllOffersVC(vc: self, requestId: requestId)
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func helpBtnAction(_ sender: UIButton) {
        showAlert(msg: LocalizedString.underDevelopment.localized)
    }
}

// MARK: - Extension For Functions
//===========================
extension UserServiceRequestVC {
    
    private func initialSetup() {
        viewModel.delegate = self
        textSetUp()
        viewModel.getUserMyRequestDetailData(params: [ApiKey.requestId: self.viewModel.requestId])
    }
    
    private func textSetUp(){
        viewAllBtn.isEnabled = true
        [tyreSizeValueLbl,unitValueLblb,brandsValueLbl].forEach({$0?.textColor = AppColors.fontTertiaryColor})
        unitValueLblb.text = "Unit:"
        brandsLbl.text = LocalizedString.brands.localized
        titleLbl.text =  self.viewModel.serviceType == "Tyres" ? LocalizedString.tyreServiceRequest.localized: self.viewModel.serviceType == "Battery" ? LocalizedString.batteryServiceRequest.localized : LocalizedString.oilServiceRequest.localized
        tyreSizeLbl.text = self.viewModel.serviceType == "Tyres" ? (LocalizedString.tyreSize.localized) : (LocalizedString.vehicleDetails.localized + ":")
        productImgView.isHidden = self.viewModel.serviceType == "Tyres"
        let logoBackGroundColor =  self.viewModel.serviceType == "Tyres" ? AppColors.blueLightColor : self.viewModel.serviceType == "Battery" ? AppColors.redLightColor : AppColors.grayLightColor
        bottomLineView.isHidden = self.viewModel.serviceType == "Tyres"
        self.productImgView.backgroundColor = logoBackGroundColor
        let logoImg =  self.viewModel.serviceType == "Tyres" ? #imageLiteral(resourceName: "radialCarTireI151") : self.viewModel.serviceType == "Battery" ? #imageLiteral(resourceName: "icBattery") : #imageLiteral(resourceName: "icOil")
        self.mainImgView.image = logoImg
    }
}

// MARK: - Extension For UserAllRequestVMDelegate
//===========================
extension UserServiceRequestVC: UserServiceRequestVMDelegate{
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
        requestSeenValueLbl.text = viewModel.userRequestDetail.seenBy?.description
        if viewModel.userRequestDetail.lowestBid == 0 {
            lowestBidValueLbl.textColor = AppColors.fontPrimaryColor
            lowestBidValueLbl.text = "No"
            sarLbl.isHidden = true
        }else {
            lowestBidValueLbl.textColor = #colorLiteral(red: 0.1725490196, green: 0.7137254902, blue: 0.4549019608, alpha: 1)
            lowestBidValueLbl.text = viewModel.userRequestDetail.lowestBid?.description
        }
        bidRecivedValueLbl.text = viewModel.userRequestDetail.totalBids?.description
        nearestBidderValueLbl.text = viewModel.userRequestDetail.nearestBidder?.description
        if self.viewModel.serviceType == "Tyres"{
            tyreSizeValueLbl.text = "\(model.width ?? 0)W " + "\(model.rimSize ?? 0)R " + "\(model.profile ?? 0)P"
        } else{
            tyreSizeValueLbl.text  =  "\(model.make ?? "") " + "\(model.model ?? "") " + "\(model.year ?? 0)"
        }
        requestNoValueLbl.text = "#" + "\(self.viewModel.userRequestDetail.requestID)"
        unitValueLblb.text = "\(model.quantity ?? 0)"
        brandsLbl.text = brandsArray.endIndex > 0 ? (LocalizedString.brands.localized + ":") : (LocalizedString.countries.localized + ":")
        brandsValueLbl.text = brandsArray.endIndex > 0 ? brandsArray.joined(separator: ",") : countryArray.joined(separator: ",")
        let logoImg =  self.viewModel.serviceType == "Tyres" ? #imageLiteral(resourceName: "radialCarTireI151") : self.viewModel.serviceType == "Battery" ? #imageLiteral(resourceName: "icBattery") : #imageLiteral(resourceName: "icOil")
        self.productImgView.setImage_kf(imageString: model.images.first ?? "", placeHolderImage: logoImg, loader: false)
    }
    
    func getUserMyRequestDetailFailed(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
}
