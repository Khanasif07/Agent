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
    }
    
    @IBAction func placeRequestBtnAction(_ sender: AppButton) {
    }
    
    public func initialSetUp(){
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
        let date = (model.createdAt).toDate(dateFormat: Date.DateFormat.givenDateFormat.rawValue) ?? Date()
        serviceTimeLbl.text = date.timeAgoSince
        sizeDetailLbl.text = "\(model.width ?? 0)w/" + "\(model.rimSize ?? 0)r/" + "\(model.profile ?? 0)p"
     
        if model.preferredBrands.count == 0 {
            brandsLbl.text = "Countries: "
            brandDetailLbl.text = model.preferredCountries.map{($0.name)}.joined(separator: ",")
        }else {
            brandsLbl.text = "Brand: "
            brandDetailLbl.text = model.preferredBrands.map{($0.name)}.joined(separator: ",")
        }
        
        logoImgView.setImage_kf(imageString: model.images.first ?? "", placeHolderImage: #imageLiteral(resourceName: "group3888"), loader: false)
        statusValueLbl.text = model.status.text
        statusValueLbl.textColor = model.status.textColor
        serviceTyeLbl.text = model.requestType
        
    }
}
