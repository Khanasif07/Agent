//
//  CustommTextField.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

protocol SuccessPopUpViewDelegate: class {
    func successBtnAction()
    func yesBtnAction()
    func noBtnAction()
}



class CustommTextField: UIView {
    
//    weak var delegate: SuccessPopUpViewDelegate?
    
    @IBOutlet weak var dataContainerView: UIView!
    
    //MARK:- LifeCycle
    //================
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetUp()
    }
    
    
    
    // MARK: - IB Action
    
    
    

    //MARK:- PrivateFunctions
    //=======================
    //.InitialSetUp
    private func initialSetUp() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustommTextField", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.setUpFont()
        self.setUpText()
        self.setUpColor()
    }
    
    
   
    private func setUpText() {
        self.dataContainerView.layer.cornerRadius = 5.0
        self.dataContainerView.addShadow(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        //        self.title.text = "You can select 5 item(s) at a time, only one video allowed to upload and atleast one image is mandatory to upload."
    }
    
    private func setUpColor() {
    }
    
    private func setUpFont() {
//        self.titleLabel.font = AppFonts.Regular.withSize(28.0)
    }
    

   
}
