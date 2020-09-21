//
//  VechicleDetailVC.swift
//  ArabianTyres
//
//  Created by Arvind on 17/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class VechicleDetailVC: BaseVC {
   

    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var vehicleMakeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var vehicleModelTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var modelYearTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var enterVehicleDetailLbl: UILabel!
    @IBOutlet weak var wellGetYouLbl: UILabel!
    @IBOutlet weak var submitBtn: AppButton!
    @IBOutlet weak var containerView: UIView!

    // MARK: - Variables
    //===========================

    var placeHolderArr : [String] = [LocalizedString.enterVehicleMake.localized,
     LocalizedString.enterVehicleModel.localized,
     LocalizedString.enterModelYear.localized
    ]
   
    var titleArr : [String] = [LocalizedString.vehicleMake.localized,
                                 LocalizedString.vehicleModel.localized,
                                 LocalizedString.modelYear.localized
                                ]
   
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
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
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        AppRouter.goToURTyreSizeVC(vc: self)
    }
   
}

// MARK: - Extension For Functions
//===========================
extension VechicleDetailVC {
    
    private func initialSetup() {
        setupTextField()
        setupTextFont()
    }
    
    private func setupTextField(){
        for (index,txtField) in [vehicleMakeTextField,vehicleModelTextField,modelYearTextField].enumerated() {
            txtField?.delegate = self
            txtField?.placeholder = placeHolderArr[index]
            txtField?.title = titleArr[index]
            txtField?.selectedTitleColor = AppColors.fontTertiaryColor
            txtField?.placeholderFont = AppFonts.NunitoSansRegular.withSize(15.0)
            txtField?.font = AppFonts.NunitoSansBold.withSize(14.0)
            txtField?.textColor = AppColors.fontPrimaryColor
        }
        modelYearTextField.keyboardType = .numberPad
    }
    
    private func setupTextFont() {
        enterVehicleDetailLbl.text = LocalizedString.enteryYourVehicleDetails.localized
        wellGetYouLbl.text = LocalizedString.wellGetYouExactTyreSize.localized
        submitBtn.setTitle(LocalizedString.submit.localized, for: .normal)

        enterVehicleDetailLbl.font = AppFonts.NunitoSansBold.withSize(21.0)
        wellGetYouLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        submitBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        
    }
    
}

extension VechicleDetailVC :UITextFieldDelegate {
    
}

