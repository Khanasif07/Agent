//
//  GarageServiceTopCell.swift
//  ArabianTyres
//
//  Created by Admin on 06/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class GarageServiceTopCell: UITableViewCell {
    
    @IBOutlet weak var productImgLbl: UILabel!
    @IBOutlet weak var bidStatusLbl: UILabel!
    @IBOutlet weak var requestedImgView: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var serviceDetailLbl: UILabel!
    @IBOutlet weak var requestedOnLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var requestCreatedLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var createAtLbl: UILabel!
    @IBOutlet weak var tyreSizeValueLbl: UILabel!
    @IBOutlet weak var tyreSizeLbl: UILabel!
    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var imgStackView: UIStackView!
    
    
    var locationValue : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var locationUpdated : (()->())?
    var productImgTapped : (()->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textSetUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImgView.round()
        productImgView.round(radius: 4.0)
        requestedImgView.round(radius: 4.0)
    }
    
    private func textSetUp(){
        addressLbl.textColor = AppColors.fontTertiaryColor
        serviceDetailLbl.textColor = AppColors.fontTertiaryColor
        requestedOnLbl.textColor = AppColors.fontTertiaryColor
        requestCreatedLbl.textColor = AppColors.fontTertiaryColor
        requestCreatedLbl.text = LocalizedString.requestCreatedBy.localized
        requestedOnLbl.text = LocalizedString.requestedOn.localized
        serviceDetailLbl.text = LocalizedString.serviceDetails.localized
        productImgLbl.text = LocalizedString.productImage.localized
        addressLbl.text = LocalizedString.address.localized
        productImgView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTap))
        self.productImgView.addGestureRecognizer(tapGesture)
    }
    
    private func setAddress() {
        GMSGeocoder().reverseGeocodeCoordinate(locationValue) { (response, error) in
            
            guard let address = response?.firstResult(), let lines = address.lines else { return }
            _ = (address.locality?.isEmpty ?? true) ? ((address.subLocality?.isEmpty ?? true) ? ((address.administrativeArea?.isEmpty ?? true) ? address.country : address.administrativeArea)  : address.subLocality)   : address.locality
            self.locationLbl.text = lines.joined(separator: ",")
            self.locationUpdated?()
        }
        
    }
    
    @objc func singleTap(){
        if let handle = productImgTapped{
            handle()
        }
    }
    
    func popluateData(_ model: GarageRequestModel) {
        if let address = model.userAddress {
            locationLbl.text = address.isEmpty ? "NA" : address
        }else {
            locationLbl.text = "NA"
        }
        self.imgStackView.isHidden  = ((model.images?.isEmpty) ?? false)
        productImgView.setImage_kf(imageString: model.images?.first ?? "",placeHolderImage: #imageLiteral(resourceName: "placeHolder"))
        userImgView.setImage_kf(imageString: model.userImage ?? "",placeHolderImage: #imageLiteral(resourceName: "placeHolder"))
        let date = (model.createdAt)?.breakCompletDate(outPutFormat: Date.DateFormat.profileFormat.rawValue, inputFormat: Date.DateFormat.yyyyMMddTHHmmsssssz.rawValue)
        createAtLbl.text = date
        userNameLbl.text = model.userName
        let type = model.requestType ?? .battery
        switch type {
        case .tyres:
            tyreSizeValueLbl.text = "\(LocalizedString.width.localized) \(model.width ?? 0), " + "\(LocalizedString.rim.localized) \(model.rimSize ?? 0), " + "\(LocalizedString.profile.localized) \(model.profile ?? 0)"
            tyreSizeLbl.text = LocalizedString.tyreSize.localized
            
        case .oil:
            tyreSizeValueLbl.text = "\(LocalizedString.vehicleMake.localized) \(model.make ?? ""), " + "\(LocalizedString.vehicleModel.localized) \(model.model ?? ""), " + "\(LocalizedString.productYear.localized) \(model.year ?? 0)"
            tyreSizeLbl.text = LocalizedString.oil.localized + ":"
            
        case .battery:
            tyreSizeValueLbl.text = "\(LocalizedString.vehicleMake.localized) \(model.make ?? ""), " + "\(LocalizedString.vehicleModel.localized) \(model.model ?? ""), " + "\(LocalizedString.vehicleYear.localized) \(model.year ?? 0)"
            tyreSizeLbl.text = LocalizedString.battery.localized + ":"
        }
    }
}
