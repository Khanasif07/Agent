//
//  URTyreStep1VC.swift
//  ArabianTyres
//
//  Created by Admin on 18/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class URTyreStep1VC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var dashView: CustomDashedView!
    @IBOutlet weak var findRightBtn: UIButton!
    @IBOutlet weak var nextBtn: AppButton!
    @IBOutlet weak var chooseSizeLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var rimSizeTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var profileTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var widthTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var numberTyreTxtField: SkyFloatingLabelTextField!
    // MARK: - Variables
    //===========================
    // custom Picker View
    var tempTextField = UITextField()
    var widthPicker = WCCustomPickerView()
    var profilePicker = WCCustomPickerView()
    var rimSizePicker = WCCustomPickerView()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func crossBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    @IBAction func nextBtnAction(_ sender: UIButton) {
          AppRouter.goToTyreBrandVC(vc: self)
    }
    
    @IBAction func findRightAction(_ sender: UIButton) {
        AppRouter.goToVehicleDetailVC(vc: self)
    }
    
    @objc func selectedTyreSizeSuccess(){
        
    }
}

// MARK: - Extension For Functions
//===========================
extension URTyreStep1VC {
    
    private func initialSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(selectedTyreSizeSuccess), name: Notification.Name.SelectedTyreSizeSuccess, object: nil)
        self.setUpTextField()
        self.pickerViewSetUp()
    }
    
    public func setUpTextField(){
        self.widthTxtField.title = LocalizedString.width.localized
        self.profileTxtField.title = LocalizedString.profile.localized
        self.rimSizeTxtField.title = LocalizedString.rimSize.localized
        self.widthTxtField.selectedTitle = LocalizedString.width.localized
        self.profileTxtField.selectedTitle = LocalizedString.profile.localized
        self.rimSizeTxtField.selectedTitle = LocalizedString.rimSize.localized
        self.numberTyreTxtField.placeholder = LocalizedString.enter_number_of_tyre_you_want.localized
        self.numberTyreTxtField.selectedTitle = LocalizedString.quantity.localized
        self.numberTyreTxtField.title = LocalizedString.quantity.localized
        [widthTxtField,profileTxtField,rimSizeTxtField].forEach({$0?.text = ""})
        [widthTxtField,profileTxtField,rimSizeTxtField].forEach({$0?.lineColor = UIColor.clear})
        [widthTxtField,profileTxtField,rimSizeTxtField].forEach({$0?.selectedLineColor = UIColor.clear})
        [widthTxtField,profileTxtField,rimSizeTxtField,numberTyreTxtField].forEach({$0?.selectedTitleColor = AppColors.fontTertiaryColor})
        self.nextBtn.isEnabled = true
        self.nextBtn.isEnabled = false
    }
    
    private func pickerViewSetUp() {
        self.widthTxtField.delegate = self
        self.profileTxtField.delegate  = self
        self.rimSizeTxtField.delegate = self
        self.numberTyreTxtField.delegate = self
        self.widthPicker.delegate = self
        self.profilePicker.delegate = self
        self.rimSizePicker.delegate = self
        self.widthPicker.dataArray = self.setUpYearPickerView()
        self.profilePicker.dataArray = self.setUpYearPickerView()
        self.rimSizePicker.dataArray = self.setUpYearPickerView()
        self.widthTxtField.inputView = widthPicker
        self.profileTxtField.inputView = profilePicker
        self.rimSizeTxtField.inputView = rimSizePicker
        self.numberTyreTxtField.keyboardType = .numberPad
    }
    
    private func nextBtnStatus()-> Bool{
        return TyreRequestModel.shared.quantity != 0 && !TyreRequestModel.shared.width.isEmpty && !TyreRequestModel.shared.profile.isEmpty && !TyreRequestModel.shared.rimSize.isEmpty
    }
    
    //MARK:- Custom Picker View Data Array
    //===========================
    private func setUpYearPickerView() -> [String]{
        var arr: [String] = []
        var j = 0
        for i in 1...999 {
            arr.insert(String(i), at: j)
            j += 1
        }
        return arr
    }
}


extension URTyreStep1VC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case numberTyreTxtField:
            TyreRequestModel.shared.quantity = Int(textField.text ?? "") ?? 0
            self.nextBtn.isEnabled = nextBtnStatus()
        default:
            printDebug("Do nothing")
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == widthTxtField {
            if let text = textField.text {
                if text.isEmpty{
                    widthTxtField.text = self.widthPicker.dataArray.first
                    TyreRequestModel.shared.width = text
                }}
            tempTextField = widthTxtField
            return true
        } else if textField == profileTxtField {
            if let text = textField.text {
                if text.isEmpty{
                    profileTxtField.text = self.profilePicker.dataArray.first
                    TyreRequestModel.shared.profile = text
                }}
            tempTextField = profileTxtField
            return true
        } else if textField == rimSizeTxtField {
            if let text = textField.text {
                if text.isEmpty{
                    rimSizeTxtField.text = self.rimSizePicker.dataArray.first
                    TyreRequestModel.shared.rimSize = text
                }}
            tempTextField = rimSizeTxtField
            return true
        }
        else {return true }
    }
}

//MARK:- WCCustomPickerViewDelegate
// ================================

extension URTyreStep1VC: WCCustomPickerViewDelegate {
    func userDidSelectRow(_ text: String) {
        printDebug(text)
        if tempTextField == widthTxtField {
            widthTxtField.text = text
            TyreRequestModel.shared.width = text
            self.nextBtn.isEnabled = nextBtnStatus()
        } else if tempTextField == profileTxtField {
            profileTxtField.text = text
            TyreRequestModel.shared.profile = text
            self.nextBtn.isEnabled = nextBtnStatus()
        } else if tempTextField == rimSizeTxtField {
            rimSizeTxtField.text = text
            TyreRequestModel.shared.rimSize = text
            self.nextBtn.isEnabled = nextBtnStatus()
        }
    }
}
