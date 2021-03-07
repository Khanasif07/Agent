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
    var requestData: RequestModel? = nil
    var onDismiss : (()->())?

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
        dismiss(animated: true, completion: {
            self.onDismiss?()
        })
    }
}

// MARK: - Extension For Functions
//===========================
extension SROtpPopupVC {
    
    private func initialSetup() {
        setupRequestData()
        setupTextAndFont()
    }
    
    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        otpLbl.font = AppFonts.NunitoSansExtraBold.withSize(27.0)
        descLbl.font = AppFonts.NunitoSansRegular.withSize(15.0)
        cancelBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(16.0)

        cancelBtn.setTitle(LocalizedString.cancel.localized, for: .normal)
        descLbl.text = LocalizedString.pleaseShowThisCodeToTheGarageToStartYourService.localized
        var str: NSMutableAttributedString = NSMutableAttributedString()
        str = NSMutableAttributedString(string: LocalizedString.hereIsYourOTPForTyreService.localized, attributes: [
            .font: AppFonts.NunitoSansBold.withSize(14.0),
            .foregroundColor: AppColors.fontPrimaryColor
        ])
        
        str.append(NSAttributedString(string: "#\(requestData?.request ?? "")", attributes: [NSAttributedString.Key.foregroundColor: AppColors.linkTextColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(14.0)]))
        
        str.append(NSAttributedString(string: " \(LocalizedString.at.localized) \(requestData?.garageName ?? "") \(LocalizedString.garage.localized)", attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontPrimaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(14.0)]))
        titleLbl.attributedText = str
    }
    
    private func setupRequestData() {
        otpLbl.text = requestData?.otp?.description
        otpLbl.text = requestData?.otp?.description
    }
}
