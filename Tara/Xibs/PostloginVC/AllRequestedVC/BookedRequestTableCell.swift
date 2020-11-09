//
//  ServiceRequestTableCell.swift
//  ArabianTyres
//
//  Created by Admin on 05/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class BookedRequestTableCell: UITableViewCell {

    @IBOutlet weak var payableAmtLbl: UILabel!
    @IBOutlet weak var payableAmtValueLbl: UILabel!
    @IBOutlet weak var regNumberLbl: UILabel!
    @IBOutlet weak var regNumberValueLbl: UILabel!
    @IBOutlet weak var vehicleLbl: UILabel!
    @IBOutlet weak var vehicleNameLbl: UILabel!
    @IBOutlet weak var requestedLbl: UILabel!
    @IBOutlet weak var serviceTimeLbl: UILabel!
    @IBOutlet weak var serviceTyeLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var ratingImgView: UIImageView!
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var chatBtn: AppButton!
    @IBOutlet weak var startServiceBtn: AppButton!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var dataContainerView: UIView!
    
    var chatBtnTapped: (()->())?
    var startServiceBtnTapped: (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logoImgView.round(radius: 4.0)
        chatBtn.round(radius: 2.0)
        startServiceBtn.round(radius: 2.0)
        ratingImgView.round(radius: 4.0)
        ratingView.round(radius: 2.0)
        dataContainerView.addShadow(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
    }
    
    
    @IBAction func startServiceAction(_ sender: AppButton) {
        startServiceBtnTapped?()
    }
    
    @IBAction func chatBtnAction(_ sender: AppButton) {
        chatBtnTapped?()
    }
    
    public func initialSetUp(){
        ratingView.isHidden = true
        self.logoImgView.backgroundColor = AppColors.fontTertiaryColor
        chatBtn.isBorderSelected = true
        startServiceBtn.isEnabled = true
        vehicleLbl.textColor = AppColors.fontTertiaryColor
        requestedLbl.textColor = AppColors.fontTertiaryColor
        regNumberLbl.textColor = AppColors.fontTertiaryColor
        payableAmtLbl.textColor = AppColors.fontTertiaryColor
        requestedLbl.text = "Requested By: "
        vehicleLbl.text = "Vehicle"
        regNumberLbl.text = "Reg. Number"
        payableAmtLbl.text = "Payable Amount"
    }

    func bindData(_ model: GarageRequestModel) {
//        let date = (model.createdAt)?.toDate(dateFormat: Date.DateFormat.givenDateFormat.rawValue) ?? Date()
//        serviceTimeLbl.text = date.timeAgoSince

        let date = (model.createdAt)?.breakCompletDate(outPutFormat: Date.DateFormat.profileFormat.rawValue, inputFormat: Date.DateFormat.yyyyMMddTHHmmsssssz.rawValue)
        serviceTimeLbl.text = date
        
        regNumberValueLbl.text = model.requestID
        vehicleNameLbl.text = model.make?.isEmpty ?? true ? "N/A" : model.make
        userNameLbl.text = model.requestedBy
        
        let type = model.requestType == .tyres ? "Tyre" : model.requestType.rawValue
        serviceTyeLbl.text = (type) + LocalizedString.serviceRequest.localized
        
        let logoImg =  model.requestType == .tyres ? #imageLiteral(resourceName: "maskGroup") : model.requestType == .battery ? #imageLiteral(resourceName: "icBattery") : #imageLiteral(resourceName: "icOil")
        let logoBackGroundColor =  model.requestType == .tyres ? AppColors.blueLightColor : model.requestType == .battery ? AppColors.redLightColor : AppColors.grayLightColor
        self.logoImgView.backgroundColor = logoBackGroundColor
        self.logoImgView.image = logoImg
        
        var str: NSMutableAttributedString = NSMutableAttributedString()
        str = NSMutableAttributedString(string: model.payableAmount?.description ?? "", attributes: [
            .font: AppFonts.NunitoSansBold.withSize(17.0),
            .foregroundColor: AppColors.successGreenColor
        ])
        
        str.append(NSAttributedString(string: "SAR", attributes: [NSAttributedString.Key.foregroundColor: AppColors.successGreenColor,NSAttributedString.Key.font: AppFonts.NunitoSansSemiBold.withSize(12.0)]))
        payableAmtValueLbl.attributedText = str
       
        if let btnText = model.serviceStatus?.serviceBtnTitle {
            startServiceBtn.setTitle(btnText, for: .normal)
        }else {
            startServiceBtn.setTitle(LocalizedString.startService.localized, for: .normal)
        }
    }
}

