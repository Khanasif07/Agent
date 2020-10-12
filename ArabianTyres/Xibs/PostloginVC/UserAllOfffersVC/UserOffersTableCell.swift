//
//  UserOffersTableCell.swift
//  ArabianTyres
//
//  Created by Admin on 09/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class UserOffersTableCell: UITableViewCell {

    @IBOutlet weak var tALbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var bALbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var tAValueLbl: UILabel!
    @IBOutlet weak var distanceValueLbl: UILabel!
    @IBOutlet weak var BAValueLbl: UILabel!
    @IBOutlet weak var quantityValueLbl: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var offerSubTitleLbl: UILabel!
    @IBOutlet weak var offerTitleLbl: UILabel!
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var rejectBtn: AppButton!
    @IBOutlet weak var viewProposalBtn: AppButton!
    @IBOutlet weak var dataContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.backgroundColor = AppColors.fontTertiaryColor
        logoImgView.backgroundColor = AppColors.fontTertiaryColor
        rejectBtn.isBorderSelected = true
        viewProposalBtn.isEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logoImgView.round(radius: 4.0)
        ratingView.round(radius: 2.0)
        rejectBtn.round(radius: 4.0)
        viewProposalBtn.round(radius: 4.0)
        dataContainerView.addShadow(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
    }
    
    
    @IBAction func rejectBtnAction(_ sender: AppButton) {
    }
    
    @IBAction func viewProposalBtnAction(_ sender: AppButton) {
    }
    
    func bindData(_ model: UserBidModel) {
        distanceValueLbl.text = model.distance.description
        offerTitleLbl.text = model.garageName
    }
}
