//
//  VechicleDetailVC.swift
//  ArabianTyres
//
//  Created by Arvind on 17/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class VechicleDetailVC: BaseVC {
    
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var vehicleMakeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var vehicleModelTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var modelYearTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var enterVehicleDetailLbl: UILabel!
    @IBOutlet weak var wellGetYouLbl: UILabel!
    @IBOutlet weak var submitBtn: AppButton!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Variables
    //===========================
    var selectedMakeArr: [MakeModel] = []
    var selectedModelArr: [ModelData] = []
    var vehicleDetailtype : VehicleDetailType = .make
    var yearPicker = WCCustomPickerView()
    var placeHolderArr : [String] = [LocalizedString.enterVehicleMake.localized,
                                     LocalizedString.enterVehicleModel.localized,
                                     LocalizedString.enterModelYear.localized
    ]
    
    var titleArr : [String] = [LocalizedString.vehicleMake.localized,
                               LocalizedString.vehicleModel.localized,
                               LocalizedString.modelYear.localized
    ]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        AppRouter.goToURTyreSizeVC(vc: self)
    }
    
}

// MARK: - Extension For Functions
//===========================
extension VechicleDetailVC {
    
    private func initialSetup() {
        setupTextField()
        setupTextFont()
    }
    
    private func setupTextField(){
        for (index,txtField) in [vehicleMakeTextField,vehicleModelTextField,modelYearTextField].enumerated() {
            txtField?.delegate = self
            txtField?.placeholder = placeHolderArr[index]
            txtField?.title = titleArr[index]
            txtField?.setImageToRightView(img: #imageLiteral(resourceName: "group3714"), size: CGSize(width: 20, height: 20))
            txtField?.selectedTitleColor = AppColors.fontTertiaryColor
            txtField?.placeholderFont = AppFonts.NunitoSansRegular.withSize(15.0)
            txtField?.font = AppFonts.NunitoSansBold.withSize(14.0)
            txtField?.textColor = AppColors.fontPrimaryColor
        }
        self.yearPicker.delegate = self
        self.yearPicker.dataArray = self.setUpYearPickerView()
        self.modelYearTextField.inputView = yearPicker
        modelYearTextField.keyboardType = .numberPad
        CommonFunctions.setupTextFieldAlignment([vehicleMakeTextField, vehicleModelTextField, modelYearTextField])
    }
    
    private func setupTextFont() {
        enterVehicleDetailLbl.text = LocalizedString.enteryYourVehicleDetails.localized
        wellGetYouLbl.text = LocalizedString.wellGetYouExactTyreSize.localized
        submitBtn.setTitle(LocalizedString.submit.localized, for: .normal)
        submitBtn.isEnabled = false
        enterVehicleDetailLbl.font = AppFonts.NunitoSansBold.withSize(21.0)
        wellGetYouLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        submitBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        
    }
    
    private func openBottomSheet(type: VehicleDetailType = .make) {
        let scene = BottomSheetVC.instantiate(fromAppStoryboard: .PostLogin)
        scene.viewModel.selectedMakeArr = selectedMakeArr
        scene.vehicleDetailtype = type
        scene.viewModel.makeId = selectedMakeArr.first?.id ?? ""
        scene.onSaveBtnAction = { [weak self] (makeData,modelData) in
            guard let _self = self else {return}
            if  _self.vehicleDetailtype == .make {
                _self.selectedMakeArr = makeData
                _self.vehicleMakeTextField.text = makeData.first?.name ?? ""
                TyreRequestModel.shared.makeId = makeData.first?.id ?? ""
                TyreRequestModel.shared.makeName = makeData.first?.name ?? ""
                TyreRequestModel.shared.make = makeData.first?.name ?? ""
                _self.submitBtnStatus()
            } else {
                _self.selectedModelArr = modelData
                _self.vehicleModelTextField.text = modelData.first?.model ?? ""
                 TyreRequestModel.shared.modelName = modelData.first?.model ?? ""
                 TyreRequestModel.shared.model = modelData.first?.model ?? ""
                _self.submitBtnStatus()
            }
        }
        present(scene, animated: true, completion: nil)
    }
    
    private func submitBtnStatus(){
        self.submitBtn.isEnabled = !(modelYearTextField.text ?? "").isEmpty && !self.selectedMakeArr.isEmpty && !self.selectedModelArr.isEmpty
    }
    //MARK:- Custom Picker View Data Array
    //===========================
    private func setUpYearPickerView() -> [String]{
        var arr: [String] = []
        var j = 0
        let year = Calendar.current.component(.year, from: Date())
        for i in 1990...year {
            arr.insert(String(i), at: j)
            j += 1
        }
        return arr
    }
    
}

extension VechicleDetailVC :UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case vehicleMakeTextField:
            vehicleDetailtype = .make
            openBottomSheet(type: VehicleDetailType.make)
            self.selectedMakeArr = []
            self.vehicleModelTextField.text = ""
            TyreRequestModel.shared.modelName = ""
            return false
        case vehicleModelTextField:
            if self.selectedMakeArr.isEmpty {
                ToastView.shared.showLongToast(self.view, msg: "Please select vehicle maker name")
                return false
            }
            vehicleDetailtype = .model
            openBottomSheet(type: VehicleDetailType.model)
            return false
        default:
            if let text = textField.text {
                if text.isEmpty{
                    modelYearTextField.text = self.yearPicker.dataArray.first
                    TyreRequestModel.shared.year = self.yearPicker.dataArray.first ?? ""
                    submitBtnStatus()
                }}
            return true
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

//MARK:- WCCustomPickerViewDelegate
// ================================

extension VechicleDetailVC: WCCustomPickerViewDelegate {
    func userDidSelectRow(_ text: String) {
        modelYearTextField.text = text
        TyreRequestModel.shared.year = text
        self.submitBtnStatus()
    }
}
