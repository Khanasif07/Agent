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
    @IBOutlet weak var bottomStackView: UIStackView!
    
    @IBOutlet weak var serviceTimeLbl: UILabel!
    @IBOutlet weak var serviceTyeLbl: UILabel!
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var placeBidBtn: AppButton!
    @IBOutlet weak var rejectRequestBtn: AppButton!
    @IBOutlet weak var dataContainerView: UIView!
    
    @IBOutlet weak var bidAmountStackView: UIStackView!
    @IBOutlet weak var bidAmountLbl: UILabel!
    @IBOutlet weak var bidAmountValueLbl: UILabel!
    @IBOutlet weak var btnStackView: UIStackView!

    
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
        brandsLbl.text = LocalizedString.brands.localized + ": "
        tyreSizeLbl.text = LocalizedString.tyreSize.localized + ": "
        statusLbl.text = LocalizedString.status.localized
    }
    
    func bindData(_ model: GarageRequestModel) {
        let date = (model.createdAt)?.toDate(dateFormat: Date.DateFormat.givenDateFormat.rawValue) ?? Date()
        serviceTimeLbl.text = date.timeAgoSince
        if model.requestType == .tyres {
            tyreSizeLbl.text = LocalizedString.tyreSize.localized + ": "
            sizeDetailLbl.text = "\(model.width ?? 0)w/" + "\(model.rimSize ?? 0)r/" + "\(model.profile ?? 0)p"
        }else if model.requestType == .battery {
            tyreSizeLbl.text = LocalizedString.battery.localized + ": "
            sizeDetailLbl.text = "\(model.make ?? "") M/ " + "\(model.model ?? "") M/ " + "\(model.year ?? 0) Y"
        }else {
            tyreSizeLbl.text = LocalizedString.oil.localized + ": "
            sizeDetailLbl.text = "\(model.make ?? "") M/ " + "\(model.model ?? "") M/ " + "\(model.year ?? 0) Y"
        }
     
        if model.preferredBrands?.count == 0 && model.preferredCountries?.count == 0{
            brandsLbl.isHidden = true
            brandDetailLbl.isHidden = true
        }else if model.preferredCountries?.count == 0{
            brandsLbl.text = LocalizedString.brands.localized + ": "
            brandDetailLbl.attributedText = getAttributedString(data: model.preferredBrands ?? [])
        }else {
            brandsLbl.text = LocalizedString.countries.localized + ": "
            brandDetailLbl.attributedText = getAttributedString(data :model.preferredCountries ?? [])
        }
        let logoImg =  model.requestType == .tyres ? #imageLiteral(resourceName: "maskGroup") : model.requestType == .battery ? #imageLiteral(resourceName: "icBattery") : #imageLiteral(resourceName: "icOil")
        let logoBackGroundColor =  model.requestType == .tyres ? AppColors.blueLightColor : model.requestType == .battery ? AppColors.redLightColor : AppColors.grayLightColor
        self.logoImgView.backgroundColor = logoBackGroundColor
        self.logoImgView.image = logoImg

        statusValueLbl.text = model.bidStatus?.text
        statusValueLbl.textColor = model.bidStatus?.textColor
    
        let str = (model.requestType) == .tyres ? LocalizedString.tyre.localized + ": " : model.requestType?.rawValue
        serviceTyeLbl.text = (str ?? "") + LocalizedString.serviceRequest.localized
        
        if model.bidStatus == .bidFinalsed || model.bidStatus == .bidPlaced {
            bidAmountStackView.isHidden = false
            var str: NSMutableAttributedString = NSMutableAttributedString()
            str = NSMutableAttributedString(string: "\(Int(model.bidData?.first?.amount ?? 0.0) * (model.bidData?.first?.quantity ?? 0))", attributes: [
                .font: AppFonts.NunitoSansBold.withSize(17.0),
                .foregroundColor: AppColors.successGreenColor
            ])
            str.append(NSAttributedString(string: LocalizedString.sar.localized, attributes: [NSAttributedString.Key.foregroundColor: AppColors.successGreenColor,NSAttributedString.Key.font: AppFonts.NunitoSansSemiBold.withSize(12.0)]))
            bidAmountValueLbl.attributedText = str
        }else {
            bidAmountStackView.isHidden = true
        }
        if model.bidStatus == .bidPlaced || model.bidStatus == .bidClosed{
            rejectRequestBtn.isHidden = true
            placeBidBtn.setTitle(LocalizedString.cancelBid.localized, for: .normal)
            placeBidBtn.setTitleColor(AppColors.appRedColor, for: .normal)
            placeBidBtn.backgroundColor = .clear
            placeBidBtn.borderColor = AppColors.fontTertiaryColor
            placeBidBtn.borderWidth = 1.0

        }else {
            if model.bidStatus == .bidFinalsed  {
                placeBidBtn.isEnabled = true
                if model.isServiceStarted ?? false {
                    rejectRequestBtn.isHidden = true
                }else {
                    rejectRequestBtn.isHidden = false
                }
                placeBidBtn.isHidden = false
                rejectRequestBtn.isBorderSelected = true
                placeBidBtn.setTitle(LocalizedString.chat.localized, for: .normal)
                rejectRequestBtn.setTitle(LocalizedString.reject.localized, for: .normal)
                placeBidBtn.borderColor = .clear
                placeBidBtn.borderWidth = 0.0
            }else {
                rejectRequestBtn.isHidden = false
                placeBidBtn.isEnabled = true
                placeBidBtn.setTitle(LocalizedString.placeABid.localized, for: .normal)
                placeBidBtn.isHidden = false
                placeBidBtn.borderColor = .clear
                placeBidBtn.borderWidth = 0.0
            }
        }
        
        if model.bidStatus == .bidClosed {
            bottomStackView.isHidden = true
        }else {
            bottomStackView.isHidden = false
        }
        
        if let paymentStatus = model.paymentStatus{
            if paymentStatus == .paid{
                rejectRequestBtn.isHidden = true
            }
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
