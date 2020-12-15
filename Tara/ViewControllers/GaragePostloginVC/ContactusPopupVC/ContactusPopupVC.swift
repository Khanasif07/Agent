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
    var chatBtnTapped : (()->())?

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
        dismiss(animated: true) {
            self.chatBtnTapped?()
        }
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
        titleLbl.text = LocalizedString.do_you_have_an_issue_with_service.localized
      
    }
}
