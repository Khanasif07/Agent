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
//        self.setupCollectionView()
//        emptyContainerView.isHidden = true
        viewModel.delegate = self
        viewAllBtn.isEnabled = true
        [tyreSizeValueLbl,unitValueLblb,brandsValueLbl].forEach({$0?.textColor = AppColors.fontTertiaryColor})
        tyreSizeLbl.text = LocalizedString.tyreSize.localized + ":"
        unitValueLblb.text = "Unit:"
        brandsLbl.text = LocalizedString.brands.localized
        titleLbl.text =  self.viewModel.serviceType == "Tyres" ? "Tyre Service Request" : self.viewModel.serviceType == "Battery" ? "Battery Service Request" : "Oil Service Request"
        tyreSizeLbl.text = self.viewModel.serviceType == "Tyres" ? "Tyre Size:" : "Vehicle Details:"
        productImgView.isHidden = self.viewModel.serviceType == "Tyres"
        let logoBackGroundColor =  self.viewModel.serviceType == "Tyres" ? AppColors.blueLightColor : self.viewModel.serviceType == "Battery" ? AppColors.redLightColor : AppColors.grayLightColor
        self.productImgView.backgroundColor = logoBackGroundColor
        viewModel.getUserMyRequestDetailData(params: [ApiKey.requestId: self.viewModel.requestId])
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
        requestNoValueLbl.text = "#" + "\(self.viewModel.userRequestDetail.requestID)"
        self.brandsArray = self.viewModel.userRequestDetail.preferredBrands.map({ (model) -> String in
            model.name
        })
        self.countryArray = self.viewModel.userRequestDetail.preferredCountries.map({ (model) -> String in
            model.name
        })
        let model = self.viewModel.userRequestDetail
        let logoImg =  model.requestType == "Tyres" ? #imageLiteral(resourceName: "radialCarTireI151") : model.requestType == "Battery" ? #imageLiteral(resourceName: "icBattery") : #imageLiteral(resourceName: "icOil")
        self.mainImgView.image = logoImg
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
        //
        if self.viewModel.serviceType == "Tyres"{
            tyreSizeValueLbl.text = "\(model.width ?? 0)W " + "\(model.rimSize ?? 0)R " + "\(model.profile ?? 0)P"
        } else{
            tyreSizeValueLbl.text  =  "\(model.make ?? "") " + "\(model.model ?? "") " + "\(model.year ?? 0)"
        }
        unitValueLblb.text = "\(model.quantity ?? 0)"
        brandsLbl.text = brandsArray.endIndex > 0 ? "Brands:" : "Countries:"
        brandsValueLbl.text = brandsArray.endIndex > 0 ? brandsArray.joined(separator: ",") : countryArray.joined(separator: ",")
        productImgView.setImage_kf(imageString: model.images.first ?? "", placeHolderImage: logoImg, loader: false)
        //
    }
    
    func getUserMyRequestDetailFailed(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
}
