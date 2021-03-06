//
//  ProfileGuestTableCell.swift
//  ArabianTyres
//
//  Created by Admin on 09/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ProfileGuestTableCell: UITableViewCell {
    
    var loginBtnTapped: ((UIButton)->())?
    var createAccountBtnTapped: ((UIButton)->())?
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var createNewAccountBtn: UIButton!
    @IBOutlet weak var loginBtn: AppButton!
    @IBOutlet weak var welcomeToTaraLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupText()
        loginBtn.isEnabled = true
        frontView.backgroundColor = AppColors.fontTertiaryColor.withAlphaComponent(0.5)
        backView.backgroundColor = AppColors.fontTertiaryColor.withAlphaComponent(0.5)
        welcomeToTaraLbl.textColor = AppColors.fontTertiaryColor.withAlphaComponent(0.5)
        createNewAccountBtn.setTitleColor(AppColors.fontSecondaryColor, for: .normal)
        welcomeToTaraLbl.font = AppFonts.NunitoSansBold.withSize(15.0)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.loginBtn.round(radius: 4.0)
        self.dataContainerView.addShadow(cornerRadius: 4, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 4)
    }
    
    private func setupText() {
        loginBtn.setTitle(LocalizedString.login.localized, for: .normal)
        createNewAccountBtn.setTitle(LocalizedString.createNewAccount.localized, for: .normal)
    }
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        if let handle = loginBtnTapped{
            handle(sender)
        }
    }
    
    @IBAction func newAccntAction(_ sender: UIButton) {
        if let handle = createAccountBtnTapped{
            handle(sender)
        }
    }
    
}
