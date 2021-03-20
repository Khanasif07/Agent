//
//  ReceiverOfferCell.swift
//  Tara
//
//  Created by Admin on 09/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ReceiverOfferCell: UITableViewCell {
    
    @IBOutlet weak var offerPriceLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var msgContainerView: UIView!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var sarLbl: UILabel!

    var acceptBtnTapped:(()->())?
    var rejectBtnTapped:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        acceptBtn.setTitle(LocalizedString.accept.localized, for: .normal)
        rejectBtn.setTitle(LocalizedString.reject.localized, for: .normal)
        offerPriceLbl.text = LocalizedString.offerPrice.localized
        sarLbl.text = LocalizedString.sar.localized
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImgView.round()
        acceptBtn.round(radius: 4.0)
        rejectBtn.round(radius: 4.0)
        msgContainerView.roundCorners([.topLeft, .topRight, .bottomRight], radius: 15)
        userImgView.round()
    }

    @IBAction func acceptBtnAction(_ sender: UIButton) {
        acceptBtnTapped?()
    }
    
    @IBAction func rejectBtnAction(_ sender: UIButton) {
        rejectBtnTapped?()
    }
    
}
