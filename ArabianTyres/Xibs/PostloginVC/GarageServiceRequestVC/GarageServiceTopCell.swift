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
    
    
    var locationValue : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var locationUpdated : (()->())?
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
    
    private func setAddress() {
        GMSGeocoder().reverseGeocodeCoordinate(locationValue) { (response, error) in
            
            guard let address = response?.firstResult(), let lines = address.lines else { return }
            _ = (address.locality?.isEmpty ?? true) ? ((address.subLocality?.isEmpty ?? true) ? ((address.administrativeArea?.isEmpty ?? true) ? address.country : address.administrativeArea)  : address.subLocality)   : address.locality
            self.locationLbl.text = lines.joined(separator: ",")
            self.locationUpdated?()
        }
        
    }
    
    func popluateData(_ model: GarageRequestModel) {
        if let address = model.userAddress {
            locationLbl.text = address.isEmpty ? "NA" : address
        }else {
            locationLbl.text = "NA"
        }
        userImgView.setImage_kf(imageString: model.userImage ?? "",placeHolderImage: #imageLiteral(resourceName: "placeHolder"))
        let date = (model.createdAt)?.breakCompletDate(outPutFormat: Date.DateFormat.profileFormat.rawValue, inputFormat: Date.DateFormat.yyyyMMddTHHmmsssssz.rawValue)
        createAtLbl.text = date
        userNameLbl.text = model.userName
//        let cords = CLLocationCoordinate2D(latitude: model.userLatitude ?? 0.0, longitude: model.userLongitude ?? 0.0)
//        self.locationValue = cords
//        setAddress()
        switch model.requestType {
        case .tyres:
            tyreSizeValueLbl.text = "Width \(model.width ?? 0), " + "Rim \(model.rimSize ?? 0), " + "Profile \(model.profile ?? 0)"
            tyreSizeLbl.text = "Tyre Size:"
            
        case .oil:
            tyreSizeValueLbl.text = "Vechicle Make \(model.make ?? ""), " + "Vechicle Model \(model.model ?? ""), " + "Product Year \(model.year ?? 0)"
            tyreSizeLbl.text = "Oil:"
            
        case .battery:
            tyreSizeValueLbl.text = "Vechicle Make \(model.make ?? ""), " + "Vechicle Model \(model.model ?? ""), " + "Vechicle Year \(model.year ?? 0)"
            tyreSizeLbl.text = "Battery:"
        }
    }
}
