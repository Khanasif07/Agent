//
//  LinkAccountTableViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 15/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class LinkAccountTableViewCell: UITableViewCell {

    @IBOutlet weak var linkedAccLbl: UILabel!
    @IBOutlet weak var bankNameLbl: UILabel!
    @IBOutlet weak var accNumberLbl: UILabel!
    @IBOutlet weak var editbtn: UIButton!

    override func awakeFromNib() {
        setupFontAndText()
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setupFontAndText() {
        linkedAccLbl.text = LocalizedString.linkedAccount.localized
        linkedAccLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        bankNameLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        accNumberLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)

    }
    
    @IBAction func editBtnTapped(_ sender: UIButton) {
      printDebug("edit btn tapped")
    }
    
}
