//
//  TyreRequestLocationTableViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 06/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class TyreRequestLocationTableViewCell: UITableViewCell {

    //MARK:- IBOutlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var chatBtn: AppButton!
    @IBOutlet weak var startServiceBtn: AppButton!
  
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFontAndText()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
    
    private func setupFontAndText() {
        locationLbl.text = LocalizedString.location.localized
        chatBtn.setTitle(LocalizedString.chat.localized, for: .normal)
        startServiceBtn.setTitle(LocalizedString.startService.localized, for: .normal)

        locationLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        addressLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        chatBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(16.0)
        startServiceBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(16.0)
    }
    
    //MARK:-IBActions
    
    @IBAction func chatBtnTapped(_ sender: UIButton) {
        
    }
    @IBAction func startServiceBtnTapped(_ sender: UIButton) {
        
    }
}
