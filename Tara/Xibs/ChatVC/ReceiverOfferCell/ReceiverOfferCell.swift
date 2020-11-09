//
//  ReceiverOfferCell.swift
//  Tara
//
//  Created by Admin on 09/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ReceiverOfferCell: UITableViewCell {
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var msgContainerView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        msgContainerView.roundCorners([.topLeft, .topRight, .bottomRight], radius: 15)
        userImgView.round()
    }

    
}
