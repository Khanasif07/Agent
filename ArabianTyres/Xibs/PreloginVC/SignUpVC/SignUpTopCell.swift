//
//  SignUpTopCell.swift
//  ArabianTyres
//
//  Created by Admin on 04/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SignUpTopCell: UITableViewCell {
     
    var signInBtnTapped: ((UIButton)->())?
    var signUpBtnTapped: ((UIButton)->())?
    var countryPickerTapped: ((UIButton)->())?
    
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var alreadyHaveAcctLbl: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var privacyLbl: UILabel!
    @IBOutlet weak var confirmPassTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var passTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var mobNoTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailIdTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var nameTxtField: SkyFloatingLabelTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpTextField()
        self.setUpAttributedString()
        
    }
    
    private func setUpAttributedString(){
        let attributedString = NSMutableAttributedString(string: LocalizedString.bySigningDec.localized, attributes: [
            .font: UIFont.systemFont(ofSize: 13.0),
            .foregroundColor: AppColors.fontTertiaryColor
        ])
        attributedString.append(NSAttributedString(string: LocalizedString.tos.localized, attributes: [NSAttributedString.Key.foregroundColor: AppColors.primaryBlueColor,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13.0)]))
        attributedString.append(NSAttributedString(string: "&", attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontTertiaryColor,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)]))
        attributedString.append(NSAttributedString(string: LocalizedString.privacyPolicy.localized, attributes: [NSAttributedString.Key.foregroundColor: AppColors.primaryBlueColor,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13.0)]))
        
        privacyLbl.attributedText = attributedString
        
    }
    
    public func setUpTextField(){
        self.alreadyHaveAcctLbl.text = LocalizedString.alreadyHaveAnAccount.localized
        self.emailIdTxtField.title = LocalizedString.emailIdPlaceHolder.localized
        self.passTxtField.title = LocalizedString.password.localized
        self.emailIdTxtField.selectedTitle = LocalizedString.emailIdPlaceHolder.localized
        self.passTxtField.selectedTitle = LocalizedString.password.localized
        self.emailIdTxtField.selectedTitle = LocalizedString.emailIdPlaceHolder.localized
        self.passTxtField.selectedTitle = LocalizedString.password.localized
        self.confirmPassTxtField.selectedTitle = LocalizedString.password.localized
        self.emailIdTxtField.placeholder = LocalizedString.enterYourEmailId.localized
        self.passTxtField.placeholder = LocalizedString.password.localized
        self.confirmPassTxtField.placeholder = LocalizedString.confirmPassword.localized
        self.nameTxtField.placeholder = LocalizedString.enterYourName.localized
        self.mobNoTxtField.placeholder = LocalizedString.enterYourMobNumber.localized
        [nameTxtField,emailIdTxtField,mobNoTxtField,passTxtField,confirmPassTxtField].forEach({$0?.lineColor = AppColors.fontTertiaryColor})
        [nameTxtField,emailIdTxtField,mobNoTxtField,passTxtField,confirmPassTxtField].forEach({$0?.selectedLineColor = AppColors.fontTertiaryColor})
        [nameTxtField,emailIdTxtField,mobNoTxtField,passTxtField,confirmPassTxtField].forEach({$0?.selectedTitleColor = AppColors.fontTertiaryColor})
        self.signUpBtn.setTitle(LocalizedString.signupcap.localized, for: .normal)
        self.signInBtn.setTitle(LocalizedString.sign_in.localized, for: .normal)
        self.signUpBtn.backgroundColor = AppColors.primaryBlueColor
        self.passTxtField.isSecureTextEntry = true
        self.confirmPassTxtField.isSecureTextEntry = true
        self.mobNoTxtField.keyboardType = .numberPad
        let show = UIButton()
        show.isSelected = false
        show.addTarget(self, action: #selector(secureTextField(_:)), for: .touchUpInside)
        self.passTxtField.setButtonToRightView(btn: show, selectedImage: #imageLiteral(resourceName: "icPasswordHide"), normalImage: #imageLiteral(resourceName: "icPasswordHide"), size: CGSize(width: 22, height: 22))
        let show1 = UIButton()
        show1.isSelected = false
        show1.addTarget(self, action: #selector(secureTextField1(_:)), for: .touchUpInside)
        self.confirmPassTxtField.setButtonToRightView(btn: show1, selectedImage: #imageLiteral(resourceName: "icPasswordHide"), normalImage: #imageLiteral(resourceName: "icPasswordHide"), size: CGSize(width: 22, height: 22))
    }
    
    
    @objc func secureTextField(_ sender: UIButton){
        sender.isSelected.toggle()
        self.passTxtField.isSecureTextEntry = !sender.isSelected
    }
    
    @objc func secureTextField1(_ sender: UIButton){
        sender.isSelected.toggle()
        self.confirmPassTxtField.isSecureTextEntry = !sender.isSelected
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        signUpBtn.round(radius: 4.0)
    }
    
    
    @IBAction func signUpAction(_ sender: UIButton) {
        if let handle = signUpBtnTapped{
            handle(sender)
        }
    }
    
    @IBAction func signInBtnAction(_ sender: UIButton) {
        if let handle = signInBtnTapped{
            handle(sender)
        }
    }
    
    @IBAction func countryPickerAction(_ sender: UIButton) {
        if let handle = countryPickerTapped{
            handle(sender)
        }
    }
}
