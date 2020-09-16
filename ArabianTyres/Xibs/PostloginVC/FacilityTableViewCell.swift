//
//  FacilityTableViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 16/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class FacilityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkBtn : UIButton!
    @IBOutlet weak var subCategoryName : UILabel!
    @IBOutlet weak var bottomView : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        subCategoryName.font = AppFonts.NunitoSansBold.withSize(14.0)
    }
    
    @IBAction func checkBtnAction(_ sender: UIButton) {
        checkBtn.isSelected.toggle()
    }
}
