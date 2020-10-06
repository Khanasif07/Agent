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
    @IBOutlet weak var regNumberLbl: UILabel!
    @IBOutlet weak var vehicleLbl: UILabel!
    @IBOutlet weak var requestedLbl: UILabel!
    @IBOutlet weak var serviceTimeLbl: UILabel!
    @IBOutlet weak var serviceTyeLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var ratingImgView: UIImageView!
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var chatBtn: AppButton!
    @IBOutlet weak var startServiceBtn: AppButton!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var dataContainerView: UIView!
    
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
    }
    
    @IBAction func chatBtnAction(_ sender: AppButton) {}
    
    public func initialSetUp(){
        self.logoImgView.backgroundColor = AppColors.fontTertiaryColor
        chatBtn.isEnabled = true
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

}

