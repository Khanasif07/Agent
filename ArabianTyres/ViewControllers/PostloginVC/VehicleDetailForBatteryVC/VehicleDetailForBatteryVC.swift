//
//  VehicleDetailForBatteryVC.swift
//  ArabianTyres
//
//  Created by Arvind on 24/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class VehicleDetailForBatteryVC: BaseVC {
   

    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var vehicleMakeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var vehicleModelTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var productYearTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var batteryNumberTextField: SkyFloatingLabelTextField!

    @IBOutlet weak var enterVehicleDetailLbl: UILabel!
    @IBOutlet weak var wellGetYouLbl: UILabel!
    @IBOutlet weak var nextBtn: AppButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var batteryImgView: UIImageView!
    @IBOutlet weak var vehicleDetailLbl: UILabel!
    @IBOutlet weak var batteryImgLbl: UILabel!
    @IBOutlet weak var numberOfBatteryLbl: UILabel!
    @IBOutlet weak var imgEditBtn: UIButton!

    // MARK: - Variables
    //===========================

    var placeHolderArr : [String] = [LocalizedString.enterVehicleMake.localized,
     LocalizedString.enterVehicleModel.localized,
     LocalizedString.productYear.localized,
     LocalizedString.chooseQuantity.localized
    ]
   
    var titleArr : [String] = [LocalizedString.vehicleMake.localized,
                                 LocalizedString.vehicleModel.localized,
                                 LocalizedString.productYear.localized,
                                 ""
                                ]
   
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
        AppRouter.goToOilBrandsVC(vc: self)
    }
   
    @IBAction func imgEditBtnAction(_ sender: UIButton) {
        
     }
}

// MARK: - Extension For Functions
//===========================
extension VehicleDetailForBatteryVC {
    
    private func initialSetup() {
        setupTextField()
        setupTextFont()
        batteryImgView.isHidden = true
        imgEditBtn.isHidden = true
    }
    
    private func setupTextField(){
        for (index,txtField) in [vehicleMakeTextField,vehicleModelTextField,productYearTextField,batteryNumberTextField].enumerated() {
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
        enterVehicleDetailLbl.text = LocalizedString.enteryYourVehicleDetails.localized
        wellGetYouLbl.text = LocalizedString.wellGetYouExactTyreSize.localized
        nextBtn.setTitle(LocalizedString.next.localized, for: .normal)
        numberOfBatteryLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        vehicleDetailLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        batteryImgLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        enterVehicleDetailLbl.font = AppFonts.NunitoSansBold.withSize(21.0)
        wellGetYouLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        nextBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        
    }
}

extension VehicleDetailForBatteryVC :UITextFieldDelegate {
    
}

