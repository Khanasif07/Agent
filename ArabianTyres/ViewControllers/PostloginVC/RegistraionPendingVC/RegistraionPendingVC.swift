//
//  RegistraionPendingVC.swift
//  ArabianTyres
//
//  Created by Arvind on 11/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class RegistraionPendingVC: BaseVC {
    
    enum ScreenType {
        case pending
        case rejected
        case accept
    }
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var subHeadingLbl: UILabel!
    @IBOutlet weak var completeProfileBtn: UIButton!
   
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var mobileNotVerifyLbl: UILabel!
    @IBOutlet weak var inappropriateLbl: UILabel!
    @IBOutlet weak var bottomStackView: UIStackView!

    // MARK: - Variables
    //===========================
    var screenType : ScreenType = .pending
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

   
    // MARK: - IBActions
    //===========================
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func completeProfileBtnAction(_ sender: UIButton) {

    }
}

// MARK: - Extension For Functions
//===========================
extension RegistraionPendingVC {
    
    private func initialSetup() {
        setupTextAndFont()
        switch screenType {
            
        case .pending:
            bottomStackView.isHidden = true
            completeProfileBtn.isHidden = true
            subHeadingLbl.text = LocalizedString.yourRegistrationRequestIsStillUnder.localized
            imgView.image = #imageLiteral(resourceName: "group3874")
        case .rejected:
            bottomStackView.isHidden = false
            headingLbl.text = "Your Registration Request\nmade on 7th july, 2020 has been Rejected\ndue to following reasons: "
            subHeadingLbl.isHidden = true
            completeProfileBtn.isHidden = false
            completeProfileBtn.setTitle(LocalizedString.registerAgain.localized, for: .normal)
            imgView.image = #imageLiteral(resourceName: "group3873")

        case .accept:
            bottomStackView.isHidden = true
            subHeadingLbl.isHidden = true
            completeProfileBtn.isHidden = false
            completeProfileBtn.setTitle(LocalizedString.completeProfile.localized, for: .normal)
            imgView.image = #imageLiteral(resourceName: "group3875")

        }
    }

    private func setupTextAndFont(){
        nameLbl.font = AppFonts.NunitoSansBold.withSize(21.0)
        headingLbl.font = AppFonts.NunitoSansRegular.withSize(15.0)
        subHeadingLbl.font = AppFonts.NunitoSansRegular.withSize(15.0)
        
        emailLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        mobileNotVerifyLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        inappropriateLbl.font = AppFonts.NunitoSansBold.withSize(14.0)

        completeProfileBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        completeProfileBtn.setTitle(LocalizedString.saveContinue.localized, for: .normal)

    }
    
}

