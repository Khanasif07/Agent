//
//  ServiceDetailCollectionViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 06/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ServiceDetailCollectionViewCell: UICollectionViewCell {

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
}
