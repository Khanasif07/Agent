//
//  VehicleDetailForBatteryVC.swift
//  ArabianTyres
//
//  Created by Arvind on 24/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class VehicleDetailForBatteryVC: BaseVC {
    
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var vehicleMakeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var vehicleModelTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var productYearTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var batteryNumberTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var uploadImgLbl: UILabel!
    @IBOutlet weak var batteryImgContainerView: UIView!
    @IBOutlet weak var enterVehicleDetailLbl: UILabel!
    @IBOutlet weak var wellGetYouLbl: UILabel!
    @IBOutlet weak var nextBtn: AppButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var batteryImgView: UIImageView!
    @IBOutlet weak var vehicleDetailLbl: UILabel!
    @IBOutlet weak var batteryImgLbl: UILabel!
    @IBOutlet weak var numberOfBatteryLbl: UILabel!
    @IBOutlet weak var imgEditBtn: UIButton!
    @IBOutlet weak var imgUploadBtn: UIButton!

    // MARK: - Variables
    //===========================
    var selectedMakeArr: [MakeModel] = []
    var selectedModelArr: [ModelData] = []
    var placeHolderArr : [String] = [LocalizedString.enterVehicleMake.localized,
                                     LocalizedString.enterVehicleModel.localized,
                                     LocalizedString.productYear.localized,
                                     LocalizedString.chooseQuantity.localized
    ]
    var vehicleDetailtype: VehicleDetailType = .make
    var yearPicker = WCCustomPickerView()
    var quantityPicker = WCCustomPickerView()
    var tempTextField: UITextField?
    var titleArr : [String] = [LocalizedString.vehicleMake.localized,
                               LocalizedString.vehicleModel.localized,
                               LocalizedString.productYear.localized,
                               ""
    ]
    fileprivate var hasImageUploaded = true {
        didSet {
            if hasImageUploaded {
                print("StringConstants.K_PROFILE_PIC_UPLOADED.localized")
            }
        }
    }
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        TyreRequestModel.shared = TyreRequestModel()
        self.pop()
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        if !self.hasImageUploaded{
            self.showAlert(msg: LocalizedString.wait_Img_Upload.localized)
            return
        }
        AppRouter.goToBatteryBrandVC(vc: self)
    }
    
    @IBAction func imgEditBtnAction(_ sender: UIButton) {
        if !self.hasImageUploaded{
            self.showAlert(msg: LocalizedString.wait_Img_Upload.localized)
            return
        }
        self.captureImage(delegate: self,removedImagePicture: !TyreRequestModel.shared.images.isEmpty)
    }
    
    func viewAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        batteryImgContainerView.isUserInteractionEnabled = true
        batteryImgContainerView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer?) {
        self.captureImage(delegate: self,removedImagePicture: !TyreRequestModel.shared.images.isEmpty)
    }
}

// MARK: - Extension For Functions
//===========================
extension VehicleDetailForBatteryVC {
    
    private func initialSetup() {
        setupTextField()
        setupTextFont()
        viewAction()
        imgEditBtn.isHidden = true
    }
    
    private func setupTextField(){
        for (index,txtField) in [vehicleMakeTextField,vehicleModelTextField,productYearTextField,batteryNumberTextField].enumerated() {
            txtField?.delegate = self
            txtField?.setImageToRightView(img: #imageLiteral(resourceName: "group3714"), size: CGSize(width: 20, height: 20))
            txtField?.placeholder = placeHolderArr[index]
            txtField?.title = titleArr[index]
            txtField?.selectedTitleColor = AppColors.fontTertiaryColor
            txtField?.placeholderFont = AppFonts.NunitoSansRegular.withSize(15.0)
            txtField?.font = AppFonts.NunitoSansBold.withSize(14.0)
            txtField?.textColor = AppColors.fontPrimaryColor
        }
        self.productYearTextField.inputView = yearPicker
        self.batteryNumberTextField.inputView = quantityPicker
        self.yearPicker.delegate = self
        self.quantityPicker.delegate = self
        self.yearPicker.dataArray = self.setUpYearPickerView()
        self.quantityPicker.dataArray = self.setUpNumberOfBatteryPickerView()
    }
    
    private func setupTextFont() {
        enterVehicleDetailLbl.text = LocalizedString.enteryYourVehicleDetails.localized
        wellGetYouLbl.text = LocalizedString.wellGetYouExactTyreSize.localized
        nextBtn.setTitle(LocalizedString.next.localized, for: .normal)
        numberOfBatteryLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        vehicleDetailLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        batteryImgLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        enterVehicleDetailLbl.font = AppFonts.NunitoSansBold.withSize(21.0)
        wellGetYouLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        nextBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        nextBtn.isEnabled = false
        imgEditBtn.isHidden = !TyreRequestModel.shared.images.isEmpty
        batteryImgContainerView.backgroundColor =  !TyreRequestModel.shared.images.isEmpty ? .white : AppColors.lightBackgroundColor
        batteryImgContainerView.borderWidth = !TyreRequestModel.shared.images.isEmpty ? 0.0 : 1.0
        uploadImgLbl.isHidden = !TyreRequestModel.shared.images.isEmpty
        
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
    
    private func setUpNumberOfBatteryPickerView() -> [String]{
           var arr: [String] = []
           var j = 0
           for i in 1...999 {
               arr.insert(String(i), at: j)
               j += 1
           }
           return arr
       }
    
    private func submitBtnStatus(){
        self.nextBtn.isEnabled = !TyreRequestModel.shared.year.isEmpty && !TyreRequestModel.shared.make.isEmpty && !TyreRequestModel.shared.model.isEmpty && !TyreRequestModel.shared.quantity.isEmpty
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
                TyreRequestModel.shared.make = makeData.first?.name ?? ""
                _self.submitBtnStatus()
            } else {
                _self.selectedModelArr = modelData
                _self.vehicleModelTextField.text = modelData.first?.model ?? ""
                TyreRequestModel.shared.model = modelData.first?.model ?? ""
                _self.submitBtnStatus()
            }
        }
        present(scene, animated: true, completion: nil)
    }
    
}

extension VehicleDetailForBatteryVC :UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case vehicleMakeTextField:
            tempTextField = vehicleMakeTextField
            vehicleDetailtype = .make
            openBottomSheet(type: VehicleDetailType.make)
            self.selectedMakeArr = []
            TyreRequestModel.shared.model = ""
            self.vehicleModelTextField.text = ""
            return false
        case vehicleModelTextField:
            tempTextField = vehicleModelTextField
            if self.selectedMakeArr.isEmpty {
               ToastView.shared.showLongToast(self.view, msg: "Please select vehicle maker name")
               return false
            }
            vehicleDetailtype = .model
            openBottomSheet(type: VehicleDetailType.model)
            return false
        case batteryNumberTextField:
            if let text = textField.text {
                if text.isEmpty{
                    batteryNumberTextField.text = self.quantityPicker.dataArray.first
                    TyreRequestModel.shared.quantity = self.quantityPicker.dataArray.first ?? ""
                    submitBtnStatus()
                }}
            tempTextField = batteryNumberTextField
            return true
        default:
            if let text = textField.text {
            if text.isEmpty{
                productYearTextField.text = self.yearPicker.dataArray.first
                TyreRequestModel.shared.year = self.yearPicker.dataArray.first ?? ""
                submitBtnStatus()
            }}
            tempTextField = productYearTextField
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

extension VehicleDetailForBatteryVC: WCCustomPickerViewDelegate {
    func userDidSelectRow(_ text: String) {
        switch tempTextField{
        case productYearTextField:
            productYearTextField.text = text
            TyreRequestModel.shared.year = text
            self.submitBtnStatus()
        case batteryNumberTextField:
            batteryNumberTextField.text = text
            TyreRequestModel.shared.quantity = text
            self.submitBtnStatus()
        default:
            printDebug("Do Nothing..")
        }
        
    }
}

// MARK: - UIImagePickerControllerDelegate
//===========================
extension VehicleDetailForBatteryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate , RemovePictureDelegate {
    func removepicture() {
        TyreRequestModel.shared.images = []
        imgUploadBtn.setImage(#imageLiteral(resourceName: "icImg"), for: .normal)
    //    batteryImgView.setImage_kf(imageString: TyreRequestModel.shared.images.first?.url ?? "", placeHolderImage: #imageLiteral(resourceName: "icImg"), loader: false)
        batteryImgView.image = nil
        imgEditBtn.isHidden = true
        batteryImgContainerView.isUserInteractionEnabled = TyreRequestModel.shared.images.isEmpty
        batteryImgContainerView.backgroundColor =  !TyreRequestModel.shared.images.isEmpty ? .white : AppColors.primaryBlueLightShade
        batteryImgContainerView.borderWidth = !TyreRequestModel.shared.images.isEmpty ? 0.0 : 1.0
        uploadImgLbl.isHidden = !TyreRequestModel.shared.images.isEmpty
        self.submitBtnStatus()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        hasImageUploaded = false
        batteryImgView.image = image
        batteryImgContainerView.isUserInteractionEnabled = false
        imgEditBtn.isHidden = false
        imgUploadBtn.setImage(nil, for: .normal)
        batteryImgContainerView.backgroundColor = .white
        uploadImgLbl.isHidden = true
        batteryImgContainerView.borderWidth = 0.0
        CommonFunctions.showActivityLoader()
        TyreRequestModel.shared.images = []
        TyreRequestModel.shared.images.append(ImageModel(url: "", type: "image", image: image ?? UIImage()))
        self.submitBtnStatus()
        image?.upload(progress: { (progress) in
            printDebug(progress)
        }, completion: { (response,error) in
            if let url = response {
                CommonFunctions.hideActivityLoader()
                self.hasImageUploaded = true
                let lastIndex = TyreRequestModel.shared.images.endIndex
                TyreRequestModel.shared.images[lastIndex-1].url = url
                self.submitBtnStatus()
            }
            if let _ = error{
                self.showAlert(msg: LocalizedString.imageUploadingFailed.localized)
            }
        })
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
