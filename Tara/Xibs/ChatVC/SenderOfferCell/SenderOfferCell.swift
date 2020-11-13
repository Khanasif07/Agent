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
        userImgView.round()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func acceptBtnAction(_ sender: UIButton) {
         acceptBtnTapped?()
     }
     
     @IBAction func rejectBtnAction(_ sender: UIButton) {
         rejectBtnTapped?()

     }
    
}
