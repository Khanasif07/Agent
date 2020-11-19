//
//  SenderOfferCell.swift
//  Tara
//
//  Created by Arvind on 12/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SenderOfferCell: UITableViewCell {
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var msgContainerView: UIView!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var btnStackView: UIStackView!

    var acceptBtnTapped:(()->())?
    var rejectBtnTapped:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnStackView.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        msgContainerView.roundCorners([.topLeft, .topRight, .bottomLeft], radius: 15)
        acceptBtn.round(radius: 4.0)
        rejectBtn.round(radius: 4.0)
        userImgView.round()
    }

    
    @IBAction func acceptBtnAction(_ sender: UIButton) {
         acceptBtnTapped?()
     }
     
     @IBAction func rejectBtnAction(_ sender: UIButton) {
         rejectBtnTapped?()

     }
    
}
