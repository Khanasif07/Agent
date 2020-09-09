//
//  ProfileGuestTableCell.swift
//  ArabianTyres
//
//  Created by Admin on 09/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ProfileGuestTableCell: UITableViewCell {
    
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var createNewAccountBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createNewAccountBtn.setTitleColor(AppColors.primaryBlueColor, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.loginBtn.round(radius: 4.0)
        self.dataContainerView.addShadow(cornerRadius: 4, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 4)
    }
    
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
    }
    @IBAction func newAccntAction(_ sender: UIButton) {
    }
    
}
