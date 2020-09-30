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
    
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var createNewAccountBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var welcomeToTaraLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        createNewAccountBtn.setTitleColor(AppColors.primaryBlueColor, for: .normal)
        welcomeToTaraLbl.font = AppFonts.NunitoSansBold.withSize(15.0)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.loginBtn.round(radius: 4.0)
        self.dataContainerView.addShadow(cornerRadius: 4, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 4)
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
