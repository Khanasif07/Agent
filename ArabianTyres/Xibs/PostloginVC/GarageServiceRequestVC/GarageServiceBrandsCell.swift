//
//  GarageServiceBrandsCell.swift
//  ArabianTyres
//
//  Created by Admin on 07/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class GarageServiceBrandsCell: UITableViewCell {

    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var dashViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var dashView: CustomDashedView!
    @IBOutlet weak var brandNameLbl : UILabel!
    @IBOutlet weak var unitLbl : UILabel!
    @IBOutlet weak var unitPrizeTextFiled : SkyFloatingLabelTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        unitPrizeTextFiled.textAlignment = .center
    }
    
    func bindData(_ model: PreferredBrand) {
        brandNameLbl.text = model.name
        checkBtn.isSelected = model.isSelected ?? false
//        unitLbl.text = model.
    }
}
