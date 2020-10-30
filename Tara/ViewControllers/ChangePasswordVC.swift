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
        
    }

}

extension ChangePasswordVC {
   
    private func initialSetup(){
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
}

extension ChangePasswordVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          let currentText = textField.text ?? ""
         guard let stringRange = Range(range, in: currentText) else { return false }
         let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
         return updatedText.count <= 20
    }
}
