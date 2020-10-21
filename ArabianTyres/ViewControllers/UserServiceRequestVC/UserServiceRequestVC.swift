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
    @IBOutlet weak var requestNoValueLbl1: UILabel!
    @IBOutlet weak var requestSeenValueLbl: UILabel!
    @IBOutlet weak var bidRecivedValueLbl: UILabel!
    @IBOutlet weak var lowestBidValueLbl: UILabel!
    @IBOutlet weak var nearestBidderValueLbl: UILabel!
    @IBOutlet weak var sarLbl: UILabel!
    @IBOutlet weak var brandCountryLbl: UILabel!
    @IBOutlet weak var emptyContainerView: UIView!
    @IBOutlet weak var cancelBtn: AppButton!
    @IBOutlet weak var viewAllBtn: AppButton!
    @IBOutlet weak var requestNoValueLbl: UILabel!
    @IBOutlet weak var requestNoLbl: UILabel!
    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var brandCollView: UICollectionView!
    @IBOutlet weak var brandCollViewHeightConstraint: NSLayoutConstraint!

    
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
        if !brandsArray.isEmpty{
            self.brandCollViewHeightConstraint.constant = brandCollView.contentSize.height + 38.0
        }else if !countryArray.isEmpty{
            self.brandCollViewHeightConstraint.constant = brandCollView.contentSize.height + 38.0
        }else {
            self.brandCollViewHeightConstraint.constant = 60.0
        }
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
        self.setupCollectionView()
        emptyContainerView.isHidden = true
        viewModel.delegate = self
        viewAllBtn.isEnabled = true
        titleLbl.text =  self.viewModel.serviceType == "Tyres" ? "Tyre Service Request" : self.viewModel.serviceType == "Battery" ? "Battery Service Request" : "Oil Service Request"
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
        requestNoValueLbl1.text = "#" + "\(self.viewModel.userRequestDetail.requestID)"
        requestNoValueLbl.text = "#" + "\(self.viewModel.userRequestDetail.requestID)"
        self.brandsArray = self.viewModel.userRequestDetail.preferredBrands.map({ (model) -> String in
            model.name
        })
        self.countryArray = self.viewModel.userRequestDetail.preferredCountries.map({ (model) -> String in
            model.name
        })
        self.brandCountryLbl.text =  self.brandsArray.endIndex > 0 ? "Brand Preferences" : "Country Preferences"
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
        brandCollView.reloadData()
    }
    
    func getUserMyRequestDetailFailed(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    private func setupCollectionView(){
        brandCollView.delegate = self
        brandCollView.dataSource = self
        brandCollView.isScrollEnabled = false
        brandCollView.registerCell(with: FacilityCollectionViewCell.self)
        
    }
}

// MARK: - Extension For Collection View
//======================================
extension UserServiceRequestVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandsArray.endIndex > 0 ? brandsArray.endIndex : countryArray.endIndex
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: FacilityCollectionViewCell.self, indexPath: indexPath)
        cell.cancelBtn.isHidden = true
        cell.cancelBtnHeightConstraint.constant = 0.0
        cell.skillLbl.contentMode = .center
        cell.skillLbl.text = brandsArray.endIndex > 0 ? brandsArray[indexPath.item] : countryArray[indexPath.item]
        cell.layoutSubviews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cardSizeForItemAt(collectionView,layout: collectionViewLayout,indexPath: indexPath)
    }
    
    private func cardSizeForItemAt(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        let selectedText = brandsArray.endIndex > 0 ? brandsArray[indexPath.item] : countryArray[indexPath.item]
        let textSize = selectedText.sizeCount(withFont: AppFonts.NunitoSansSemiBold.withSize(14.0), boundingSize: CGSize(width: 10000.0, height: collectionView.frame.height))
        return CGSize(width: textSize.width + 16, height: 44.0)
    }
}

