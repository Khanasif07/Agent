//
//  ReceiverAudioCell.swift
//  Tara
//
//  Created by Admin on 04/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ReceiverAudioCell: UITableViewCell {

    @IBOutlet weak var receiverImgView: UIImageView!
    @IBOutlet weak var receiverNameLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var audioBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dataContainerView.roundCorners([.topLeft, .topRight, .bottomRight], radius: 15)
        receiverImgView.round()
        audioBtn.round()
    }
     
    
}
