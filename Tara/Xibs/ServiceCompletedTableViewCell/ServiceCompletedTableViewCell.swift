//
//  ServiceCompletedTableViewCell.swift
//  Tara
//
//  Created by Arvind on 06/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ServiceCompletedTableViewCell: UITableViewCell {

    //MARK:-IBOutlet
    @IBOutlet weak var serviceTypeLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var amountPaidLbl: UILabel!
    @IBOutlet weak var amountValueLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var containerView: UIView!

    //MARK:-Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
    
    func bindData(_ model: GarageRequestModel, screenType: ServiceCompletedVC.ScreenType) {
        let type = model.requestType == .tyres ? "Tyre" : model.requestType?.rawValue
        serviceTypeLbl.text = (type ?? "") + LocalizedString.service.localized
        if screenType == .serviceComplete {
            userImgView.setImage_kf(imageString: model.userImage ?? "", placeHolderImage: #imageLiteral(resourceName: "placeHolder"), loader: false)
            userImgView.contentMode = .scaleToFill
            userNameLbl.text = model.userName
            amountValueLbl.text = "\(model.amountPaid ?? 0.0)" + " SAR"
            userImgView.round()
            ratingLbl.text = (model.isRated ?? false) ? (model.rating?.description ?? "") : "No Rating"
          
        }else {
            userImgView.contentMode = .scaleToFill
            userImgView.setImage_kf(imageString: model.garageLogo ?? "", placeHolderImage: #imageLiteral(resourceName: "placeHolder"), loader: false)
            userNameLbl.text = model.garageName
            amountValueLbl.text = "\(model.amountPaid ?? 0.0)" + " SAR"
            if let rating = model.rating {
                ratingLbl.text = (rating.description) //+ "/5"

            }else {
                ratingLbl.text = "No Rating"
            }
        }
        let date = (model.serviceCompletedOn)?.breakCompletDate(outPutFormat: Date.DateFormat.ddMMyyyy.rawValue, inputFormat: Date.DateFormat.yyyyMMddTHHmmsssssz.rawValue)
        timeLbl.text = date
       
    }
}
