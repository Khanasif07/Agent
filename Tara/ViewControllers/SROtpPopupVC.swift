//
//  SROtpPopupVC.swift
//  Tara
//
//  Created by Arvind on 04/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

class SROtpPopupVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cancelBtn: AppButton!
    @IBOutlet weak var otpLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!

    
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension For Functions
//===========================
extension SROtpPopupVC {
    
    private func initialSetup() {
        setupTextAndFont()
    }
    
    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        otpLbl.font = AppFonts.NunitoSansExtraBold.withSize(27.0)
        descLbl.font = AppFonts.NunitoSansRegular.withSize(15.0)
        cancelBtn.setTitle(LocalizedString.cancel.localized, for: .normal)
        cancelBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(16.0)

        var str: NSMutableAttributedString = NSMutableAttributedString()
        str = NSMutableAttributedString(string: "Here is your OTP for Tyre Service\n", attributes: [
            .font: AppFonts.NunitoSansBold.withSize(14.0),
            .foregroundColor: AppColors.fontPrimaryColor
        ])
        
        str.append(NSAttributedString(string: "#1234567890", attributes: [NSAttributedString.Key.foregroundColor: AppColors.linkTextColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(14.0)]))
        
        str.append(NSAttributedString(string: " at XYZ Garage, Riyadh", attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontPrimaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(14.0)]))
        titleLbl.attributedText = str
    }
}
