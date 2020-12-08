//
//  ContactUsVC.swift
//  Tara
//
//  Created by Arvind on 12/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ContactUsVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
 
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subjectTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sendMessageBtn: AppButton!
    @IBOutlet weak var customTextView: CustomTextView!
    @IBOutlet weak var tViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Variables
    //===========================
    let viewModel = EditProfileVM()
    var descText : String = ""
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        let height = customTextView.tView.text.heightOfText(self.customTextView.tView.width + 36, font: AppFonts.NunitoSansBold.withSize(16.0))
        printDebug(height)
        tViewHeightConstraint.constant = height + 32
        self.view.layoutIfNeeded()
    }
    
    // MARK: - IBActions
    //===========================
 
    @IBAction func backBtnAction(_ sender: UIButton) {
       pop()
    }
    
    
    @IBAction func sendMsgBtnAction(_ sender: UIButton) {
        viewModel.userQuery(params: [ApiKey.title: subjectTextField.text ?? "", ApiKey.description: customTextView.tView.text ?? ""], loader: true)
    }
    
    func sendBtnStatus() -> Bool {
        return !(subjectTextField.text?.isEmpty ?? true) && !(customTextView.tView.text == LocalizedString.description.localized) && ((descText ).count >= 5)
    }
}

// MARK: - Extension For Functions
//===========================
extension ContactUsVC {
    
    private func initialSetup() {
        sendMessageBtn.isEnabled = false
        setupTextAndFont()
        viewModel.delegate = self
        customTextView.delegate = self
        customTextView.charLimit = 250
        customTextView.tView.textColor = AppColors.fontTertiaryColor
        customTextView.placeHolderTxt = LocalizedString.description.localized
        customTextView.floatLbl.text = LocalizedString.description.localized
        customTextView.rightImgContainerView.isHidden = true
        customTextView.leftImgContainerView.isHidden = true
        
        subjectTextField.delegate = self
        subjectTextField.selectedTitleColor = AppColors.fontTertiaryColor
        subjectTextField.placeholderFont = AppFonts.NunitoSansBold.withSize(14.0)
        subjectTextField.font = AppFonts.NunitoSansBold.withSize(14.0)
    }
    
    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
      
    }
}

extension ContactUsVC : CustomTextViewDelegate , UITextFieldDelegate{
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 25
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        sendMessageBtn.isEnabled = sendBtnStatus()
    }
    
    func shouldBegin(_ tView: UITextView) {
        tView.textColor = AppColors.fontPrimaryColor
        customTextView.floatLbl.isHidden = false
        if tView.text == LocalizedString.description.localized {
            tView.text = ""
            descText = tView.text
        }
    }
    
    func endEditing(_ tView : UITextView) {
        if tView.text == ""{
            customTextView.floatLbl.isHidden = true
            customTextView.placeHolderTxt = LocalizedString.description.localized
            customTextView.floatLbl.text = LocalizedString.description.localized
        }
        descText = tView.text
        sendMessageBtn.isEnabled = sendBtnStatus()
    }
}

extension ContactUsVC : EditProfileVMDelegate{
  
    func userQuerySuccess(msg: String) {
        pop()
    }
    
    func userQueryFailure(msg: String){
    }
}

