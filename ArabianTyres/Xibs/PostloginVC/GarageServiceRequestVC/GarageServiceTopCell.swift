//
//  GarageServiceTopCell.swift
//  ArabianTyres
//
//  Created by Admin on 06/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class GarageServiceTopCell: UITableViewCell {

    @IBOutlet weak var requestedImgView: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var serviceDetailLbl: UILabel!
    @IBOutlet weak var requestedOnLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var requestCreatedLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textSetUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImgView.round()
        requestedImgView.round(radius: 4.0)
    }
    
    private func textSetUp(){
        addressLbl.textColor = AppColors.fontTertiaryColor
        serviceDetailLbl.textColor = AppColors.fontTertiaryColor
        requestedOnLbl.textColor = AppColors.fontTertiaryColor
        requestCreatedLbl.textColor = AppColors.fontTertiaryColor
    }

}
