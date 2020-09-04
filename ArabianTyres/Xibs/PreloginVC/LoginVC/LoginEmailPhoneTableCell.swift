//
//  LoginEmailPhoneTableCell.swift
//  ArabianTyres
//
//  Created by Admin on 04/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class LoginEmailPhoneTableCell: UITableViewCell {
    
    @IBOutlet weak var forgotPassBtn: UIButton!
    @IBOutlet weak var dontHaveAccountLbl: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var phoneNoBtn: UIButton!
    @IBOutlet weak var loginWithEmailPhoneLbl: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.signInBtn.round(radius: 4.0)
    }
    
    public func setUpColor(){
        self.phoneNoBtn.setTitleColor(AppColors.primaryBlueColor, for: .normal)
        self.signInBtn.setTitleColor(UIColor.white, for: .normal)
        self.signInBtn.backgroundColor = AppColors.primaryBlueColor
        self.forgotPassBtn.setTitleColor(AppColors.fontTertiaryColor, for: .normal)
        self.signUpBtn.setTitleColor(AppColors.primaryBlueColor, for: .normal)
    }

}
