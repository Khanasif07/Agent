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
    @IBOutlet weak var okBtn: AppButton!
    @IBOutlet weak var successDescLbl: UILabel!
    @IBOutlet weak var successTitleLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    
    // MARK: - Variables
    //===========================
    public var desc = ""
    public var titleLbl = ""
    
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
    
    public func textSetUp(){
        okBtn.isEnabled = true
        self.successDescLbl.text = self.desc
        self.successTitleLbl.text = self.titleLbl
    }
    
    private func addBlurEffect(){
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(blurEffectView)
    }
}
