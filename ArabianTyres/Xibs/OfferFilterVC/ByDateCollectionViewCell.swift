//
//  ByDateCollectionViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 10/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField


class ByDateCollectionViewCell: UICollectionViewCell {
    
    //MARK:- IBOutlet
    @IBOutlet weak var fromDateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var endDateTextField: SkyFloatingLabelTextField!
    
    //MARK:- Variables
    var placeHolderArr : [String] = [LocalizedString.fromDate.localized, LocalizedString.endDate.localized]
    var tempTextField: UITextField?
    var txtFieldData : ((Date, Date)->())?
  
    var fromDate : Date? = nil {
        didSet {
            if let fDate = fromDate {
                fromDateTextField.text = getDateString(selectDate: fDate)
            }else {
                fromDateTextField.text = ""
            }
        }
    }
    var toDate : Date? = nil {
        didSet {
            if let tDate = toDate {
                endDateTextField.text = getDateString(selectDate: tDate)
            }else {
                endDateTextField.text = ""
            }
        }
    }
    private let datePicker : UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate = Date().adjustedDate(.year, offset: 0)
        return picker
    }()
    
    //MARK:- LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextField()
        datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)

    }

    private func setupTextField() {
        
        for (index,txtField) in [fromDateTextField,endDateTextField].enumerated() {
            txtField?.delegate = self
            txtField?.tintColor = .clear
            txtField?.placeholder = placeHolderArr[index]
            txtField?.title = placeHolderArr[index]
            txtField?.setImageToRightView(img: #imageLiteral(resourceName: "layer24"), size: CGSize(width: 20, height: 20))
            txtField?.selectedTitleColor = AppColors.fontTertiaryColor
            txtField?.placeholderFont = AppFonts.NunitoSansRegular.withSize(15.0)
            txtField?.font = AppFonts.NunitoSansBold.withSize(14.0)
            txtField?.textColor = AppColors.fontPrimaryColor
            txtField?.inputView = datePicker
        }
    }
    
    private func getDateString(selectDate : Date)-> String {
        Date.dateFormatter.dateFormat = Date.DateFormat.dMMMyyyy.rawValue
        let date = Date.dateFormatter.string(from: selectDate)
        return date
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        tempTextField?.text = getDateString(selectDate: datePicker.date)
        if tempTextField == fromDateTextField {
            fromDate = datePicker.date
        }else {
            toDate = datePicker.date
        }
        
    }
}

extension ByDateCollectionViewCell :UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case fromDateTextField:
            datePicker.date = fromDate ?? Date()
            fromDate = datePicker.date
            tempTextField = fromDateTextField
        case endDateTextField:
            datePicker.date = toDate ?? Date()
            datePicker.minimumDate = fromDate?.plus(days: 1)
            toDate = datePicker.date
            tempTextField = endDateTextField
        default:
            break
        }
        
//        if let text = textField.text {
//            if text.isEmpty{
//                tempTextField?.text = getDateString(selectDate: datePicker.date)
//            }
//        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let fDate = fromDate , let tDate = toDate {
            txtFieldData?(fDate,tDate)
        }
//        txtFieldData?(fromDate,toDate)

    }
}

