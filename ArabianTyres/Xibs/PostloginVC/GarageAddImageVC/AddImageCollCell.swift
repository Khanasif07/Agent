//
//  AddImageCollCell.swift
//  ArabianTyres
//
//  Created by Admin on 16/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class AddImageCollCell: UICollectionViewCell {

    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var activityIndictor: UIActivityIndicatorView!
    @IBOutlet weak var addImgBtn: UIButton!
    
    @IBOutlet weak var dataContainerView: RectangularDashedView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dataContainerView.round(radius: 4.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}
