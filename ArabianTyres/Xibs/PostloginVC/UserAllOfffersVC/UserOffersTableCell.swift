//
//  UserOffersTableCell.swift
//  ArabianTyres
//
//  Created by Admin on 09/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class UserOffersTableCell: UITableViewCell {
    
    
    var viewProposalAction: ((UIButton)->())?

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
        if let handle = viewProposalAction{
            handle(sender)
        }
    }
    
    func bindData(_ model: UserBidModel) {
        distanceValueLbl.attributedText =  getAttributedString(value: "\(model.distance)",attributedLabel: distanceValueLbl)
        offerTitleLbl.text = model.garageName
        quantityValueLbl.text = model.bidData.first?.quantity.description
        BAValueLbl.attributedText = getAttributedString(value: model.bidData.first?.amount.description ?? "",attributedLabel: BAValueLbl)
       
        let totalAmount = String((model.bidData.first?.quantity ?? 0) * (model.bidData.first?.amount ?? 0))
        tAValueLbl.attributedText = getAttributedString(value: totalAmount,attributedLabel: tAValueLbl)
    }
    
    func getAttributedString(value : String,attributedLabel: UILabel) -> NSMutableAttributedString{
        
        var str: NSMutableAttributedString = NSMutableAttributedString()
        switch attributedLabel {
            case distanceValueLbl:
            str = NSMutableAttributedString(string: value, attributes: [
                .font: AppFonts.NunitoSansBold.withSize(17.0),
                .foregroundColor: AppColors.fontPrimaryColor
            ])
            str.append(NSAttributedString(string: "Miles", attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontSecondaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansSemiBold.withSize(12.0)]))
            
        case BAValueLbl:
            str = NSMutableAttributedString(string: value, attributes: [
                .font: AppFonts.NunitoSansBold.withSize(17.0),
                .foregroundColor: AppColors.successGreenColor
            ])
            str.append(NSAttributedString(string: "SAR", attributes: [NSAttributedString.Key.foregroundColor: AppColors.successGreenColor,NSAttributedString.Key.font: AppFonts.NunitoSansSemiBold.withSize(12.0)]))
           
            str.append(NSAttributedString(string: "/Piece", attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontSecondaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansSemiBold.withSize(12.0)]))
            
        case tAValueLbl:
            str = NSMutableAttributedString(string: value, attributes: [
                 .font: AppFonts.NunitoSansBold.withSize(17.0),
                 .foregroundColor: AppColors.fontPrimaryColor
             ])
             str.append(NSAttributedString(string: "SAR", attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontPrimaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansSemiBold.withSize(12.0)]))
            
        default:
            break
        }
        return str
    }

}
