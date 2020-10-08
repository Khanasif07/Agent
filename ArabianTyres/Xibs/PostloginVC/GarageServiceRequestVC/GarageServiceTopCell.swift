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
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var createAtLbl: UILabel!
    @IBOutlet weak var tyreSizeValueLbl: UILabel!
    @IBOutlet weak var tyreSizeLbl: UILabel!

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

    func popluateData(_ model: GarageRequestModel) {
        let date = (model.createdAt)?.breakCompletDate(outPutFormat: Date.DateFormat.profileFormat.rawValue, inputFormat: Date.DateFormat.yyyyMMddTHHmmsssssz.rawValue) 
        createAtLbl.text = date
        userNameLbl.text = model.userName
        switch model.requestType {
        case .tyres:
            tyreSizeValueLbl.text = "Width \(model.width ?? 0), " + "Rim \(model.rimSize ?? 0), " + "Profile \(model.profile ?? 0)"
            tyreSizeLbl.text = "Tyre Size:"
        
        case .oil:
            tyreSizeValueLbl.text = "Vechicle \(model.make ?? ""), " + "Vechicle \(model.model ?? ""), " + "Vechicle \(model.year ?? 0)"
            tyreSizeLbl.text = "Oil:"
            
        case .battery:
            tyreSizeValueLbl.text = "Vechicle \(model.make ?? ""), " + "Vechicle \(model.model ?? ""), " + "Vechicle \(model.year ?? 0)"
            tyreSizeLbl.text = "Battery:"
        }
    }
}
