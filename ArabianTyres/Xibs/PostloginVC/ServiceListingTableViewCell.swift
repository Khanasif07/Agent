//
//  ServiceListingTableViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 30/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ServiceListingTableViewCell: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tyreServiceReqLbl: UILabel!
    @IBOutlet weak var regNoLbl: UILabel!
    @IBOutlet weak var serviceStatusLbl: UILabel!
    @IBOutlet weak var serviceStatusValueLbl: UILabel!
    @IBOutlet weak var regNumberValueLbl: UILabel!
    @IBOutlet weak var updateBtn: AppButton!
    @IBOutlet weak var containerView: UIView!

    //MARK:- Variables
    var updateBtnTapped: (()->())?
    
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFont()
        setupText()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }

    //MARK:-IBActions
    @IBAction func updateBtnTapped(_ sender: UIButton) {
        updateBtnTapped?()
    }
    
    private func setupFont() {
        tyreServiceReqLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        regNoLbl.font = AppFonts.NunitoSansBold.withSize(13.0)
        serviceStatusLbl.font = AppFonts.NunitoSansBold.withSize(13.0)
        serviceStatusValueLbl.font = AppFonts.NunitoSansBold.withSize(13.0)
        regNumberValueLbl.font = AppFonts.NunitoSansBold.withSize(13.0)
        updateBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(14.0)
    }
    
    private func setupText() {
        tyreServiceReqLbl.text = LocalizedString.tyreServiceRequest.localized
        regNoLbl.text = LocalizedString.regNo.localized
        serviceStatusLbl.text = LocalizedString.serviceStatus.localized
        updateBtn.setTitle(LocalizedString.update.localized, for: .normal)

    }
}
