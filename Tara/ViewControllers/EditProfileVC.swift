//
//  EditProfileVC.swift
//  Tara
//
//  Created by Arvind on 30/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

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
    var placeHolderArr : [String] = [LocalizedString.name.localized,
                                     LocalizedString.emailID.localized,
                                     LocalizedString.mobileNo.localized
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
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_sender : Any) {
        pop()
    }
    
    @IBAction func saveBtnAction(_sender : UIButton) {
        
    }
    
    @IBAction func editBtnAction(_sender : UIButton) {
        
    }
    
    @IBAction func countryCodeTapped(_ sender: UIButton) {
          AppRouter.showCountryVC(vc: self)
      }
      
}

extension EditProfileVC: UITextFieldDelegate {
   
    private func initialSetup(){
        saveBtn.isEnabled = true
        setUpTextField()
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
        self.countryCodeLbl.text = "+91"
        titleLbl.font = AppFonts.NunitoSansSemiBold.withSize(17.0)
        titleLbl.text = LocalizedString.editProfile.localized
        saveBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(16.0)
        saveBtn.setTitle(LocalizedString.save.localized, for: .normal)
    }
}

// MARK: - CountryDelegate
//=========================
extension EditProfileVC : CountryDelegate{
    func sendCountryCode(code: String) {
        self.countryCodeLbl.text = code
    }
}
