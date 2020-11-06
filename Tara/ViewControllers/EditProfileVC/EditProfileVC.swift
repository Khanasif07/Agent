//
//  EditProfileVC.swift
//  Tara
//
//  Created by Arvind on 30/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

protocol EditProfileVCDelegate: class{
    func editProfileSuccess()
}

class EditProfileVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var mobileNoTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var editImgBtn: UIButton!
    @IBOutlet weak var saveBtn: AppButton!
    @IBOutlet weak var countryCodeLbl: UILabel!

    
    // MARK: - Variables
    //===========================
    
    var isEditProfileFrom : EditProfileFrom = .profile
    weak var delegate: EditProfileVCDelegate?
    var viewModel = EditProfileVM()
    var placeHolderArr : [String] = [LocalizedString.enterYourName.localized,
                                     LocalizedString.enterYourEmailId.localized,
                                     LocalizedString.enterPhoneNumber.localized
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
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_sender : Any) {
        pop()
    }
    
    @IBAction func saveBtnAction(_sender : UIButton) {
        self.viewModel.postEditProfileData(params: self.getDictForEditProfile())
    }
    
    @IBAction func editBtnAction(_sender : UIButton) {
        self.captureImage(delegate: self,removedImagePicture: !self.viewModel.userModel.image.isEmpty )
    }
    
    @IBAction func countryCodeTapped(_ sender: UIButton) {
        AppRouter.showCountryVC(vc: self)
    }
}

extension EditProfileVC: UITextFieldDelegate {
    
    private func initialSetup(){
        self.viewModel.delegate = self
        setupTextFont()
        userImage.round()
//        if isEditProfileFrom == .home || isEditProfileFrom == .garage {
//            saveBtn.isEnabled = false
//        }else {
//            saveBtn.isEnabled = true
//
//        }
        saveBtn.isEnabled = !self.viewModel.userModel.phoneNo.isEmpty
        setUpTextField()
        prefilledData()
    }
    
    func setUpTextField(){
     for (index,txtField) in [nameTextField,emailTextField,mobileNoTextField].enumerated() {
            txtField?.delegate = self
            txtField?.placeholder = placeHolderArr[index]
            txtField?.selectedTitleColor = AppColors.fontTertiaryColor
            txtField?.placeholderFont = AppFonts.NunitoSansRegular.withSize(15.0)
            txtField?.font = AppFonts.NunitoSansBold.withSize(14.0)
            txtField?.textColor = AppColors.fontPrimaryColor
        }
        mobileNoTextField.keyboardType = .numberPad
    }
    
    private func setupTextFont() {
        self.userImage.backgroundColor = .clear
        titleLbl.font = AppFonts.NunitoSansSemiBold.withSize(17.0)
        titleLbl.text = LocalizedString.editProfile.localized
        saveBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(16.0)
        saveBtn.setTitle(LocalizedString.save.localized, for: .normal)
    }
    
    private func prefilledData(){
        self.nameTextField.text = self.viewModel.userModel.name
        self.emailTextField.text = self.viewModel.userModel.email
        self.mobileNoTextField.text = self.viewModel.userModel.phoneNo
        self.viewModel.userModel.countryCode = self.viewModel.userModel.countryCode.isEmpty ? "+91" : self.viewModel.userModel.countryCode
        countryCodeLbl.text = self.viewModel.userModel.countryCode
        self.userImage.setImage_kf(imageString: self.viewModel.userModel.image, placeHolderImage:#imageLiteral(resourceName: "placeHolder"), loader: false)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        switch textField {
        case nameTextField:
            return (string.checkIfValidCharaters(.name) || string.isEmpty) && newString.length <= 50
        case mobileNoTextField:
            return (string.checkIfValidCharaters(.mobileNumber) || string.isEmpty) && newString.length <= 10
        case emailTextField:
            return (string.checkIfValidCharaters(.email) || string.isEmpty) && newString.length <= 50
        default:
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        switch textField {
        case emailTextField:
            self.viewModel.userModel.email = text
            self.saveBtn.isEnabled = editBtnStatus()
        case nameTextField:
            self.viewModel.userModel.name = text
            self.saveBtn.isEnabled = editBtnStatus()
        case mobileNoTextField:
            self.viewModel.userModel.phoneNo = text
            self.saveBtn.isEnabled = editBtnStatus()
        default:
            printDebug("Do Nothing")
        }
        
    }
    
    private func editBtnStatus()-> Bool{
        return !self.viewModel.userModel.name.isEmpty && !self.viewModel.userModel.email.isEmpty && !self.viewModel.userModel.phoneNo.isEmpty
    }
    
    private func getDictForEditProfile() -> JSONDictionary{
        let countryCode = self.viewModel.userModel.countryCode
        let dict : JSONDictionary = [ApiKey.phoneNo : self.viewModel.userModel.phoneNo,
                                     ApiKey.countryCode : countryCode,
                                     ApiKey.name : self.viewModel.userModel.name,
                                     ApiKey.email:self.viewModel.userModel.email,
                                     ApiKey.image: self.viewModel.userModel.image]
           
        return dict
    }
}

// MARK: - CountryDelegate
//=========================
extension EditProfileVC : CountryDelegate{
    func sendCountryCode(code: String) {
        self.countryCodeLbl.text = code
        self.viewModel.userModel.countryCode = code
    }
}

// MARK: - EditProfileVMDelegate
//=========================
extension EditProfileVC : EditProfileVMDelegate {
    func getEditProfileVMSuccess(msg: String,statusCode : Int) {
        //only phone number updated
        if statusCode == 250 {
            AppRouter.goToOtpVerificationVC(vc: self, phoneNo: self.viewModel.userModel.phoneNo, countryCode: self.viewModel.userModel.countryCode,isComeFromEditProfile: true,isEditProfileFrom: isEditProfileFrom)
        }
        
        //only email updated
        else if statusCode == 251 {
            self.delegate?.editProfileSuccess()
            self.pop()
        }
            
        //email phone number updated
        else if statusCode == 252 {
            AppRouter.goToOtpVerificationVC(vc: self, phoneNo: self.viewModel.userModel.phoneNo, countryCode: self.viewModel.userModel.countryCode,isComeFromEditProfile: true,isEditProfileFrom: isEditProfileFrom)
            
        }
            
        else {
            self.delegate?.editProfileSuccess()
            self.pop()
        }
    }
    
    func getEditProfileVMFailed(msg: String, error: Error) {
        ToastView.shared.showLongToast(self.view, msg: error.localizedDescription)
    }
}


// MARK: - UIImagePickerControllerDelegate
//===========================
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate , RemovePictureDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        userImage.image = image
        CommonFunctions.showActivityLoader()
        hasImageUploaded = false
        image?.upload(progress: { (progress) in
            printDebug(progress)
        }, completion: { (response,error) in
            if let url = response {
                CommonFunctions.hideActivityLoader()
                self.hasImageUploaded = true
                self.viewModel.userModel.image = url
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
    
    
    func removepicture() {
        self.viewModel.userModel.image = ""
        userImage.image = #imageLiteral(resourceName: "placeHolder")
        userImage.contentMode = .center
        editImgBtn.setImage(nil, for: .normal)
    }
    
}
