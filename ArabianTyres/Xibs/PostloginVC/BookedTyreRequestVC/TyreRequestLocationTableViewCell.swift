//
//  TyreRequestLocationTableViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 06/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

class TyreRequestLocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
}
