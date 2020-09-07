//
//  SuccessPopupVC.swift
//  ArabianTyres
//
//  Created by Admin on 05/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

protocol SuccessPopupVCDelegate: class{
    func okBtnAction()
}

class SuccessPopupVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var successDescLbl: UILabel!
    @IBOutlet weak var successTitleLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    // MARK: - Variables
    //===========================
    
    weak var delegate: SuccessPopupVCDelegate?
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.dataContainerView.addShadow(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        self.okBtn.round(radius: 4.0)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func okBtnAction(_ sender: UIButton) {
        self.delegate?.okBtnAction()
    }
    
}

// MARK: - Extension For Functions
//===========================
extension SuccessPopupVC {
    
    private func initialSetup() {
        self.textSetUp()
        self.addBlurEffect()
    }
    
    public func textSetUp(title:String = "Successful",desc: String = "You have successfully reset your old password."){
        self.successDescLbl.text = desc
        self.successTitleLbl.text = title
    }
    
    private func addBlurEffect(){
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(blurEffectView)
    }
}
