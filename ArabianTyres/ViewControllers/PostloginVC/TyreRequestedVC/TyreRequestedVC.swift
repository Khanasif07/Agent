//
//  TyreRequestedVC.swift
//  ArabianTyres
//
//  Created by Arvind on 21/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class TyreRequestedVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var sizeOfTyreLbl: UILabel!
    @IBOutlet weak var originOfTyreLbl: UILabel!
    @IBOutlet weak var tyreBrandLbl: UILabel!
    @IBOutlet weak var numberOfTyreLbl: UILabel!
    
    @IBOutlet weak var tyreWidthLbl: UILabel!
    @IBOutlet weak var tyreProfileLbl: UILabel!
    @IBOutlet weak var tyreRimSizeLbl: UILabel!
    
    @IBOutlet weak var tyreWidthValueLbl: UILabel!
    @IBOutlet weak var tyreProfileValueLbl: UILabel!
    @IBOutlet weak var tyreRimSizeValueLbl: UILabel!
    @IBOutlet weak var tyreBrandCollView: UICollectionView!
    @IBOutlet weak var tyreBrandCollViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sizeContainerView: UIView!
    @IBOutlet weak var numberOfTyreContainerView: UIView!
    @IBOutlet weak var tyreBrandContainerView: UIView!
    @IBOutlet weak var numberOfTyreTextField: UILabel!
    
    @IBOutlet weak var requestBtn: AppButton!
    @IBOutlet weak var sizeEditBtn: UIButton!
    @IBOutlet weak var numberOfTyreBtn: UIButton!
    @IBOutlet weak var tyreBrandBtn: UIButton!
    
    
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
        [sizeContainerView,numberOfTyreContainerView,tyreBrandContainerView].forEach { (containerView) in
            containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        }
        if !TyreRequestModel.shared.countriesListing.isEmpty || !TyreRequestModel.shared.tyreBrandsListing.isEmpty{
            self.tyreBrandCollViewHeightConstraint.constant = tyreBrandCollView.contentSize.height + 38.0
        }else {
            self.tyreBrandCollViewHeightConstraint.constant = 45.0
        }
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    
    @IBAction func requestBtnAction(_ sender: UIButton) {
        if !isUserLoggedin{
            AppRouter.goToLoginVC(vc: self)
        }else {
            self.viewModel.postTyreRequest(dict: TyreRequestModel.shared.getTyreRequestDict())
        }
    }
    
    @IBAction func sizeEditBtnAction(_ sender: UIButton) {
        self.navigationController?.popToViewControllerOfType(classForCoder: URTyreStep1VC.self)
    }
    
    @IBAction func numberOfTyreAction(_ sender: UIButton) {
        self.navigationController?.popToViewControllerOfType(classForCoder: URTyreStep1VC.self)
    }
    
    @IBAction func tyreBrandAction(_ sender: UIButton) {
         self.navigationController?.popToViewControllerOfType(classForCoder: TyreBrandVC.self)
    }
    
}

// MARK: - Extension For Functions
//===========================
extension TyreRequestedVC {
    
    private func initialSetup() {
        setupTextAndFont()
        setupCollectionView()
        self.populateDataThroughModel()
    }
    
    private func setupTextAndFont(){
        self.viewModel.delegate = self
        sizeEditBtn.setTitleColor(AppColors.appRedColor, for: .normal)
        sizeEditBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(15.0)
        sizeEditBtn.setTitle(LocalizedString.edit.localized, for: .normal)
        sizeEditBtn.getUnderline()
        numberOfTyreBtn.getUnderline()
        tyreBrandBtn.getUnderline()
        numberOfTyreLbl.text = LocalizedString.numberOfTyre.localized
        numberOfTyreTextField.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        numberOfTyreTextField.isUserInteractionEnabled = false
        requestBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        requestBtn.setTitle(LocalizedString.submitRequest.localized, for: .normal)
        requestBtn.isEnabled = true
        titleLbl.text = LocalizedString.youAreRequestingForTyreServiceWith.localized
        sizeOfTyreLbl.text = LocalizedString.sizeOfTyre.localized
        originOfTyreLbl.text = LocalizedString.originOfTyre.localized
        tyreBrandLbl.text = LocalizedString.tyreBrand.localized
        tyreWidthLbl.text = LocalizedString.width.localized
        tyreProfileLbl.text = LocalizedString.profile.localized
        tyreRimSizeLbl.text = LocalizedString.rimSize.localized
        
        tyreWidthLbl.font = AppFonts.NunitoSansSemiBold.withSize(12.0)
        tyreProfileLbl.font = AppFonts.NunitoSansSemiBold.withSize(12.0)
        tyreRimSizeLbl.font = AppFonts.NunitoSansSemiBold.withSize(12.0)
        
        tyreWidthValueLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        tyreProfileValueLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        tyreRimSizeValueLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        
        titleLbl.font = AppFonts.NunitoSansBold.withSize(21.0)
        sizeOfTyreLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        numberOfTyreLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        originOfTyreLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        
    }
    
    private func setupCollectionView(){
        tyreBrandCollView.delegate = self
        tyreBrandCollView.dataSource = self
        tyreBrandCollView.isScrollEnabled = false
        tyreBrandCollView.registerCell(with: FacilityCollectionViewCell.self)
        
    }
    
    private func populateDataThroughModel(){
        tyreWidthValueLbl.text = TyreRequestModel.shared.width
        tyreProfileValueLbl.text = TyreRequestModel.shared.profile
        tyreRimSizeValueLbl.text = TyreRequestModel.shared.rimSize
        numberOfTyreTextField.text = TyreRequestModel.shared.quantity
        tyreBrandContainerView.isHidden = isBrandCountryEmpty()
        originOfTyreLbl.isHidden = isBrandCountryEmpty()
        tyreBrandLbl.text = TyreRequestModel.shared.tyreBrandsListing.isEmpty ? LocalizedString.countryOrigin.localized :  LocalizedString.tyreBrand.localized
    }
    
    private func isBrandCountryEmpty() -> Bool {
           return TyreRequestModel.shared.countriesListing.isEmpty && TyreRequestModel.shared.tyreBrandsListing.isEmpty
       }
    
}

extension TyreRequestedVC :UITextFieldDelegate{
    
}

// MARK: - LocationPopUpVMDelegate
//===========================

extension TyreRequestedVC: LocationPopUpVMDelegate{
    func postTyreRequestFailed(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func postTyreRequestSuccess(message: String) {
        AppRouter.showSuccessPopUp(vc: self, title: "Successfully Requested", desc: "Your request for tyre service has been submited successfully.")
    }
}

// MARK: - SuccessPopupVCDelegate
//===============================
extension TyreRequestedVC: SuccessPopupVCDelegate {
    func okBtnAction() {
        self.dismiss(animated: true) {
            TyreRequestModel.shared = TyreRequestModel()
            self.navigationController?.popToViewControllerOfType(classForCoder: HomeVC.self)
        }
    }
}

extension TyreRequestedVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TyreRequestModel.shared.tyreBrandsListing.isEmpty ? TyreRequestModel.shared.countriesListing.endIndex : TyreRequestModel.shared.tyreBrandsListing.endIndex
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: FacilityCollectionViewCell.self, indexPath: indexPath)
        cell.cancelBtn.isHidden = true
        cell.cancelBtnHeightConstraint.constant = 0.0
        cell.skillLbl.contentMode = .center
        if TyreRequestModel.shared.tyreBrandsListing.isEmpty {
            cell.skillLbl.text = TyreRequestModel.shared.countriesListing[indexPath.item]
        }else {
            cell.skillLbl.text = TyreRequestModel.shared.tyreBrandsListing[indexPath.item]
        }
        cell.layoutSubviews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cardSizeForItemAt(collectionView,layout: collectionViewLayout,indexPath: indexPath)
    }
    
    private func cardSizeForItemAt(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        let dataArr = TyreRequestModel.shared.tyreBrandsListing.isEmpty ? TyreRequestModel.shared.countriesListing : TyreRequestModel.shared.tyreBrandsListing
        let textSize = dataArr[indexPath.row].sizeCount(withFont: AppFonts.NunitoSansSemiBold.withSize(14.0), boundingSize: CGSize(width: 10000.0, height: collectionView.frame.height))
        return CGSize(width: textSize.width + 16, height: 34.0)
    }
    
}
