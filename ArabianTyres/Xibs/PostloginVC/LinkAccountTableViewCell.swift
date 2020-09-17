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
    @IBOutlet weak var containerView : UIView!

    
    var editBtnTapped: (()->())?
    
    override func awakeFromNib() {
        setupFontAndText()
        super.awakeFromNib()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.4950264096, green: 0.495038569, blue: 0.4950320721, alpha: 1))

        // Initialization code
    }
    
    private func setupFontAndText() {
        linkedAccLbl.text = LocalizedString.linkedAccount.localized
        linkedAccLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        bankNameLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        accNumberLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)

    }
    
    @IBAction func editBtnTapped(_ sender: UIButton) {
        editBtnTapped?()
    }
    
    func popluateData(){
        bankNameLbl.text = GarageProfileModel.shared.bankName
        accNumberLbl.text = GarageProfileModel.shared.accountNumber


    }
    
}
