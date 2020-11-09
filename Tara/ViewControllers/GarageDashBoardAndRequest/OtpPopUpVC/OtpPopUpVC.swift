//
//  OtpPopUpVC.swift
//  ArabianTyres
//
//  Created by Arvind on 05/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit
import SkyFloatingLabelTextField


class OtpPopUpVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cancelBtn: AppButton!
    @IBOutlet weak var verifyBtn: AppButton!
    @IBOutlet var otpTxtFields: [OTPTextField]!
    @IBOutlet var txtFieldViews: [UIView]!
  
    
    // MARK: - Variables
    //===========================
    var otpArray = [String](repeating: "", count: 4)
    var viewModel = OtpPopUpVM()
    var requestByUser : String = ""
    var requestId : String = ""
    var onVerifyTap: (()->())?

    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        verifyBtn.isEnabled = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func verifyBtnAction(_ sender: UIButton) {
        let dict : JSONDictionary = [ApiKey.otp : self.otpArray.joined(), ApiKey.requestId : self.requestId]
        viewModel.startService(params: dict,loader : true)
    }
}

// MARK: - Extension For Functions
//===========================
extension OtpPopUpVC {
    
    private func initialSetup() {
        setupTextAndFont()
        setUpTextField()
        setUpAttributedString()
        self.viewModel.delegate = self
    }
    
    private func setupTextAndFont(){
        verifyBtn.setTitle(LocalizedString.verify.localized, for: .normal)
        cancelBtn.setTitle(LocalizedString.cancel.localized, for: .normal)
        verifyBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(16.0)
        cancelBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(16.0)

    }
    
    private func setUpTextField() {
        otpTxtFields[0].becomeFirstResponder()
        self.otpTxtFields.forEach { (otpTextField) in
            otpTextField.delegate = self
            otpTextField.otpDelegate = self
            otpTextField.keyboardType = .numberPad
        }
    }
    
    private func setUpAttributedString(){
        let attributedString = NSMutableAttributedString(string: LocalizedString.weHaveSent.localized, attributes: [
            .font: AppFonts.NunitoSansBold.withSize(14.0),
            .foregroundColor: AppColors.fontTertiaryColor
        ])
        attributedString.append(NSAttributedString(string: LocalizedString.otp.localized.uppercased(), attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontPrimaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(14.0)]))
       
        attributedString.append(NSAttributedString(string: LocalizedString.to.localized, attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontTertiaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(14.0)]))
        
        attributedString.append(NSAttributedString(string: requestByUser, attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontPrimaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(14.0)]))
        
        attributedString.append(NSAttributedString(string: ",\n", attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontTertiaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(14.0)]))
        
        attributedString.append(NSAttributedString(string: LocalizedString.pleaseVerifyTheSameInOrderToStartServicing.localized, attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontTertiaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(14.0)]))
        titleLbl.attributedText = attributedString
    }
    
    private func enterOTPText(index: Int, string: String, range: NSRange, isFirst: Bool = false, isLast: Bool = false) {
        otpTxtFields[index].text = string
        otpArray[index] = string
        txtFieldViews[index].backgroundColor = AppColors.appRedColor
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
    
    private func setUpVerifyButton(enable: Bool){
        verifyBtn.isEnabled = enable
    }
   
    
}

extension OtpPopUpVC : OTPTextFieldDelegate ,UITextFieldDelegate{
    
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
                self.setUpVerifyButton(enable: false)
                break
            } else {
                self.setUpVerifyButton(enable: true)
            }
        }
        return false
    }
}

extension OtpPopUpVC: OtpPopUpVMDelegate{
   
    func getStartServiceSuccess(msg: String) {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: Notification.Name.UpdateServiceStatus, object: nil)
            self.onVerifyTap?()
        }
    }
    
    func getStartServiceFailed(msg: String){
        CommonFunctions.showToastWithMessage(msg)
        self.dismiss(animated: true)
    }
}
