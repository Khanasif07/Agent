//
//  UserOffersTableCell.swift
//  ArabianTyres
//
//  Created by Admin on 09/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class UserOffersTableCell: UITableViewCell {
    
    var rejectAction: ((UIButton)->())?
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
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var ratingImgView: UIImageView!
    @IBOutlet weak var imgBlurView :UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.backgroundColor = AppColors.fontTertiaryColor
        logoImgView.backgroundColor = AppColors.fontTertiaryColor
        bALbl.text = LocalizedString.bid_Amount.localized
        tALbl.text = LocalizedString.total_Amount.localized
        distanceLbl.text = LocalizedString.distance.localized
        quantityLbl.text = LocalizedString.quantityShort.localized
        rejectBtn.isBorderSelected = true
        viewProposalBtn.isEnabled = true
        blurView.isHidden = true
        imgBlurView.isHidden = true
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
        if let handle = rejectAction{
                  handle(sender)
              }
    }
    
    @IBAction func viewProposalBtnAction(_ sender: AppButton) {
        if let handle = viewProposalAction{
            handle(sender)
        }
    }
    
    func bindData(_ model: UserBidModel,isBidAccepted : Bool) {
        ratingLbl.text = String(format: "%.1f", (model.garageRating ?? 0.0))
        offerSubTitleLbl.text = model.garageAddress ?? "N/A"
        let distance = model.distance ?? 0.0
        distanceValueLbl.attributedText =  getAttributedString(value: "\(distance.truncate(places: 3))",attributedLabel: distanceValueLbl)
        offerTitleLbl.text = model.garageName
        quantityValueLbl.text = model.getMinAmount().1.description
        BAValueLbl.attributedText = getAttributedString(value: model.getMinAmount().2.description,attributedLabel: BAValueLbl)
        
        let totalAmount = String((model.getMinAmount().0))
        tAValueLbl.attributedText = getAttributedString(value: totalAmount,attributedLabel: tAValueLbl)
        logoImgView.setImage_kf(imageString: model.logo ?? "")
        if isBidAccepted {
            model.status == ApiKey.accepted ? changeWithBlurView(isAdded: true) : changeWithBlurView(isAdded: false)
            viewProposalBtn.setTitle(model.status == ApiKey.accepted ? LocalizedString.chat.localized : LocalizedString.viewProposal.localized, for: .normal)
        }
        else {
            changeWithBlurView(isAdded: true)
            viewProposalBtn.setTitle(LocalizedString.viewProposal.localized, for: .normal)
        }
        
        if let paymentStatus = model.paymentStatus{
            if paymentStatus == .paid{
                rejectBtn.isHidden = true
            }
        }
    }
    
    func getAttributedString(value : String,attributedLabel: UILabel) -> NSMutableAttributedString{
        
        var str: NSMutableAttributedString = NSMutableAttributedString()
        switch attributedLabel {
            case distanceValueLbl:
            str = NSMutableAttributedString(string: value, attributes: [
                .font: AppFonts.NunitoSansBold.withSize(17.0),
                .foregroundColor: AppColors.fontPrimaryColor
            ])
            str.append(NSAttributedString(string: LocalizedString.miles.localized, attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontSecondaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansSemiBold.withSize(12.0)]))
            
        case BAValueLbl:
            str = NSMutableAttributedString(string: value, attributes: [
                .font: AppFonts.NunitoSansBold.withSize(17.0),
                .foregroundColor: AppColors.successGreenColor
            ])
            str.append(NSAttributedString(string: LocalizedString.sar.localized, attributes: [NSAttributedString.Key.foregroundColor: AppColors.successGreenColor,NSAttributedString.Key.font: AppFonts.NunitoSansSemiBold.withSize(12.0)]))
           
            str.append(NSAttributedString(string: "/Piece", attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontSecondaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansSemiBold.withSize(12.0)]))
            
        case tAValueLbl:
            str = NSMutableAttributedString(string: value, attributes: [
                 .font: AppFonts.NunitoSansBold.withSize(17.0),
                 .foregroundColor: AppColors.fontPrimaryColor
             ])
            str.append(NSAttributedString(string: LocalizedString.sar.localized, attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontPrimaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansSemiBold.withSize(12.0)]))
            
        default:
            break
        }
        return str
    }

    func changeWithBlurView(isAdded: Bool) {
        imgBlurView.isHidden = isAdded
        blurView.isUserInteractionEnabled = isAdded
        ratingImgView.backgroundColor =  isAdded ? #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) : #colorLiteral(red: 0.7642653584, green: 0.7569509149, blue: 0.7566949725, alpha: 1)
        ratingView.backgroundColor =  isAdded ? #colorLiteral(red: 0.5411764706, green: 0.5843137255, blue: 0.6196078431, alpha: 0.15) : #colorLiteral(red: 0.9171934724, green: 0.9099001288, blue: 0.9096190333, alpha: 1)
        offerTitleLbl.textColor =  isAdded ? AppColors.fontPrimaryColor : #colorLiteral(red: 0.1098039216, green: 0.1137254902, blue: 0.1411764706, alpha: 0.5)
        offerSubTitleLbl.textColor = isAdded ? AppColors.fontSecondaryColor : #colorLiteral(red: 0.3294117647, green: 0.337254902, blue: 0.3607843137, alpha: 0.5)
        quantityLbl.textColor =   isAdded ? AppColors.fontTertiaryColor :#colorLiteral(red: 0.7647058824, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        bALbl.textColor =   isAdded ? AppColors.fontTertiaryColor : #colorLiteral(red: 0.7642653584, green: 0.7569509149, blue: 0.7566949725, alpha: 1)
        distanceLbl.textColor =  isAdded ? AppColors.fontTertiaryColor : #colorLiteral(red: 0.7642653584, green: 0.7569509149, blue: 0.7566949725, alpha: 1)
        tALbl.textColor =   isAdded ? AppColors.fontTertiaryColor : #colorLiteral(red: 0.7642653584, green: 0.7569509149, blue: 0.7566949725, alpha: 1)
        quantityValueLbl.textColor = isAdded ? AppColors.fontPrimaryColor :  #colorLiteral(red: 0.1098039216, green: 0.1137254902, blue: 0.1411764706, alpha: 0.5)
        if !isAdded {
            BAValueLbl.textColor =  #colorLiteral(red: 0.1098039216, green: 0.1137254902, blue: 0.1411764706, alpha: 0.5)
            distanceValueLbl.textColor =  #colorLiteral(red: 0.1098039216, green: 0.1137254902, blue: 0.1411764706, alpha: 0.5)
            tAValueLbl.textColor =  #colorLiteral(red: 0.1098039216, green: 0.1137254902, blue: 0.1411764706, alpha: 0.5)
        }
        ratingLbl.textColor = isAdded ? AppColors.fontPrimaryColor : #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.5)
        
        dataContainerView.backgroundColor = isAdded ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        viewProposalBtn.backgroundColor = isAdded ? AppColors.appRedColor : #colorLiteral(red: 0.6348647475, green: 0.6275323629, blue: 0.6272975802, alpha: 1)
        viewProposalBtn.setTitleColor( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        rejectBtn.backgroundColor =  #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        rejectBtn.setTitleColor(isAdded ? AppColors.appRedColor : #colorLiteral(red: 0.6348647475, green: 0.6275323629, blue: 0.6272975802, alpha: 1), for: .normal)
        rejectBtn.borderColor =  #colorLiteral(red: 0.6348647475, green: 0.6275323629, blue: 0.6272975802, alpha: 1)
        
    }
    
    func getMiles(meters: Double) -> Double {
         return meters * 0.000621371192
    }
}
