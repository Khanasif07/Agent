//
//  OtpVerificationVC.swift
//  ArabianTyres
//
//  Created by Admin on 05/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

class OtpVerificationVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var phoneNoLbl: UILabel!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var verifyBtn: AppButton!
    @IBOutlet var otpTxtFields: [OTPTextField]!
    @IBOutlet var txtFieldViews: [UIView]!
    
    // MARK: - Variables
    //===========================
    var otpArray = [String](repeating: "", count: 4)
    var viewModel = OtpVerificationVM()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        self.tabBarController?.tabBar.isHidden = true
        verifyBtn.isEnabled = false
        resendBtn.isEnabled = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.verifyBtn.round(radius: 4.0)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func verifyBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.viewModel.isComeForVerifyPassword{
            self.viewModel.verifyForgotPasswordOTP(dict: getDict())
        } else {
             self.viewModel.verifyOTP(dict: getDict())
        }
    }
    
    @IBAction func resendOtpBtnAction(_ sender: UIButton) {
        self.viewModel.resendOTP(dict: getDictForResendOtp())
        self.otpTxtFields.forEach({$0.text = ""})
        self.txtFieldViews.forEach({$0.backgroundColor = AppColors.fontTertiaryColor})
        self.otpArray = [String](repeating: "", count: 4)
        timerLbl.isHidden = false
        otpTxtFields[0].becomeFirstResponder()
        startTimer()
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
}

// MARK: - Extension For Functions
//===========================
extension OtpVerificationVC {
    
    private func initialSetup() {
        self.viewModel.delegate = self
        setupText()
        self.resendBtn.isEnabled = false
        self.setUpTextField()
        self.timerLbl.isHidden = false
        self.startTimer()
    }
    
    private func setUpTextField() {
        otpTxtFields[0].becomeFirstResponder()
        self.otpTxtFields.forEach { (otpTextField) in
            otpTextField.delegate = self
            otpTextField.otpDelegate = self
            otpTextField.keyboardType = .numberPad
        }
    }
    
    private func setupText() {
        self.phoneNoLbl.text = self.viewModel.phoneNo
        self.countryCodeLbl.text = self.viewModel.countryCode
    }
    
    private func startTimer() {
        viewModel.totalTime = 60
        viewModel.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    @objc private func updateTime() {
        let time  = "\(viewModel.timeFormatted(viewModel.totalTime))"
        timerLbl.text = time
        if viewModel.totalTime != 0 {
            viewModel.totalTime -= 1
        } else {
            endTimer()
            self.resendBtn.isEnabled = true
        }
    }
    
    private func endTimer() {
        timerLbl.isHidden = true
        viewModel.countdownTimer.invalidate()
    }
    
    private func setUpSubmitButton(enable: Bool){
        verifyBtn.isEnabled = enable
    }
    
    
    private func getDictForResendOtp() -> JSONDictionary{
            let dict : JSONDictionary = [ApiKey.phoneNo:  self.viewModel.phoneNo,ApiKey.countryCode: self.viewModel.countryCode, ApiKey.device : [ApiKey.platform : "ios", ApiKey.token : DeviceDetail.deviceToken].toJSONString() ?? ""]
            return dict
    }
    
    private func getDict() -> JSONDictionary {
        if self.viewModel.isComeForVerifyPassword{
            let dict : JSONDictionary = [ApiKey.phoneNo : self.viewModel.phoneNo , ApiKey.countryCode : self.viewModel.countryCode,ApiKey.otp: self.otpArray.joined()]
            return dict
        }else{
            let dict : JSONDictionary = [ApiKey.phoneNo : self.viewModel.phoneNo , ApiKey.countryCode : self.viewModel.countryCode,ApiKey.otp: self.otpArray.joined(), ApiKey.device : [ApiKey.platform : "ios",ApiKey.token : DeviceDetail.deviceToken].toJSONString() ?? [:]]
            return dict
        }
    }
}

//MARK:- OTPTextFieldDelegate
//=======================================
extension OtpVerificationVC: OTPTextFieldDelegate ,UITextFieldDelegate{
    
    func deleteBackward(index: Int) {
        if index != 0 {
            otpTxtFields[index].resignFirstResponder()
            otpTxtFields[index - 1].becomeFirstResponder()
            txtFieldViews[index].backgroundColor = AppColors.fontTertiaryColor
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.location == 0 && (string == " ") {
            return false
        }
        
        if otpTxtFields.contains(textField as! OTPTextField){
            switch textField.tag {
            case 0:
                enterOTPText(index: 0, string: string, range: range, isFirst: true, isLast: false)
            case 1:
                enterOTPText(index: 1, string: string, range: range)
            case 2:
                enterOTPText(index: 2, string: string, range: range)
            case 3:
                enterOTPText(index: 3, string: string, range: range, isFirst: false, isLast: true)
            default:
                break
            }
        }
        
        for verifyTextField in otpTxtFields {
            if verifyTextField.textValue.isEmpty {
                txtFieldViews[verifyTextField.tag].backgroundColor = AppColors.fontTertiaryColor
                self.setUpSubmitButton(enable: false)
                break
            } else {
                self.setUpSubmitButton(enable: true)
            }
        }
        return false
    }
    
    private func enterOTPText(index: Int, string: String, range: NSRange, isFirst: Bool = false, isLast: Bool = false) {
        otpTxtFields[index].text = string
        otpArray[index] = string
        txtFieldViews[index].backgroundColor = AppColors.warningYellowColor
        if (range.length == 0) {
            if index == 3 {
                self.otpTxtFields[index].resignFirstResponder()
            } else {
                self.otpTxtFields[index + 1].becomeFirstResponder()
            }
        } else {
            if index == 0 {
                self.otpTxtFields[index].becomeFirstResponder()
            } else {
                self.otpTxtFields[index - 1].becomeFirstResponder()
            }
        }
    }
    
}

//MARK:- SuccessPopupVCDelegate
//=======================================
extension OtpVerificationVC: SuccessPopupVCDelegate{
    func okBtnAction() {
        self.dismiss(animated: true, completion: nil)
        AppRouter.goToUserHome()
    }
}

//MARK:- SuccessPopupVCDelegate
//=======================================
extension OtpVerificationVC: OtpVerificationVMDelegate{
    func resendOtpSuccess(message: String) {
        setUpSubmitButton(enable: false)
        self.resendBtn.isEnabled = false
    }
    
    func resendOtpFailed(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func otpVerificationFailed(error:String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func otpVerifiedSuccessfully(message: String) {
        AppRouter.showSuccessPopUp(vc: self,title: "OTP Verified",desc: "You have successfully verified your mobile no.")
    }
    
    func verifyForgotPasswordOTPSuccess(message: String) {
        ToastView.shared.showLongToast(self.view, msg: message)
        AppRouter.goToResetPasswordVC(vc: self,resetToken: self.viewModel.resetToken)
    }
    
    func verifyForgotPasswordOTPFailed(error:String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
}
