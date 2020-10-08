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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        offerView.backgroundColor = AppColors.fontTertiaryColor
        logoImgView.backgroundColor = AppColors.fontTertiaryColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        offerView.round(radius: 2.0)
        logoImgView.round(radius: 4.0)
        requestNoLbl.text = "Request No: "
        dataContainerView.addShadow(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
    }
    
    public func populateData(model: UserServiceRequestModel){
        self.serviceTypeLbl.text = model.requestType
        let logoImg =  model.requestType == "Tyres" ? #imageLiteral(resourceName: "maskGroup") : model.requestType == "Battery" ? #imageLiteral(resourceName: "icBattery") : #imageLiteral(resourceName: "icOil")
        self.logoImgView.image = logoImg
        self.requestNoValueLbl.text  = "#" + "\(model.requestID)"
        let date = (model.createdAt).breakCompletDate(outPutFormat: Date.DateFormat.profileFormat.rawValue, inputFormat: Date.DateFormat.yyyyMMddTHHmmsssssz.rawValue)
        self.timeLbl.text = date
    }
    
}
