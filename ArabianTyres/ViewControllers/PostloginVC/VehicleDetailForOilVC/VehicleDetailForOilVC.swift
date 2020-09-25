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
    @IBOutlet weak var countryTextField: SkyFloatingLabelTextField!

    @IBOutlet weak var vehicleDetailLbl: UILabel!
    @IBOutlet weak var subHeading: UILabel!
    @IBOutlet weak var nextBtn: AppButton!
    @IBOutlet weak var containerView: UIView!

    // MARK: - Variables
    //===========================

    var placeHolderArr : [String] = [LocalizedString.enterVehicleMake.localized,
     LocalizedString.enterVehicleModel.localized,
     LocalizedString.country.localized
    ]
   
    var titleArr : [String] = [LocalizedString.vehicleMake.localized,
                                 LocalizedString.vehicleModel.localized,
                                 LocalizedString.country.localized
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
        AppRouter.goToURTyreSizeVC(vc: self)
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
        for (index,txtField) in [vehicleMakeTextField,vehicleModelTextField,countryTextField].enumerated() {
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
      
        vehicleDetailLbl.text = LocalizedString.chooseYourVehicleDetails.localized
        subHeading.text = LocalizedString.wellGetYouOilAccordingToTheProvidedDetails.localized
        nextBtn.setTitle(LocalizedString.next.localized, for: .normal)
        vehicleDetailLbl.font = AppFonts.NunitoSansBold.withSize(21.0)
        subHeading.font = AppFonts.NunitoSansBold.withSize(14.0)
        nextBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        
    }
    
}

extension VehicleDetailForOilVC :UITextFieldDelegate {
    
}

