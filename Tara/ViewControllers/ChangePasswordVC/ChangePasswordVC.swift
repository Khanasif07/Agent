//
//  ChangePasswordVC.swift
//  Tara
//
//  Created by Arvind on 30/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit
import SkyFloatingLabelTextField

class ChangePasswordVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var oldPasswordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var newPasswordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPassWordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var submitBtn: AppButton!
    @IBOutlet weak var containerView: UIView!
    
    
    // MARK: - Variables
    //===========================
    var viewModel = ChangePasswordVM()
    var placeHolderArr : [String] = [LocalizedString.enterOldPassWord.localized,
                                     LocalizedString.enterNewPassWord.localized,
                                     LocalizedString.enterNewPassWord.localized
    ]
    
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
    @IBAction func backBtnAction(_sender : Any) {
        pop()
    }
    
    @IBAction func submitBtnAction(_sender : UIButton) {
        self.view.endEditing(true)
        if self.viewModel.checkChangePasswordValidations(parameters: self.viewModel.model.getDict()).status{
              self.viewModel.changePasswordData(params: self.viewModel.model.getDict())
        }else{
            if !self.viewModel.checkChangePasswordValidations(parameters: self.viewModel.model.getDict()).message.isEmpty{
                ToastView.shared.showLongToast(self.view, msg: self.viewModel.checkChangePasswordValidations(parameters: self.viewModel.model.getDict()).message)
            }
        }
        
    }
    
}

// MARK: - Extension
//===========================
extension ChangePasswordVC {
    
    private func initialSetup(){
        self.viewModel.delegate = self
        setupTextFont()
        submitBtn.isEnabled = false
        setUpTextField()
    }
    
    func setUpTextField(){
        for (index,txtField) in [oldPasswordTextField,newPasswordTextField,confirmPassWordTextField].enumerated() {
            txtField?.delegate = self
            txtField?.placeholder = placeHolderArr[index]
            txtField?.selectedTitleColor = AppColors.fontTertiaryColor
            txtField?.placeholderFont = AppFonts.NunitoSansRegular.withSize(15.0)
            txtField?.font = AppFonts.NunitoSansBold.withSize(14.0)
            txtField?.textColor = AppColors.fontPrimaryColor
            txtField?.setupPasswordTextField()
        }
    }
    
    private func setupTextFont() {
        titleLbl.font = AppFonts.NunitoSansSemiBold.withSize(17.0)
        titleLbl.text = LocalizedString.change_password.localized
        submitBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(16.0)
        submitBtn.setTitle(LocalizedString.submit.localized, for: .normal)
    }
    
    private func submitBtnStatus()-> Bool{
        return !self.viewModel.model.oldPass.isEmpty && !self.viewModel.model.newPass.isEmpty && !self.viewModel.model.confirmPass.isEmpty
    }
}

// MARK: - TextField Delegate
//===========================
extension ChangePasswordVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 25
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        switch textField {
        case oldPasswordTextField:
            self.viewModel.model.oldPass = text
            self.submitBtn.isEnabled = submitBtnStatus()
        case newPasswordTextField:
            self.viewModel.model.newPass = text
            self.submitBtn.isEnabled = submitBtnStatus()
        case confirmPassWordTextField:
            self.viewModel.model.confirmPass = text
            self.submitBtn.isEnabled = submitBtnStatus()
        default:
            printDebug("Do Nothing")
        }
        
    }
}

// MARK: - IBActions
//===========================
extension ChangePasswordVC : ChangePasswordVMDelegate{
    func changePasswordSuccess(msg: String) {
        self.pop()
    }
    
    func changePasswordFailed(msg: String, error: Error) {
        ToastView.shared.showLongToast(self.view, msg: msg)
    }
    
}
