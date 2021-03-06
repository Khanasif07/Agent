//
//  ServiceDetailTableViewCell.swift
//  Tara
//
//  Created by Arvind on 07/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ServiceDetailTableViewCell: UITableViewCell {

    //MARK:-IBOutlets
    @IBOutlet weak var serviceDetailLbl: UILabel!
    @IBOutlet weak var tyreSizeLbl: UILabel!
    @IBOutlet weak var tyreSizeValueLbl: UILabel!
    @IBOutlet weak var preferBrandLbl: UILabel!
    @IBOutlet weak var preferBrandValueLbl: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFontAndText()
        // Initialization code
    }

  
    private func setupFontAndText() {
        serviceDetailLbl.text = LocalizedString.serviceDetails.localized
        tyreSizeLbl.text = LocalizedString.tyreSize.localized
        preferBrandLbl.text = LocalizedString.preferredBrand.localized
        tyreSizeLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        preferBrandLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        tyreSizeValueLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        preferBrandValueLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        serviceDetailLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)

    }
    
    func bindDataForBookedRequestDetail(_ model: GarageRequestModel) {
        let type = model.requestType ?? .battery
        switch type {
        case .tyres:
            tyreSizeValueLbl.text = "\(LocalizedString.width.localized) \(model.width ?? 0), " + "\(LocalizedString.rim.localized) \(model.rimSize ?? 0), " + "\(LocalizedString.profile.localized) \(model.profile ?? 0)"
            tyreSizeLbl.text = LocalizedString.tyreSize.localized + ":"
            
        case .oil:
            tyreSizeValueLbl.text = "\(LocalizedString.vehicleMake.localized) \(model.make ?? ""), " + "\(LocalizedString.vehicleModel.localized) \(model.model ?? ""), " + "\(LocalizedString.productYear.localized) \(model.year ?? 0)"
            tyreSizeLbl.text = LocalizedString.oil.localized + ":"
            
        case .battery:
            tyreSizeValueLbl.text = "\(LocalizedString.vehicleMake.localized) \(model.make ?? ""), " + "\(LocalizedString.vehicleModel.localized) \(model.model ?? ""), " + "\(LocalizedString.vehicleYear.localized) \(model.year ?? 0)"
            tyreSizeLbl.text = LocalizedString.battery.localized + ":"
      
        }

        if !(model.preferredBrands?.isEmpty ?? true) {
            preferBrandLbl.text = LocalizedString.preferredBrand.localized + ":"
            preferBrandValueLbl.text = model.preferredBrands?.map{($0).name}.joined(separator: ", ")
        }
        
        if !(model.preferredCountries?.isEmpty ?? true) {
            preferBrandLbl.text = LocalizedString.countries.localized + ":"
            preferBrandValueLbl.text = model.preferredCountries?.map{($0).name}.joined(separator: ", ")
        }
    }
}
