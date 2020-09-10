//
//  ProfileUserHeaderCell.swift
//  ArabianTyres
//
//  Created by Admin on 09/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ProfileUserHeaderCell: UITableViewCell {
    
    
    var phoneVerifyBtnTapped :((UIButton)->())?
    var emailVerifyBtnTapped :((UIButton)->())?
    
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var editProfileView: UIImageView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userPhoneNoLbl: UILabel!
    @IBOutlet weak var phoneNoVerifiedView: UIImageView!
    @IBOutlet weak var emailVerifyBtn: UIButton!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var emailVerifiedView: UIImageView!
    @IBOutlet weak var phoneVerifyBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.dataContainerView.addShadow(cornerRadius: 4, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 4)
        self.emailVerifyBtn.round(radius: 4.0)
        self.phoneVerifyBtn.round(radius: 4.0)
        self.profileImgView.round()
        self.editProfileView.round(radius: 4.0)
        self.emailVerifiedView.round()
        self.phoneNoVerifiedView.round()
    }
    
    func populateData(model: UserModel){
        profileImgView.setImage_kf(imageString: model.image, placeHolderImage: UIImage(), loader: true)
        userNameLbl.text = model.name.isEmpty ? "N/A" : "\(model.name)"
        userPhoneNoLbl.text = model.phoneNo.isEmpty ? "N/A" : "\(model.countryCode)" + " \(model.phoneNo)"
        userEmailLbl.text = model.email.isEmpty ? "N/A" : model.email
        phoneNoVerifiedView.isHidden = !model.phoneVerified
        phoneVerifyBtn.isHidden = model.phoneVerified
        emailVerifiedView.isHidden = !model.emailVerified
        emailVerifyBtn.isHidden = model.emailVerified
    }
    
    @IBAction func phoneVerifyBtnAction(_ sender: UIButton) {
        if let handle = phoneVerifyBtnTapped{
            handle(sender)
        }
    }
    
    @IBAction func emailVerifyBtnAction(_ sender: UIButton) {
        if let handle = phoneVerifyBtnTapped{
            handle(sender)
        }
    }
    
}
