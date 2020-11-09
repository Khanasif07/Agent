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

        if !(model.preferredBrands?.isEmpty ?? true) {
            preferBrandLbl.text = "Preferred Brand:"
            preferBrandValueLbl.text = model.preferredBrands?.map{($0).name}.joined(separator: ", ")
        }
        
        if !(model.preferredCountries?.isEmpty ?? true) {
            preferBrandLbl.text = "Countries:"
            preferBrandValueLbl.text = model.preferredCountries?.map{($0).name}.joined(separator: ", ")
        }
    }
}
