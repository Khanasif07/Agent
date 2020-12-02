//
//  ProfileUserInternalCell.swift
//  ArabianTyres
//
//  Created by Admin on 09/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ProfileUserInternalCell: UITableViewCell {
    
    @IBOutlet weak var langLbl: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImgView.setBorder(width: 1.0, color: UIColor.init(r: 225, g: 239, b: 244, alpha: 1.0))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImgView.round(radius: 4.0)
    }
    
    public func populateCell(title: String,img: UIImage){
        self.langLbl.isHidden = (title == LocalizedString.changeLanguage.localized) ? false : true
        langLbl.text = CommonFunctions.isEnglishSelected() ? "EN" : "AR"
        profileImgView.image = img
        titleLbl.text = title
    }
}
