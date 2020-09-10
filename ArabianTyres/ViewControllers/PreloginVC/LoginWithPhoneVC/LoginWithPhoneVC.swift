//
//  LoginWithPhoneVC.swift
//  ArabianTyres
//
//  Created by Admin on 04/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginWithPhoneVC: BaseVC {
    
    var viewModel = LoginWithPhoneViewModel()
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var enterDigitLbl: UILabel!
    @IBOutlet weak var sendOtpBtn: UIButton!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var countryCodeLbl: UILabel!
    // MARK: - Variables
    //===========================
    
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        self.viewModel.delegate = self
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        if self.viewModel.isComefromForgotpass{
            self.forgotPassword()
        } else {
            self.sendOtp()
        }
    }
}

// MARK: - Extension For Functions
//===========================
extension LoginWithPhoneVC {
    
    private func initialSetup() {
        self.viewModel.delegate = self
        self.setupTextField()
        self.sendOtpBtnStatus(enable: false)
        if self.viewModel.isComefromForgotpass {
            self.loginTitle.text = LocalizedString.forgotPassword.localized
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
    }
    
    public func sendOtpBtnStatus(enable: Bool){
        self.sendOtpBtn.alpha = enable ? 1.0 : 0.5
        self.sendOtpBtn.isEnabled = enable
    }
    
    private func getDict() -> JSONDictionary{
        if self.viewModel.isComefromForgotpass {
            let dict : JSONDictionary = [ApiKey.phoneNo:  self.viewModel.phoneNo,ApiKey.countryCode: self.viewModel.countryCode]
            return dict
        } else {
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
            sendOtpBtnStatus(enable: newString.length >= 10)
            return (string.checkIfValidCharaters(.mobileNumber) || string.isEmpty) && newString.length <= 16
        default:
            return false
        }
    }
}

// MARK: - LoginWithPhoneVMDelegate
//=================================
extension LoginWithPhoneVC: LoginWithPhoneVMDelegate {
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
