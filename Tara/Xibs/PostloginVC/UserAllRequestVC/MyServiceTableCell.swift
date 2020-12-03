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


    var needHelpBtnTapped: (()->())?
    var downloadInvoiceBtnTapped: (()->())?

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
        statusLbl.text = LocalizedString.status.localized
        dataContainerView.addShadow(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
    }
    
    @IBAction func needHelpBtnAction(_sender: UIButton) {
        needHelpBtnTapped?()
    }
    
    @IBAction func downloadInVoiceBtnAction(_sender: UIButton) {
        downloadInvoiceBtnTapped?()
    }
    
    public func populateData(model: UserServiceRequestModel){
        statusValueLbl.text =  (model.isServiceStarted ?? false) ?  model.serviceStatus?.text : model.status.text
        statusValueLbl.textColor =  (model.isServiceStarted ?? false) ?  model.serviceStatus?.textColor : model.status.textColor
        statusValueLineView.backgroundColor =  (model.isServiceStarted ?? false) ?  model.serviceStatus?.textColor : model.status.textColor
        statusView.isHidden = model.status == .pending
        
        self.serviceTypeLbl.text = model.requestType + " Service Request"
        let logoImg =  model.requestType == "Tyres" ? #imageLiteral(resourceName: "maskGroup") : model.requestType == "Battery" ? #imageLiteral(resourceName: "icBattery") : #imageLiteral(resourceName: "icOil")
        let logoBackGroundColor =  model.requestType == "Tyres" ? AppColors.blueLightColor : model.requestType == "Battery" ? AppColors.redLightColor : AppColors.grayLightColor
        self.logoImgView.backgroundColor = logoBackGroundColor
        self.logoImgView.image = logoImg
        self.requestNoValueLbl.text  = "#" + "\(model.requestID)"
       
        let date = (model.createdAt).breakCompletDate(outPutFormat: Date.DateFormat.profileFormat.rawValue, inputFormat: Date.DateFormat.yyyyMMddTHHmmsssssz.rawValue)
    
        let time = getTimeFromDate(date: model.createdAt)
        self.timeLbl.text = time + " on " + date
        if model.status == .expired || model.status == .cancelled{
            bottomView.isHidden = true
        }else {
            bottomView.isHidden = false
        }
        
        if model.status == .ongoing {
            otpContainerStackView.isHidden = false
            lineView.isHidden = false
            otpValueLbl.text = model.otp?.description
        }else {
            lineView.isHidden = true
            otpContainerStackView.isHidden = true
        }
        if model.isOfferAccepted ?? false {
            offerLbl.textColor = #colorLiteral(red: 0.1725490196, green: 0.7137254902, blue: 0.4549019608, alpha: 1)
            offerView.backgroundColor =  #colorLiteral(red: 0.9098039216, green: 0.9843137255, blue: 0.9490196078, alpha: 1)
            offerLbl.text = "Offer Accepted"
            bottomView.isHidden = false
        }else {
            bottomView.isHidden = true
            if model.totalOffers == 0 || model.status == .cancelled {
                offerLbl.textColor = AppColors.fontTertiaryColor
                offerView.backgroundColor =  #colorLiteral(red: 0.9098039216, green: 0.9333333333, blue: 0.9490196078, alpha: 1)
                offerLbl.text = "No Offer"
            }else {
                offerLbl.textColor = #colorLiteral(red: 0.9882352941, green: 0.9882352941, blue: 0.9882352941, alpha: 1)
                offerView.backgroundColor = AppColors.warningYellowColor
                offerLbl.text = (model.totalOffers?.description ?? "") + " Offers"
            }
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

