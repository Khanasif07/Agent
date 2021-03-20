//
//  LoginSocialTableCell.swift
//  ArabianTyres
//
//  Created by Admin on 04/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class LoginSocialTableCell: UITableViewCell {

    //MARK:-IBOutlets

    @IBOutlet weak var fbBtnView: UIView!
    @IBOutlet weak var googleBtnView: UIView!
    @IBOutlet weak var faceboookBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var loginSocialLbl: UILabel!
    @IBOutlet weak var socialBtnStackView: UIStackView!

    //MARK:-Variables
    var appleBtnTapped: (()->())?
    var googleBtnTapped: (()->())?
    var fbBtnTapped: (()->())?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.loginSocialLbl.text = LocalizedString.login_with_Social_Accounts.localized
        self.setUpButtonInset()
        faceboookBtn.semanticContentAttribute = .forceLeftToRight
        googleBtn.semanticContentAttribute = .forceLeftToRight

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.fbBtnView.addShadow(cornerRadius: 4, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 4)
        self.googleBtnView.addShadow(cornerRadius: 4, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 4)
    }
    
    public func setUpButtonInset(){
        googleBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 25.0, bottom: 0, right: 0)
//        appleBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 45.0, bottom: 0, right: 0)
//        appleBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 17.0, bottom: 0, right: 0)
        faceboookBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 25.0, bottom: 0, right: 0)
    }
    
    @IBAction func googleBtnAction(_ sender: UIButton) {
        googleBtnTapped?()

    }
    
    @IBAction func fbBtnAction(_ sender: UIButton) {
        fbBtnTapped?()
    }
}
