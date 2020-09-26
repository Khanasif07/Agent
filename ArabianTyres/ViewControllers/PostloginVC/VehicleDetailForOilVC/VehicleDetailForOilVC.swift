//
//  VehicleDetailForOilVC.swift
//  ArabianTyres
//
//  Created by Arvind on 24/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class VehicleDetailForOilVC: BaseVC {
   

    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var vehicleMakeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var vehicleModelTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var productYearTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var numberOfUnitTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var vehicleDetailLbl: UILabel!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var subHeading: UILabel!
    @IBOutlet weak var nextBtn: AppButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var oilImgView: UIImageView!
    @IBOutlet weak var oilImgLbl: UILabel!
    @IBOutlet weak var numberOfUnitLbl: UILabel!
    @IBOutlet weak var imgEditBtn: UIButton!
    @IBOutlet weak var uploadView: UIView!

    
    // MARK: - Variables
    //===========================

    var placeHolderArr : [String] = [LocalizedString.enterVehicleMake.localized,
     LocalizedString.enterVehicleModel.localized,
     LocalizedString.productYear.localized,
     LocalizedString.selectNumberOfUnitYouWant.localized
    ]
   
    var titleArr : [String] = [LocalizedString.vehicleMake.localized,
                                 LocalizedString.vehicleModel.localized,
                                 LocalizedString.productYear.localized,
                                 ""
    ]
    
    var selectedMakeArr: [MakeModel] = []
    var selectedModelArr: [ModelData] = []
    var vehicleDetailtype : VehicleDetailType = .make
    
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        AppRouter.goToURTyreSizeVC(vc: self)
    }
  
    @IBAction func imgEditBtnAction(_ sender: UIButton) {
       }
      
      
}

// MARK: - Extension For Functions
//===========================
extension VehicleDetailForOilVC {
    
    private func initialSetup() {
        setupTextField()
        setupTextFont()
    }
    
    private func setupTextField(){
        for (index,txtField) in [vehicleMakeTextField,vehicleModelTextField,productYearTextField,numberOfUnitTextField].enumerated() {
            txtField?.delegate = self
            txtField?.setImageToRightView(img: #imageLiteral(resourceName: "group3714"), size: CGSize(width: 20, height: 20))
            txtField?.placeholder = placeHolderArr[index]
            txtField?.title = titleArr[index]
            txtField?.selectedTitleColor = AppColors.fontTertiaryColor
            txtField?.placeholderFont = AppFonts.NunitoSansRegular.withSize(15.0)
            txtField?.font = AppFonts.NunitoSansBold.withSize(14.0)
            txtField?.textColor = AppColors.fontPrimaryColor
        }
    }
    
    private func setupTextFont() {
        oilImgLbl.text = LocalizedString.oilImage.localized
        oilImgLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        numberOfUnitLbl.text = LocalizedString.numberOfUnit.localized
        numberOfUnitLbl.font = AppFonts.NunitoSansBold.withSize(14.0)

        heading.text = LocalizedString.enteryYourVehicleDetails.localized
        heading.font = AppFonts.NunitoSansBold.withSize(21.0)
        vehicleDetailLbl.text = LocalizedString.vehicleDetails.localized
        subHeading.text = LocalizedString.wellGetYouOilAccordingToTheProvidedDetails.localized
        nextBtn.setTitle(LocalizedString.next.localized, for: .normal)
        vehicleDetailLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        subHeading.font = AppFonts.NunitoSansBold.withSize(14.0)
        nextBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        
    }
    
    private func openBottomSheet(type: VehicleDetailType = .make) {
        let scene = BottomSheetVC.instantiate(fromAppStoryboard: .PostLogin)
        scene.viewModel.selectedMakeArr = selectedMakeArr
        scene.vehicleDetailtype = type
        scene.viewModel.makeId = selectedMakeArr.first?.id ?? ""
        scene.onSaveBtnAction = { [weak self] (makeData,modelData) in
            guard let _self = self else {return}
            if  _self.vehicleDetailtype == .make {
                _self.selectedMakeArr = makeData
                _self.vehicleMakeTextField.text = makeData.first?.name ?? ""
                _self.submitBtnStatus()
            } else {
                _self.selectedModelArr = modelData
                _self.vehicleModelTextField.text = modelData.first?.model ?? ""
                _self.submitBtnStatus()
            }
        }
        present(scene, animated: true, completion: nil)
    }
    
    private func submitBtnStatus(){
           self.nextBtn.isEnabled = !(numberOfUnitTextField.text ?? "").isEmpty && !self.selectedMakeArr.isEmpty && !self.selectedModelArr.isEmpty
    }
}

extension VehicleDetailForOilVC :UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case vehicleMakeTextField:
            vehicleDetailtype = .make
            openBottomSheet(type: VehicleDetailType.make)
        return false
    case vehicleModelTextField:
        if self.selectedMakeArr.isEmpty {
            showAlert(msg: "Please fill make")
            return false
        }
        vehicleDetailtype = .model
        openBottomSheet(type: VehicleDetailType.model)
        return false
    default:
         return true
    }
  }
}
