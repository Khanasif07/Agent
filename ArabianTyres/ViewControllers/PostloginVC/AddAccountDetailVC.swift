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
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var selectYourBankTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var enterAccountNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmAccountNumberTextField: SkyFloatingLabelTextField!

    // MARK: - Variables
    //===========================
   
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    private func changeBtnState(isHide: Bool){
        addBtn.backgroundColor = isHide ? AppColors.primaryBlueLightShade : AppColors.primaryBlueColor
        addBtn.setTitleColor(isHide ? AppColors.fontTertiaryColor : AppColors.backgrougnColor2, for: .normal)
        addBtn.isUserInteractionEnabled = !isHide
    }

}

// MARK: - Extension For Functions
//===========================
extension AddAccountDetailVC {
    
    private func initialSetup() {
        setupTextAndFont()
        changeBtnState(isHide: true)
    }
   
    private func setupTextAndFont(){
        headingLbl.font = AppFonts.NunitoSansBold.withSize(12.0)
       
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        helpBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(17.0)
        addBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)

        titleLbl.text = LocalizedString.addDetails.localized
        helpBtn.setTitle(LocalizedString.help.localized, for: .normal)
        addBtn.setTitle(LocalizedString.add.localized, for: .normal)
       
    }
}

