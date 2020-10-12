//
//  GarageServiceBrandsCell.swift
//  ArabianTyres
//
//  Created by Admin on 07/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class GarageServiceBrandsCell: UITableViewCell,UITextFieldDelegate {
    
    var unitPriceChanged: ((_ unitPrice: String,_ sender: UITextField)->())?

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
        unitPrizeTextFiled.delegate = self
        unitPrizeTextFiled.keyboardType = .numberPad
        unitPrizeTextFiled.textAlignment = .center
    }
    
    func bindData(_ model: PreferredBrand) {
        brandNameLbl.text = model.name
        checkBtn.isSelected = model.isSelected ?? false
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        let text = sender.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        if let handle = unitPriceChanged {
            handle(text,sender)
        }
    }
}
