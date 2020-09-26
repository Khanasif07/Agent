//
//  BatteryRequestedVC.swift
//  ArabianTyres
//
//  Created by Arvind on 25/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class BatteryRequestedVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var vechileDetailLbl: UILabel!
    @IBOutlet weak var batteryBrandLbl: UILabel!
    @IBOutlet weak var numberOfBatteryLbl: UILabel!
    
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
    @IBOutlet weak var numberOfBatteyTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var requestBtn: AppButton!
    @IBOutlet weak var vechileDetailEditBtn: UIButton!
    @IBOutlet weak var numberOfBatteryEditBtn: UIButton!
    @IBOutlet weak var batteryBrandEditBtn: UIButton!


    // MARK: - Variables
    //===========================
    var viewModel = GarageRegistrationVM()
    
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
          printDebug("request btn tap")
    }
      
    @IBAction func sizeEditBtnAction(_ sender: UIButton) {
        printDebug("size btn tap")
    }
    
    @IBAction func numberOfTyreAction(_ sender: UIButton) {
        printDebug("number of Tyre btn tap")

    }
    
    @IBAction func tyreBrandAction(_ sender: UIButton) {
        printDebug("tyre btn tap")

    }
}

// MARK: - Extension For Functions
//===========================
extension BatteryRequestedVC {
    
    private func initialSetup() {
        setupTextAndFont()
        setupCollectionView()
        self.populateDataThroughModel()
    }
    
    private func setupTextAndFont(){
        [vechileDetailEditBtn,numberOfBatteryEditBtn,batteryBrandEditBtn].forEach { (btn) in
            btn?.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(15.0)
            btn?.setTitle(LocalizedString.edit.localized, for: .normal)
            btn?.getUnderline()
        }
    
        vechileDetailLbl.text = LocalizedString.vehicleDetails.localized
        batteryBrandLbl.text = LocalizedString.batteryBrand.localized
        numberOfBatteryLbl.text = LocalizedString.numberOfBattery.localized
        titleLbl.text = LocalizedString.batteyRequest.localized

        numberOfBatteyTextField.delegate = self
        numberOfBatteyTextField.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        numberOfBatteyTextField.isUserInteractionEnabled = false
        requestBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        requestBtn.setTitle(LocalizedString.submitRequest.localized, for: .normal)
      
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
        tyreBrandCollView.delegate = self
        tyreBrandCollView.dataSource = self
        tyreBrandCollView.isScrollEnabled = false
        tyreBrandCollView.registerCell(with: FacilityCollectionViewCell.self)
        
    }
    
    private func populateDataThroughModel(){
//        tyreWidthValueLbl.text = TyreRequestModel.shared.width
//        tyreProfileValueLbl.text = TyreRequestModel.shared.profile
//        tyreRimSizeValueLbl.text = TyreRequestModel.shared.rimSize
    }
    
}

extension BatteryRequestedVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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
        return CGSize(width: textSize.width + 16, height: 34.0)
    }
    
}

extension BatteryRequestedVC :UITextFieldDelegate{
    
}
