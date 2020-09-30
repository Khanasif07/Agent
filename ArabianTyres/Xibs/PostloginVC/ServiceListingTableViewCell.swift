//
//  ServiceListingTableViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 30/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ServiceListingTableViewCell: UITableViewCell {

    @IBOutlet weak var tyreServiceReqLbl: UILabel!
    @IBOutlet weak var regNoLbl: UILabel!
    @IBOutlet weak var serviceStatusLbl: UILabel!
    @IBOutlet weak var serviceStatusValueLbl: UILabel!
    @IBOutlet weak var regNumberValueLbl: UILabel!
    @IBOutlet weak var updateBtn: AppButton!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func updateBtnTapped(_ sender: UIButton) {
        
    }
}
