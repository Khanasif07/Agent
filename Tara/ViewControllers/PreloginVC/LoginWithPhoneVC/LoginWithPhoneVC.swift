//
//  LoginWithPhoneVC.swift
//  ArabianTyres
//
//  Created by Admin on 04/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

enum LoginWithPhoneOption{
    case forgotPassword
    case socialUser
    case basic
}

class LoginWithPhoneVC: BaseVC {
    
    var viewModel = LoginWithPhoneViewModel()
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var enterDigitLbl: UILabel!
    @IBOutlet weak var sendOtpBtn: AppButton!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var countryCodeLbl: UILabel!
   
    // MARK: - Variables
    //===========================
    var loginOption: LoginWithPhoneOption = .basic
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        self.viewModel.delegate = self
        super.viewDidLoad()
        initialSetup()
    }
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
          return .darkContent
        } else {
            // Fallback on earlier versions
            return .lightContent
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.dataContainerView.addShadow(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        self.sendOtpBtn.round(radius: 4.0)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func countryCodeTapped(_ sender: UIButton) {
        AppRouter.showCountryVC(vc: self)
    }
    
    @IBAction func sendOtpAction(_ sender: UIButton) {
        if self.loginOption == .forgotPassword{
            self.forgotPassword()
        } else if self.loginOption == .socialUser{
            self.addPhoneNumber()
        }else{
            self.sendOtp()
        }
    }
}

// MARK: - Extension For Functions
//===========================
extension LoginWithPhoneVC {
    
    private func initialSetup() {
        CommonFunctions.setupTextFieldAlignment([phoneTextField])
        self.viewModel.delegate = self
        self.setupTextField()
        self.enterDigitLbl.text = LocalizedString.please_Enter_Your_Mobile_Number_with_Country_Code.localized
        self.sendOtpBtnStatus(enable: false)
        if self.loginOption == .forgotPassword {
            self.loginTitle.text = LocalizedString.forgotPassword.localized
            self.sendOtpBtn.setTitle(LocalizedString.submit.localized, for: .normal)}
        else if self.loginOption == .socialUser{
            self.loginTitle.text = LocalizedString.addPhoneNumber.localized
            self.sendOtpBtn.setTitle(LocalizedString.submit.localized, for: .normal)}
        else {
            self.loginTitle.text = LocalizedString.login.localized
            self.sendOtpBtn.setTitle(LocalizedString.sendOtp.localized, for: .normal)}
    }
    
    public func setupTextField(){
        self.countryCodeLbl.text = "+91"
        self.phoneTextField.keyboardType = .numberPad
        self.phoneTextField.delegate = self
        self.phoneTextField.title = LocalizedString.phoneNumber.localized
        self.phoneTextField.selectedTitle = LocalizedString.phoneNumber.localized
        self.phoneTextField.placeholder = LocalizedString.enterPhoneNumber.localized
        self.phoneTextField.lineColor = AppColors.fontTertiaryColor
        self.phoneTextField.selectedLineColor =
            AppColors.fontTertiaryColor
        self.phoneTextField.selectedTitleColor = AppColors.fontTertiaryColor
        CommonFunctions.setupTextFieldAlignment([phoneTextField])
        
    }
    
    public func sendOtpBtnStatus(enable: Bool){
        self.sendOtpBtn.isEnabled = enable
    }
    
    private func getDict() -> JSONDictionary{
        if self.loginOption == .forgotPassword {
            let dict : JSONDictionary = [ApiKey.phoneNo:  self.viewModel.phoneNo,ApiKey.countryCode: self.viewModel.countryCode]
            return dict
        } else if self.loginOption == .socialUser{
            let dict : JSONDictionary = [ApiKey.phoneNo:  self.viewModel.phoneNo,ApiKey.countryCode: self.viewModel.countryCode]
            return dict
        }else {
            let dict : JSONDictionary = [ApiKey.phoneNo:  self.viewModel.phoneNo,ApiKey.countryCode: self.viewModel.countryCode, ApiKey.device : [ApiKey.platform : "ios", ApiKey.token : DeviceDetail.deviceToken].toJSONString() ?? ""]
            return dict
        }
    }
    
    private func sendOtp(){
        self.view.endEditing(true)
        if self.viewModel.checkSendOtpValidations(parameters: getDict()).status{
            self.viewModel.sendOtp(params: getDict())
        }else{
            if !self.viewModel.checkSendOtpValidations(parameters: getDict()).message.isEmpty{
                showAlert(msg: self.viewModel.checkSendOtpValidations(parameters: getDict()).message)
            }
        }
    }
    
    private func forgotPassword(){
        self.view.endEditing(true)
        if self.viewModel.checkSendOtpValidations(parameters: getDict()).status{
            self.viewModel.forgotPassword(params: getDict())
        }else{
            if !self.viewModel.checkSendOtpValidations(parameters: getDict()).message.isEmpty{
                showAlert(msg: self.viewModel.checkSendOtpValidations(parameters: getDict()).message)
            }
        }
    }
    
    private func  addPhoneNumber(){
        self.view.endEditing(true)
        if self.viewModel.checkSendOtpValidations(parameters: getDict()).status{
            self.viewModel.addPhoneNumber(params: getDict())
        }else{
            if !self.viewModel.checkSendOtpValidations(parameters: getDict()).message.isEmpty{
                showAlert(msg: self.viewModel.checkSendOtpValidations(parameters: getDict()).message)
            }
        }
    }
}

// MARK: - Extension For TxtFieldDelegate
//=========================================
extension LoginWithPhoneVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        self.viewModel.phoneNo = text
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        switch textField {
        case phoneTextField:
            sendOtpBtnStatus(enable: newString.length >= 7)
            return (string.checkIfValidCharaters(.mobileNumber) || string.isEmpty) && newString.length <= 10
        default:
            return false
        }
    }
}

// MARK: - LoginWithPhoneVMDelegate
//=================================
extension LoginWithPhoneVC: LoginWithPhoneVMDelegate {
    func addPhoneNumbersSuccess(msg: String) {
        AppRouter.goToOtpVerificationVC(vc: self, phoneNo: self.viewModel.phoneNo, countryCode: self.viewModel.countryCode)
    }
    
    func addPhoneNumberFailed(msg: String) {
        ToastView.shared.showLongToast(self.view, msg: msg)
    }
    
    func forgotPasswordSuccess(msg: String) {
        ToastView.shared.showLongToast(self.view, msg: msg)
        AppRouter.goToOtpVerificationVC(vc: self,phoneNo: self.viewModel.phoneNo, countryCode: self.viewModel.countryCode,isComeForVerifyPassword: true)
    }
    
    func forgotPasswordFailed(msg: String, error: Error) {
        ToastView.shared.showLongToast(self.view, msg: msg)
    }
    
    func loginWithPhoneSuccess(msg: String, statusCode: Int) {
        ToastView.shared.showLongToast(self.view, msg: msg)
        AppRouter.goToOtpVerificationVC(vc: self,phoneNo: self.viewModel.phoneNo,countryCode:self.viewModel.countryCode)
    }
    
    func loginWithPhoneFailed(msg: String, error: Error) {
        ToastView.shared.showLongToast(self.view, msg: msg)
    }
    
}

// MARK: - CountryDelegate
//=========================
extension LoginWithPhoneVC : CountryDelegate{
    func sendCountryCode(code: String) {
        self.viewModel.countryCode = code
        self.countryCodeLbl.text = code
    }
}
