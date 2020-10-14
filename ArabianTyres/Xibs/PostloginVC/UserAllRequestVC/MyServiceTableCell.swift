//
//  MyServiceTableCell.swift
//  ArabianTyres
//
//  Created by Admin on 06/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class MyServiceTableCell: UITableViewCell {
    
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var serviceTypeLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var offerLbl: UILabel!
    @IBOutlet weak var requestNoLbl: UILabel!
    @IBOutlet weak var offerView: UIView!
    @IBOutlet weak var requestNoValueLbl: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var bottomView: UIView!
   
    @IBOutlet weak var statusValueLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusValueLineView: UIView!

    @IBOutlet weak var otpContainerStackView: UIStackView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var otpLbl: UILabel!
    @IBOutlet weak var otpValueLbl: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        offerView.backgroundColor = AppColors.fontTertiaryColor
        logoImgView.backgroundColor = AppColors.fontTertiaryColor
        timeLbl.textColor = AppColors.fontTertiaryColor
        requestNoValueLbl.textColor = AppColors.linkTextColor
        lineView.isHidden = true
        otpContainerStackView.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        offerView.round(radius: 2.0)
        logoImgView.round(radius: 4.0)
        statusView.round(radius: 4.0)
        requestNoLbl.text = "Request No: "
        dataContainerView.addShadow(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
    }
    
    public func populateData(model: UserServiceRequestModel){
        statusValueLbl.text = model.status
        self.serviceTypeLbl.text = model.requestType + " Service Request"
        let logoImg =  model.requestType == "Tyres" ? #imageLiteral(resourceName: "maskGroup") : model.requestType == "Battery" ? #imageLiteral(resourceName: "icBattery") : #imageLiteral(resourceName: "icOil")
        let logoBackGroundColor =  model.requestType == "Tyres" ? AppColors.blueLightColor : model.requestType == "Battery" ? AppColors.redLightColor : AppColors.grayLightColor
        self.logoImgView.backgroundColor = logoBackGroundColor
        self.logoImgView.image = logoImg
        self.requestNoValueLbl.text  = "#" + "\(model.requestID)"
       
        let date = (model.createdAt).breakCompletDate(outPutFormat: Date.DateFormat.profileFormat.rawValue, inputFormat: Date.DateFormat.yyyyMMddTHHmmsssssz.rawValue)
    
        let time = getTimeFromDate(date: model.createdAt)
        self.timeLbl.text = time + " on " + date
        if model.requestType == "Tyres" {
              bottomView.isHidden = true
        }else {
              bottomView.isHidden = false
        }
        if model.requestType == "Battery" {
            statusView.isHidden = true
            bottomView.isHidden = true
        } else {
            statusView.isHidden = false
            bottomView.isHidden = false
        }
    }
    
    func getTimeFromDate(date: String) -> String {
        let formatter = DateFormatter()
        let d = date.toDate(dateFormat: Date.DateFormat.givenDateFormat.rawValue) ?? Date()
        formatter.dateFormat = Date.DateFormat.hour12.rawValue
        let dateStr = formatter.string(from: d)
        return dateStr
    }
}
