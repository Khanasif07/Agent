//
//  ServiceRequestTableCell.swift
//  ArabianTyres
//
//  Created by Admin on 05/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ServiceRequestTableCell: UITableViewCell {

    @IBOutlet weak var statusValueLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var brandsLbl: UILabel!
    @IBOutlet weak var tyreSizeLbl: UILabel!
    @IBOutlet weak var sizeDetailLbl: UILabel!
    @IBOutlet weak var brandDetailLbl: UILabel!

    @IBOutlet weak var serviceTimeLbl: UILabel!
    @IBOutlet weak var serviceTyeLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var ratingImgView: UIImageView!
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var placeBidBtn: AppButton!
    @IBOutlet weak var rejectRequestBtn: AppButton!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var dataContainerView: UIView!
    
    @IBOutlet weak var bidAmountStackView: UIStackView!
    @IBOutlet weak var bidAmountLbl: UILabel!
    @IBOutlet weak var bidAmountValueLbl: UILabel!

    
    var rejectRequestBtnTapped: (()->())?
    var placeBidBtnTapped: ((_ sender: UIButton)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logoImgView.round(radius: 4.0)
        placeBidBtn.round(radius: 2.0)
        rejectRequestBtn.round(radius: 2.0)
        ratingImgView.round(radius: 4.0)
        ratingView.round(radius: 2.0)
        dataContainerView.addShadow(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
    }
    
    
    @IBAction func placeBidAction(_ sender: AppButton) {
        if let handle = placeBidBtnTapped{
            handle(sender)
        }
    }
    
    @IBAction func placeRequestBtnAction(_ sender: AppButton) {
        rejectRequestBtnTapped?()
    }
    
    public func initialSetUp(){
        brandsLbl.isHidden = false
        brandDetailLbl.isHidden = false
        bidAmountStackView.isHidden = true
        self.logoImgView.backgroundColor = AppColors.fontTertiaryColor
        placeBidBtn.isEnabled = true
        brandsLbl.textColor = AppColors.fontTertiaryColor
        tyreSizeLbl.textColor = AppColors.fontTertiaryColor
        statusLbl.textColor = AppColors.fontTertiaryColor
        rejectRequestBtn.isBorderSelected = true
        brandsLbl.text = "Brand: "
        tyreSizeLbl.text = "Tyre Size: "
        statusLbl.text = "Status"
        
    }
    
    func bindData(_ model: GarageRequestModel) {
        let date = (model.createdAt)?.toDate(dateFormat: Date.DateFormat.givenDateFormat.rawValue) ?? Date()
        serviceTimeLbl.text = date.timeAgoSince
        if model.requestType == .tyres {
            tyreSizeLbl.text = "Tyre Size: "
            sizeDetailLbl.text = "\(model.width ?? 0)w/" + "\(model.rimSize ?? 0)r/" + "\(model.profile ?? 0)p"
        }else if model.requestType == .battery {
            tyreSizeLbl.text = "Battery: "
            sizeDetailLbl.text = "\(model.make ?? "") M/ " + "\(model.model ?? "") M/ " + "\(model.year ?? 0) Y"
        }else {
            tyreSizeLbl.text = "Oil:"
            sizeDetailLbl.text = "\(model.make ?? "") M/ " + "\(model.model ?? "") M/ " + "\(model.year ?? 0) Y"
        }
     
        if model.preferredBrands.count == 0 && model.preferredCountries.count == 0{
            brandsLbl.isHidden = true
            brandDetailLbl.isHidden = true
        }else if model.preferredCountries.count == 0{
            brandsLbl.text = "Brand: "
            brandDetailLbl.attributedText = getAttributedString(data: model.preferredBrands)
        }else {
            brandsLbl.text = "Countries: "
            brandDetailLbl.attributedText = getAttributedString(data :model.preferredCountries)
        }
        
        logoImgView.setImage_kf(imageString: model.images.first ?? "", placeHolderImage: #imageLiteral(resourceName: "maskGroup"), loader: false)
        
        statusValueLbl.text = model.bidStatus?.rawValue
        statusValueLbl.textColor = model.bidStatus?.textColor
    
        let str = model.requestType == .tyres ? "Tyre" : model.requestType.rawValue
        serviceTyeLbl.text = (str) + LocalizedString.serviceRequest.localized
        
        
        if model.bidStatus == .bidFinalsed || model.bidStatus == .bidPlaced {
            bidAmountStackView.isHidden = false
            bidAmountValueLbl.text = String((model.bidData?.first?.amount ?? 0) * (model.bidData?.first?.quantity ?? 0))
        }else {
            bidAmountStackView.isHidden = true
        }
        
        if model.bidStatus == .bidPlaced {
            rejectRequestBtn.isHidden = true
            placeBidBtn.setTitle("Cancel Bid", for: .normal)
            placeBidBtn.setTitleColor(AppColors.appRedColor, for: .normal)
            placeBidBtn.backgroundColor = .clear
            placeBidBtn.borderColor = AppColors.fontTertiaryColor
            placeBidBtn.borderWidth = 1.0

        }else {
            rejectRequestBtn.isHidden = false
            placeBidBtn.isEnabled = true
            placeBidBtn.setTitle("Place a Bid", for: .normal)
        }
    }
    
    func getAttributedString(data : [PreferredBrand]) -> NSMutableAttributedString{
        
        var str: NSMutableAttributedString = NSMutableAttributedString()
      
        if data.count <= 2 {
            str = NSMutableAttributedString(string: data.map{($0.name)}.joined(separator: ","), attributes: [
                .font: AppFonts.NunitoSansBold.withSize(12.0),
                .foregroundColor: AppColors.fontPrimaryColor
            ])
        }else {
            let count = "+\(data.count - 2) More"
            str = NSMutableAttributedString(string: "\(data[0].name), \(data[1].name) ", attributes: [
                .font: AppFonts.NunitoSansBold.withSize(12.0),
                .foregroundColor: AppColors.fontPrimaryColor
            ])
            
            str.append(NSAttributedString(string: count, attributes: [NSAttributedString.Key.foregroundColor: AppColors.linkTextColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(12.0),NSAttributedString.Key.underlineColor :AppColors.linkTextColor,NSAttributedString.Key.underlineStyle: 1]))
        }
        return str
    }
}
