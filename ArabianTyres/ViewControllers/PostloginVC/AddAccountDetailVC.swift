//
//  AddAccountDetailVC.swift
//  ArabianTyres
//
//  Created by Arvind on 14/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AddAccountDetailVC: BaseVC {

    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var helpBtn: UIButton!
    @IBOutlet weak var addBtn: AppButton!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var selectYourBankTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var enterAccountNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmAccountNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var containerView: UIView!

    
    // MARK: - Variables
    //===========================
    var placeHolderArr : [String] = [LocalizedString.selectYourBank.localized,
                                     LocalizedString.enterAccountNumber.localized,
                                     LocalizedString.confirmAccountNumber.localized
                                    ]
    var titleArr : [String] = [LocalizedString.selectBank.localized,
                               LocalizedString.AccountNo.localized,
                               LocalizedString.confirmAccountNo.localized
                              ]
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
    // MARK: - IBActions
    //===========================
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func helpBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func addBtnAction(_ sender: UIButton) {
        self.pop()
    }

}

// MARK: - Extension For Functions
//===========================
extension AddAccountDetailVC {
    
    private func initialSetup() {
        setupTextAndFont()
        setupTextField()
        addBtn.isEnabled = false
    }
   
    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        headingLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        helpBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(17.0)
        addBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)

        titleLbl.text = LocalizedString.addDetails.localized
        headingLbl.text = LocalizedString.pleaseEnterYourBankAccountDetails.localized
        helpBtn.setTitle(LocalizedString.help.localized, for: .normal)
        addBtn.setTitle(LocalizedString.add.localized, for: .normal)
       
    }
    
    private func setupTextField(){
        for (index,txtField) in [selectYourBankTextField,enterAccountNumberTextField,confirmAccountNumberTextField].enumerated() {
            txtField?.delegate = self
            txtField?.placeholder = placeHolderArr[index]
            txtField?.title = titleArr[index]
            txtField?.placeholderFont = AppFonts.NunitoSansBold.withSize(14.0)
            txtField?.font = AppFonts.NunitoSansBold.withSize(14.0)
        }
    }
}


extension AddAccountDetailVC: UITextFieldDelegate {
    
}
