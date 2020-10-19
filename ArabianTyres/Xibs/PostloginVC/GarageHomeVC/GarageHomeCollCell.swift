//
//  GarageHomeCollCell.swift
//  ArabianTyres
//
//  Created by Admin on 19/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class GarageHomeCollCell: UICollectionViewCell {
    
    @IBOutlet weak var requestTypeLbl: UILabel!
    @IBOutlet weak var requestCountLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dataContainerView.round(radius: 12.0)
    }
    
    public func populateData(model: GarageDataValue){
        self.requestTypeLbl.textColor = .red
        self.requestTypeLbl.text = model.name
        self.requestCountLbl.text = "\(model.requestCount)"
        self.dataContainerView.backgroundColor = model.backgroundColor
    }
}
