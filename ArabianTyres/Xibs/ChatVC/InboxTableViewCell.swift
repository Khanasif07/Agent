//
//  InboxTableViewCell.swift
//  ArabianTyres
//
//  Created by Admin on 29/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class InboxTableViewCell: UITableViewCell {

    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var lastMsgLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var msgCountView: UIView!
    @IBOutlet weak var msgCountLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImgView.setImage_kf(imageString: "", placeHolderImage: #imageLiteral(resourceName: "placeHolder"), loader: false)
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImgView.round()
        msgCountView.round()
    }

}
