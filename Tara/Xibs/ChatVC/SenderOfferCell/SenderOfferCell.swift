//
//  SenderOfferCell.swift
//  Tara
//
//  Created by Arvind on 12/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SenderOfferCell: UITableViewCell {
    
    @IBOutlet weak var offerPriceLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var msgContainerView: UIView!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var btnStackView: UIStackView!
    @IBOutlet weak var sarLbl: UILabel!

//    @IBOutlet weak var deliveredImgview: UIImageView!
//    @IBOutlet weak var readImageView: UIImageView!

    var acceptBtnTapped:(()->())?
    var rejectBtnTapped:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        acceptBtn.setTitle(LocalizedString.accept.localized, for: .normal)
        rejectBtn.setTitle(LocalizedString.reject.localized, for: .normal)
        sarLbl.text = LocalizedString.sar.localized
        offerPriceLbl.text = LocalizedString.offerPrice.localized
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
