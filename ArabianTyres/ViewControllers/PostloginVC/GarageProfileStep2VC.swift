//
//  GarageProfileStep2.swift
//  ArabianTyres
//
//  Created by Arvind on 15/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

//class GarageProfileStep2VC: BaseVC {
//
//    // MARK: - IBOutlets
//    //===========================
//
//    @IBOutlet weak var titleLbl: UILabel!
//    @IBOutlet weak var helpBtn: UIButton!
//    @IBOutlet weak var headingLbl: UILabel!
//    @IBOutlet weak var saveAndContinueBtn: AppButton!
//
//    // MARK: - Variables
//    //===========================
//
//    // MARK: - Lifecycle
//    //===========================
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        initialSetup()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
//    }
//    // MARK: - IBActions
//    //===========================
//
//    @IBAction func backBtnAction(_ sender: UIButton) {
//        self.pop()
//    }
//
//    @IBAction func helpBtnAction(_ sender: UIButton) {
//        self.pop()
//    }
//
//    @IBAction func saveAndContinueAction(_ sender: UIButton) {
//        printDebug(GarageProfileModel.shared.getGarageProfileDict())
//        viewModel.setGarageRegistration(params: GarageProfileModel.shared.getGarageProfileDict())
//    }
//
//
//}
//
//// MARK: - Extension For Functions
////===========================
//extension GarageProfileStep2VC {
//
//    private func initialSetup() {
//        setupTextAndFont()
//        setupTextField()
//        saveAndContinueBtn.isEnabled = false
//    }
//
//    private func setupTextAndFont(){
//        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
//        headingLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
//        helpBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(17.0)
//        saveAndContinueBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
//
//        titleLbl.text = LocalizedString.completeProfile.localized
//        headingLbl.text = LocalizedString.pleaseEnterYourBankAccountDetails.localized
//        helpBtn.setTitle(LocalizedString.help.localized, for: .normal)
//        saveAndContinueBtn.setTitle(LocalizedString.saveContinue.localized, for: .normal)
//
//    }
//
//    private func setupTextField(){
//        for (index,txtField) in [selectYourBankTextField,enterAccountNumberTextField,confirmAccountNumberTextField].enumerated() {
//            txtField?.delegate = self
//            txtField?.placeholder = placeHolderArr[index]
//            txtField?.title = titleArr[index]
//            txtField?.placeholderFont = AppFonts.NunitoSansBold.withSize(14.0)
//            txtField?.font = AppFonts.NunitoSansBold.withSize(14.0)
//        }
//        selectYourBankTextField.setImageToRightView(img: #imageLiteral(resourceName: "group3689"), size: CGSize(width: 15.0, height: 15.0))
//        enterAccountNumberTextField.keyboardType = .numberPad
//        confirmAccountNumberTextField.keyboardType = .numberPad
//    }
//}
