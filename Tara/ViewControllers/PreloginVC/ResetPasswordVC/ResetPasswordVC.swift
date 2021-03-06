//
//  ResetPasswordVC.swift
//  ArabianTyres
//
//  Created by Admin on 08/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ResetPasswordVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var pleaseSetNewPasswordLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var confirmTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var newPassTxtField: SkyFloatingLabelTextField!
    // MARK: - Variables
    //===========================
    var viewModel = ResetPasswordVM()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
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
        self.dataContainerView.addShadow(cornerRadius: 4, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 4)
        self.submitBtn.round(radius: 4.0)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        self.hitResetPassApi()
    }
    
}

// MARK: - Extension For Functions
//===========================
extension ResetPasswordVC {
    
    private func initialSetup() {
        self.viewModel.delegate = self
        self.pleaseSetNewPasswordLbl.text = LocalizedString.pleaseSetNewPassword.localized
        self.titlelbl.text = LocalizedString.resetPassword.localized
        self.setUpTextField()
    }
    
    public func setUpTextField(){
        self.newPassTxtField.delegate = self
        self.confirmTxtField.delegate = self
        self.newPassTxtField.title = LocalizedString.newPassword.localized
        self.confirmTxtField.title = LocalizedString.confirmPassword.localized
        self.confirmTxtField.selectedTitle = LocalizedString.password.localized
        self.newPassTxtField.selectedTitle = LocalizedString.password.localized
        self.newPassTxtField.placeholder = LocalizedString.enterNewPassword.localized
        self.confirmTxtField.placeholder = LocalizedString.confirmNewPassword.localized
        [newPassTxtField,confirmTxtField].forEach({$0?.lineColor = AppColors.fontTertiaryColor})
        [newPassTxtField,confirmTxtField].forEach({$0?.selectedLineColor = AppColors.fontTertiaryColor})
        [newPassTxtField,confirmTxtField].forEach({$0?.selectedTitleColor = AppColors.fontTertiaryColor})
        self.newPassTxtField.isSecureTextEntry = true
        self.confirmTxtField.isSecureTextEntry = true
        let show = UIButton()
        show.isSelected = false
        show.addTarget(self, action: #selector(secureTextField(_:)), for: .touchUpInside)
        self.confirmTxtField.setButtonToRightView(btn: show, selectedImage: #imageLiteral(resourceName: "icPasswordView"), normalImage: #imageLiteral(resourceName: "icPasswordHide"), size: CGSize(width: 22, height: 22))
        let show1 = UIButton()
        show1.isSelected = false
        show1.addTarget(self, action: #selector(secureTextField1(_:)), for: .touchUpInside)
        self.newPassTxtField.setButtonToRightView(btn: show1, selectedImage: #imageLiteral(resourceName: "icPasswordView"), normalImage: #imageLiteral(resourceName: "icPasswordHide"), size: CGSize(width: 22, height: 22))
      self.submitBtn.setTitle(LocalizedString.submit.localized, for: .normal)
        self.submitBtn.isEnabled = false
    }
    
    @objc func secureTextField(_ sender: UIButton){
        sender.isSelected.toggle()
        self.confirmTxtField.isSecureTextEntry = !sender.isSelected
    }
    
    @objc func secureTextField1(_ sender: UIButton){
        sender.isSelected.toggle()
        self.newPassTxtField.isSecureTextEntry = !sender.isSelected
    }
    
    private func hitResetPassApi(){
        self.view.endEditing(true)
        if self.viewModel.checkResetPassValidations().status{
            self.viewModel.resetPassword(dict: getDict())
        }else{
            if !self.viewModel.checkResetPassValidations().message.isEmpty{
                ToastView.shared.showLongToast(self.view, msg: self.viewModel.checkResetPassValidations().message)
            }
        }
    }
    
    private func getDict() -> JSONDictionary{
        let dict : JSONDictionary = [ApiKey.password:  self.viewModel.newPassword,ApiKey.resetToken: self.viewModel.resetToken]
            return dict
    }
    
    private func resetBtnStatus()-> Bool{
        return !self.viewModel.newPassword.isEmpty && !self.viewModel.confirmNewPassword.isEmpty
    }
    
}

// MARK: - UITextFieldDelegate
//===============================
extension ResetPasswordVC: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        switch textField{
        case newPassTxtField:
            self.viewModel.newPassword = text
            self.submitBtn.isEnabled = resetBtnStatus()
        default:
            self.viewModel.confirmNewPassword = text
            self.submitBtn.isEnabled = resetBtnStatus()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        switch textField {
        case newPassTxtField:
            return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 16
        case confirmTxtField:
            return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 16
        default:
            return false
        }
    }
    
}

// MARK: - ResetPasswordVMDelegate
//===============================
extension ResetPasswordVC: ResetPasswordVMDelegate{
    func resetPasswordSuccess(message: String) {
        AppRouter.showSuccessPopUp(vc: self, title: LocalizedString.successful.localized, desc: LocalizedString.password_has_been_reset_successfully.localized)
    }
    
    func resetPasswordFailed(error: String) {
         ToastView.shared.showLongToast(self.view, msg: error)
    }
}

// MARK: - SuccessPopupVCDelegate
//===============================
extension ResetPasswordVC: SuccessPopupVCDelegate {
    func okBtnAction() {
        AppRouter.makeLoginVCRoot()
        self.dismiss(animated: true, completion: nil)
    }
}
