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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        signUpBtn.round(radius: 4.0)
    }
    
    
    @IBAction func signUpAction(_ sender: UIButton) {
    }
    
    @IBAction func signInBtnAction(_ sender: UIButton) {
        if let handle = signInBtnTapped{
            handle(sender)
        }
    }
    
}
