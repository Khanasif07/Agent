//
//  ContactusPopupVC.swift
//  Tara
//
//  Created by Arvind on 12/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

class ContactusPopupVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var goToChatBtn: AppButton!
    @IBOutlet weak var contactUsBtn: AppButton!

    
    // MARK: - Variables
    //===========================
    var requestData: RequestModel? = nil
    var onContactUsBtnTapped : (()->())?

    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func goToChatBtnAction(_ sender: UIButton) {
        showAlert(msg: LocalizedString.underDevelopment.localized)
    }
    
    @IBAction func contactUsBtnAction(_ sender: UIButton) {
        dismiss(animated: true) {
            self.onContactUsBtnTapped?()
        }
    }
}

// MARK: - Extension For Functions
//===========================
extension ContactusPopupVC {
    
    private func initialSetup() {
        setupTextAndFont()
    }
    
    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
      
    }
}
