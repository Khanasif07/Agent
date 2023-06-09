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
    @IBOutlet weak var dashBackgroundView: UIView!
    @IBOutlet weak var totalPrizeLbl : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        unitPrizeTextFiled.isHidden = true
        unitPriceLbl.font = AppFonts.NunitoSansBold.withSize(13.0)
        unitPrizeTextFiled.selectedLineColor = .clear
        unitPrizeTextFiled.lineColor = .clear
        unitPrizeTextFiled.lineHeight = 0.0
        unitPrizeTextFiled.keyboardType =  .numberPad
        unitPrizeTextFiled.textAlignment = .center
    }
    
    func populateData(isBrandSelected: Bool,model: BidDatum){
        checkBtn.isSelected = isBrandSelected
        unitLbl.text = "\(model.quantity)"
        unitPriceLbl.text = "\(model.amount)" + " SAR"
//        unitPrizeTextFiled.text = "\(Double(model.quantity) * model.amount)" + " SAR"
        totalPrizeLbl.text = "\(Double(model.quantity) * model.amount)" + " SAR"
        brandNameLbl.text = "\(model.brandName)"
    }
    
}
