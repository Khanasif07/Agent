//
//  AddAccountTableViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 14/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class AddAccountTableViewCell: UITableViewCell {

    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var containerView : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFont()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.4950264096, green: 0.495038569, blue: 0.4950320721, alpha: 1))
        // Initialization code
    }
    
    func setupFont() {
        descLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
    }
    
    func bindData(text: String) {
        descLbl.text = text
    }
    
}
