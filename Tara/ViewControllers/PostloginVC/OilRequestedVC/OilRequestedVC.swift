//
//  OilRequestedVC.swift
//  ArabianTyres
//
//  Created by Arvind on 26/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class OilRequestedVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var vechileDetailLbl: UILabel!
    @IBOutlet weak var oilBrandLbl: UILabel!
    @IBOutlet weak var numberOfUnitLbl: UILabel!
    
    @IBOutlet weak var vehicleMakeLbl: UILabel!
    @IBOutlet weak var vehicleModelLbl: UILabel!
    @IBOutlet weak var productYearLbl: UILabel!
    
    @IBOutlet weak var vehicleMakeValueLbl: UILabel!
    @IBOutlet weak var vehicleModelValueLbl: UILabel!
    @IBOutlet weak var productYearValueLbl: UILabel!
    @IBOutlet weak var tyreBrandCollView: UICollectionView!
    @IBOutlet weak var tyreBrandCollViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var vechileDetailContainerView: UIView!
    @IBOutlet weak var numberOfBatteryContainerView: UIView!
    @IBOutlet weak var batteryBrandContainerView: UIView!
    @IBOutlet weak var numberOfBatteyTextField: UILabel!
    
    @IBOutlet weak var requestBtn: AppButton!
    @IBOutlet weak var vechileDetailEditBtn: UIButton!
    @IBOutlet weak var numberOfUnitEditBtn: UIButton!
    @IBOutlet weak var oilBrandEditBtn: UIButton!


    // MARK: - Variables
    //===========================
    var viewModel = LocationPopUpVM()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        [vechileDetailContainerView,numberOfBatteryContainerView,batteryBrandContainerView].forEach { (containerView) in
            containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        }
        
        if !TyreRequestModel.shared.tyreBrands.isEmpty {
            self.tyreBrandCollViewHeightConstraint.constant = tyreBrandCollView.contentSize.height + 38.0
        }else {
            self.tyreBrandCollViewHeightConstraint.constant = 45.0
        }
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        TyreRequestModel.shared = TyreRequestModel()
        self.navigationController?.popToViewControllerOfType(classForCoder: HomeVC.self)
    }
    
    
    @IBAction func requestBtnAction(_ sender: UIButton) {
        if !isUserLoggedin{
            showAlertWithAction(title: "", msg:  "To continue performing this action, please login", cancelTitle: LocalizedString.cancel.localized, actionTitle: LocalizedString.ok.localized, actioncompletion: {
                AppRouter.goToLoginVC(vc: self)
            }) {}
        }else {
            self.viewModel.postOilRequest(dict: TyreRequestModel.shared.getBatteryRequestDict())
        }
    }
      
    @IBAction func vechileDetailEditAction(_ sender: UIButton) {
        self.navigationController?.popToViewControllerOfType(classForCoder: VehicleDetailForOilVC.self)
    }
    
    @IBAction func numberOfUnitEditAction(_ sender: UIButton) {
        self.navigationController?.popToViewControllerOfType(classForCoder: VehicleDetailForOilVC.self)

    }
    
    @IBAction func oilBrandAction(_ sender: UIButton) {
        self.navigationController?.popToViewControllerOfType(classForCoder: OilBrandsVC.self)
    }
}

// MARK: - Extension For Functions
//===========================
extension OilRequestedVC {
    
    private func initialSetup() {
        self.viewModel.delegate = self
        setupTextAndFont()
        setupCollectionView()
        self.populateDataThroughModel()
    }
    
    private func setupTextAndFont(){
        [vechileDetailEditBtn,numberOfUnitEditBtn,oilBrandEditBtn].forEach { (btn) in
            btn?.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(15.0)
            btn?.setTitle(LocalizedString.edit.localized, for: .normal)
            btn?.getUnderline()
        }
        vechileDetailEditBtn.setTitleColor(AppColors.appRedColor, for: .normal)
        vechileDetailLbl.text = LocalizedString.vehicleDetails.localized
        oilBrandLbl.text = LocalizedString.oilBrands.localized
        numberOfUnitLbl.text = LocalizedString.numberOfUnit.localized
        titleLbl.text = LocalizedString.oilRequest.localized

        numberOfBatteyTextField.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        numberOfBatteyTextField.isUserInteractionEnabled = false
        requestBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        requestBtn.setTitle(LocalizedString.submitRequest.localized, for: .normal)
        requestBtn.isEnabled = true
        vehicleMakeLbl.text = LocalizedString.vehicleMake.localized
        vehicleModelLbl.text = LocalizedString.vehicleModel.localized
        productYearLbl.text = LocalizedString.productYear.localized
       
        vehicleMakeLbl.font = AppFonts.NunitoSansSemiBold.withSize(12.0)
        vehicleModelLbl.font = AppFonts.NunitoSansSemiBold.withSize(12.0)
        productYearLbl.font = AppFonts.NunitoSansSemiBold.withSize(12.0)

        vehicleMakeValueLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        vehicleModelValueLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        productYearValueLbl.font = AppFonts.NunitoSansBold.withSize(14.0)

        titleLbl.font = AppFonts.NunitoSansBold.withSize(21.0)
       

    }
    
    private func setupCollectionView(){
        let layout = AlignmentFlowLayout()
        layout.horizontalAlignment = .left
        layout.verticalAlignment = .bottom
        tyreBrandCollView.collectionViewLayout = layout
        tyreBrandCollView.delegate = self
        tyreBrandCollView.dataSource = self
        tyreBrandCollView.isScrollEnabled = false
        tyreBrandCollView.registerCell(with: FacilityCollectionViewCell.self)
        
    }
    
    private func populateDataThroughModel(){
          vehicleMakeValueLbl.text = TyreRequestModel.shared.make
          vehicleModelValueLbl.text = TyreRequestModel.shared.model
          productYearValueLbl.text = TyreRequestModel.shared.year
          numberOfBatteyTextField.text = TyreRequestModel.shared.quantity
          batteryBrandContainerView.isHidden = isBrandCountryEmpty()
          oilBrandLbl.isHidden = isBrandCountryEmpty()
    }
    
    private func isBrandCountryEmpty() -> Bool {
        return TyreRequestModel.shared.tyreBrandsListing.isEmpty
    }
}

extension OilRequestedVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case tyreBrandCollView:
            return TyreRequestModel.shared.tyreBrandsListing.endIndex
        default:
            return TyreRequestModel.shared.countriesListing.endIndex
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: FacilityCollectionViewCell.self, indexPath: indexPath)
        cell.cancelBtn.isHidden = true
        cell.cancelBtnHeightConstraint.constant = 0.0
        cell.skillLbl.contentMode = .center
        if collectionView == tyreBrandCollView {
            cell.skillLbl.text = TyreRequestModel.shared.tyreBrandsListing[indexPath.item]
        } else {
            cell.skillLbl.text = TyreRequestModel.shared.countriesListing[indexPath.item]
        }
        cell.layoutSubviews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cardSizeForItemAt(collectionView,layout: collectionViewLayout,indexPath: indexPath)
    }
    
    private func cardSizeForItemAt(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        let dataArr = collectionView == tyreBrandCollView ? TyreRequestModel.shared.tyreBrandsListing : TyreRequestModel.shared.countriesListing
        let textSize = dataArr[indexPath.row].sizeCount(withFont: AppFonts.NunitoSansSemiBold.withSize(13.0), boundingSize: CGSize(width: 10000.0, height: collectionView.frame.height))
        return CGSize(width: textSize.width + 25.0, height: 34.0)
    }
    
}

extension OilRequestedVC :UITextFieldDelegate{
    
}

// MARK: - Extension For LocationPopUpVMDelegate
//===========================
extension OilRequestedVC : LocationPopUpVMDelegate {
    func postOilRequestSuccess(message: String){
         NotificationCenter.default.post(name: Notification.Name.ServiceRequestSuccess, object: nil)
         AppRouter.showSuccessPopUp(vc: self, title: "Successfully Requested", desc: "Your request for oil service has been submited successfully.")
    }
    
    func postOilRequestFailed(error:String){
        ToastView.shared.showLongToast(self.view, msg: error)
    }
}

// MARK: - SuccessPopupVCDelegate
//===============================
extension OilRequestedVC: SuccessPopupVCDelegate {
    func okBtnAction() {
        self.dismiss(animated: true) {
            TyreRequestModel.shared = TyreRequestModel()
            guard let nav: UINavigationController = AppDelegate.shared.window?.rootViewController as? UINavigationController else { return }
            if let homeScene = nav.hasViewController(ofKind: UserTabBarController.self) as? UserTabBarController {
                homeScene.selectedIndex = 1
                self.navigationController?.popToViewControllerOfType(classForCoder: HomeVC.self)
            }
        }
    }
}
