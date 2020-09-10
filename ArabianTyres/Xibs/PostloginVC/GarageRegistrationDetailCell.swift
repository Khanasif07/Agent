//
//  GarageRegistrationDetailCell.swift
//  ArabianTyres
//
//  Created by Arvind on 10/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class GarageRegistrationDetailCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!

    override func awakeFromNib() {
        setUpFont()
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setUpFont() {
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        descLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)

    }
    
    func populateData(heading: String, subHeading: String) {
        titleLbl.text = heading
        descLbl.text = subHeading

    }
}
