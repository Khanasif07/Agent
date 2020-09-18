//
//  LocationPopUpVC.swift
//  ArabianTyres
//
//  Created by Arvind on 18/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class LocationPopUpVC: BaseVC {

    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var subHeadingLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var allowBtn: UIButton!
    @IBOutlet weak var imgView: UIImageView!


    // MARK: - Variables
    //===========================
   

    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    // MARK: - IBActions
    //===========================

    @IBAction func cancelBtnAction(_ sender: UIButton) {
       self.dismiss(animated: true, completion: nil)
    }

    @IBAction func allowBtnAction(_ sender: UIButton) {
   
    }



}

// MARK: - Extension For Functions
//===========================
extension LocationPopUpVC {

    private func initialSetup() {
        setupTextAndFont()
    }

    private func setupTextAndFont(){
     
        headingLbl.text = LocalizedString.arabianTyresWantToAccessYourCurrentLocation.localized
        subHeadingLbl.text = LocalizedString.allowCureentLocationWillHelpYouInGettingGreatOffers.localized

        headingLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        subHeadingLbl.font = AppFonts.NunitoSansRegular.withSize(15.0)
        cancelBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        allowBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)

        cancelBtn.setTitle(LocalizedString.cancel.localized, for: .normal)
        allowBtn.setTitle(LocalizedString.allow.localized, for: .normal)

    }
}

