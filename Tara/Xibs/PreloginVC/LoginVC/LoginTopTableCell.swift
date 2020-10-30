//
//  LoginTopTableCell.swift
//  ArabianTyres
//
//  Created by Admin on 04/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class LoginTopTableCell: UITableViewCell {

    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var welcomeToTaraLbl: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        frontView.backgroundColor = AppColors.fontTertiaryColor.withAlphaComponent(0.5)
        backView.backgroundColor = AppColors.fontTertiaryColor.withAlphaComponent(0.5)
        welcomeToTaraLbl.textColor = AppColors.fontTertiaryColor.withAlphaComponent(0.5)
        welcomeToTaraLbl.font = AppFonts.NunitoSansBold.withSize(15.0)
    }
}
