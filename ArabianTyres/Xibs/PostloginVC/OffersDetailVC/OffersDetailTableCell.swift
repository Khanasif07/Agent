//
//  OffersDetailTableCell.swift
//  ArabianTyres
//
//  Created by Admin on 12/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class OffersDetailTableCell: UITableViewCell {

   @IBOutlet weak var unitPriceLbl : UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var dashViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var dashView: CustomDashedView!
    @IBOutlet weak var brandNameLbl : UILabel!
    @IBOutlet weak var unitLbl : UILabel!
    @IBOutlet weak var unitPrizeTextFiled : SkyFloatingLabelTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        unitPrizeTextFiled.selectedLineColor = .clear
        unitPrizeTextFiled.lineColor = .clear
        unitPrizeTextFiled.lineHeight = 0.0
        unitPrizeTextFiled.keyboardType =  .numberPad
        unitPrizeTextFiled.textAlignment = .center
    }
    
}
