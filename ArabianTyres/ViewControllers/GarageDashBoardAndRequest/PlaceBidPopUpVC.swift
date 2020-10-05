//
//  PlaceBidPopUpVC.swift
//  ArabianTyres
//
//  Created by Arvind on 05/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class PlaceBidPopUpVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var placeBidLbl: UILabel!
    @IBOutlet weak var sarLbl: UILabel!
    @IBOutlet weak var amountDescLbl: UILabel!
    @IBOutlet weak var amountTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var notNowBtn: AppButton!
    @IBOutlet weak var placeBidBtn: AppButton!
    
   
    // MARK: - Variables
    //===========================

    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func notNowBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func placeBidBtnAction(_ sender: UIButton) {
        
    }
}

// MARK: - Extension For Functions
//===========================
extension PlaceBidPopUpVC {
    
    private func initialSetup() {
        setupTextAndFont()
    }
    
    private func setupTextAndFont(){
        amountTextField.placeholder = LocalizedString.enterBiddingAmount.localized
        amountTextField.delegate = self
        amountTextField.keyboardType = .numberPad
        
        placeBidLbl.text = LocalizedString.placeBid.localized
        amountDescLbl.text = LocalizedString.biddingAmountOnceSubmittedWillNeverBeChanged.localized
        sarLbl.text = LocalizedString.sar.localized
        notNowBtn.setTitle(LocalizedString.notNow.localized, for: .normal)
        placeBidBtn.setTitle(LocalizedString.placeABid.localized, for: .normal)
  
        placeBidLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        amountDescLbl.font = AppFonts.NunitoSansSemiBold.withSize(12.0)
        notNowBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(16.0)
        placeBidBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(16.0)

    }
}

extension PlaceBidPopUpVC :UITextFieldDelegate{
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 10
    }
}
