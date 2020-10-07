//
//  SkilledCollectionViewCell.swift
//  Sigma For India
//
//  Created by Arvind on 30/07/20.
//  Copyright © 2020 Sigma. All rights reserved.
//

import UIKit

class FacilityCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var skillLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cancelBtnHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        skillLbl.font = AppFonts.NunitoSansSemiBold.withSize(12.0)
    }
    
    func popluateData(service: FacilityModel, brand: Brands) {
    }
}
