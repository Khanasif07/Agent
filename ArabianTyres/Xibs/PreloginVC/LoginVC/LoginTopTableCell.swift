//
//  LoginTopTableCell.swift
//  ArabianTyres
//
//  Created by Admin on 04/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class LoginTopTableCell: UITableViewCell {

    @IBOutlet weak var welcomeToTaraLbl: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        welcomeToTaraLbl.font = AppFonts.NunitoSansBold.withSize(15.0)
    }
}
