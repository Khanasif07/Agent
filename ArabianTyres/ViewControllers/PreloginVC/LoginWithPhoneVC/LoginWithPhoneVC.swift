//
//  LoginWithPhoneVC.swift
//  ArabianTyres
//
//  Created by Admin on 04/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginWithPhoneVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var enterDigitLbl: UILabel!
    @IBOutlet weak var sendOtpBtn: UIButton!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var countryCodeLbl: UILabel!
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.dataContainerView.addShadow(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        self.sendOtpBtn.round(radius: 4.0)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension LoginWithPhoneVC {
    
    private func initialSetup() {
        self.setupTextField()
    }
    
    public func setupTextField(){
        self.phoneTextField.keyboardType = .numberPad
        self.phoneTextField.delegate = self
    }
}

// MARK: - Extension For TxtFieldDelegate
//===========================

extension LoginWithPhoneVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.location == 0 && (string == " ") {
            return false
        }
        return true
    }
}
