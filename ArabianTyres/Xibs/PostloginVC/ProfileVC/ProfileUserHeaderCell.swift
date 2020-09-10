//
//  ProfileUserHeaderCell.swift
//  ArabianTyres
//
//  Created by Admin on 09/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ProfileUserHeaderCell: UITableViewCell {
    
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var editProfileView: UIImageView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userPhoneNoLbl: UILabel!
    @IBOutlet weak var phoneNoVerifiedView: UIImageView!
    @IBOutlet weak var emailVerifyBtn: UIButton!
    @IBOutlet weak var userEmailLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.dataContainerView.addShadow(cornerRadius: 4, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 4)
        self.emailVerifyBtn.round(radius: 4.0)
        self.profileImgView.round()
        self.editProfileView.round(radius: 4.0)
        self.phoneNoVerifiedView.round()
    }
    
    func populateData(model: UserModel){
        profileImgView.setImage_kf(imageString: model.image, placeHolderImage: UIImage(), loader: true)
        userNameLbl.text = model.name
        userPhoneNoLbl.text = model.phoneNo.isEmpty ? "N/A" : "\(model.countryCode)" + " \(model.phoneNo)"
        userEmailLbl.text = model.email.isEmpty ? "N/A" : model.email
    }
    
}
