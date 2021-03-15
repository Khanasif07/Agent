//
//  LoginEmailPhoneTableCell.swift
//  ArabianTyres
//
//  Created by Admin on 04/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginEmailPhoneTableCell: UITableViewCell {
    
    var signupBtnTapped: ((UIButton)->())?
    var signInBtnTapped: ((UIButton)->())?
    var phoneNoBtnTapped: ((UIButton)->())?
    var forgotPassBtnTapped: ((UIButton)->())?
    
    @IBOutlet weak var forgotPassBtn: UIButton!
    @IBOutlet weak var dontHaveAccountLbl: UILabel!
    @IBOutlet weak var signInBtn: AppButton!
    @IBOutlet weak var phoneNoBtn: UIButton!
    @IBOutlet weak var loginWithEmailPhoneLbl: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var emailTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var passTxtField: SkyFloatingLabelTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpColor()
        self.setUpTextField()
        self.addBottomViewToBottom()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.signInBtn.round(radius: 4.0)
    }
    
    
    public func setUpTextField(){
        self.dontHaveAccountLbl.text = LocalizedString.dont_have_an_account.localized
        self.forgotPassBtn.setTitle(LocalizedString.forgotPassword.localized, for: .normal)
        self.loginWithEmailPhoneLbl.text = LocalizedString.login_with_emailId.localized
        self.emailTxtField.title = LocalizedString.emailIdPlaceHolder.localized
        self.passTxtField.title = LocalizedString.password.localized
        self.emailTxtField.selectedTitle = LocalizedString.emailIdPlaceHolder.localized
        self.passTxtField.selectedTitle = LocalizedString.password.localized
        self.emailTxtField.placeholder = LocalizedString.emailID.localized
        self.passTxtField.placeholder = LocalizedString.password.localized
        self.passTxtField.lineColor = AppColors.fontTertiaryColor
        self.emailTxtField.lineColor = AppColors.fontTertiaryColor
        self.emailTxtField.selectedLineColor =
        AppColors.fontTertiaryColor
        self.passTxtField.selectedLineColor =
               AppColors.fontTertiaryColor
        self.emailTxtField.selectedTitleColor = AppColors.fontTertiaryColor
        self.passTxtField.selectedTitleColor = AppColors.fontTertiaryColor
        self.signUpBtn.setTitle(LocalizedString.signupcap.localized, for: .normal)
        self.signInBtn.setTitle(LocalizedString.sign_in.localized, for: .normal)
        self.passTxtField.isSecureTextEntry = true
        let show = UIButton()
        show.isSelected = false
        show.addTarget(self, action: #selector(secureTextField(_:)), for: .touchUpInside)
        self.passTxtField.setButtonToRightView(btn: show, selectedImage: #imageLiteral(resourceName: "icPasswordView"), normalImage: #imageLiteral(resourceName: "icPasswordHide"), size: CGSize(width: 22, height: 22))
    }
    
    public func addBottomViewToBottom(){
        self.signUpBtn.addBottomBorderWithColor(color: AppColors.appRedColor, height: 1)
    }
    
    @objc func secureTextField(_ sender: UIButton){
        sender.isSelected.toggle()
        self.passTxtField.isSecureTextEntry = !sender.isSelected
    }
    
    public func setUpColor(){
        self.phoneNoBtn.setTitleColor(AppColors.appRedColor, for: .normal)
        self.phoneNoBtn.setTitle(LocalizedString.usePhoneNumber.localized, for: .normal)
        self.signInBtn.setTitleColor(UIColor.white, for: .normal)
        self.signInBtn.backgroundColor = AppColors.primaryBlueColor
        self.forgotPassBtn.setTitleColor(AppColors.fontTertiaryColor, for: .normal)
        self.signUpBtn.setTitleColor(AppColors.appRedColor, for: .normal)
        self.signInBtn.isEnabled = false
    }

    
    @IBAction func phoneNoBtnAction(_ sender: UIButton) {
        if let handle = phoneNoBtnTapped{
            handle(sender)
        }
    }
    
    @IBAction func forgotPassBtnAction(_ sender: UIButton) {
        if let handle = forgotPassBtnTapped{
            handle(sender)
        }
    }
    
    @IBAction func signInBtnAction(_ sender: UIButton) {
        if let handle = signInBtnTapped{
            handle(sender)
        }
    }
    
    @IBAction func signupBtnAction(_ sender: UIButton) {
        if let handle = signupBtnTapped{
            handle(sender)
        }
    }
    
}
