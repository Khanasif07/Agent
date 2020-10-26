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

    
    @IBOutlet weak var dashBackgroundView: UIView!
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
        unitPrizeTextFiled.keyboardType = .decimalPad
        unitPrizeTextFiled.textAlignment = .center
    }
    
    func bindData(_ model: PreferredBrand) {
        brandNameLbl.text = model.name
        unitPrizeTextFiled.text = "\(model.amount ?? 0)"
        checkBtn.isSelected = model.isSelected ?? false
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        let text = sender.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        if let handle = unitPriceChanged {
            handle(text,sender)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.contains(s: ".") {
            return updatedText.count <= 6

        }else {
            return updatedText.count <= 5
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let text = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        if text == "0.0" {
            self.unitPrizeTextFiled.text = ""
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        if text == "" {
            self.unitPrizeTextFiled.text = "0.0"
        }
    }
    
    func setBlurView(isBlur: Bool) {
        if isBlur {
            brandNameLbl.textColor = #colorLiteral(red: 0.1098039216, green: 0.1137254902, blue: 0.1411764706, alpha: 0.3)
            unitLbl.textColor = #colorLiteral(red: 0.1098039216, green: 0.1137254902, blue: 0.1411764706, alpha: 0.3)
            unitPrizeTextFiled.textColor = #colorLiteral(red: 0.1098039216, green: 0.1137254902, blue: 0.1411764706, alpha: 0.3)
            checkBtn.tintColor = #colorLiteral(red: 0.1098039216, green: 0.1137254902, blue: 0.1411764706, alpha: 0.3)
            
        }else {
            brandNameLbl.textColor = AppColors.fontPrimaryColor
            unitLbl.textColor = AppColors.fontPrimaryColor
            unitPrizeTextFiled.textColor = AppColors.fontPrimaryColor
            checkBtn.tintColor = AppColors.fontPrimaryColor
        }
    }
}
