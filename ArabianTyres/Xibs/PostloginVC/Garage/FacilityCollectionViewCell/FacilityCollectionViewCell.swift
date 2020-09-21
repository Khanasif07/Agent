//
//  SkilledCollectionViewCell.swift
//  Sigma For India
//
//  Created by Arvind on 30/07/20.
//  Copyright © 2020 Sigma. All rights reserved.
//

import UIKit

class FacilityCollectionViewCell : UICollectionViewCell {
    
   
    @IBOutlet weak var skillLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var containerView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        // Initialization code
    }
    
    
//
//    //to set dynamic size of cell according to label text
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        super.preferredLayoutAttributesFitting(layoutAttributes)
//        layoutIfNeeded()
//        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
//        var frame = layoutAttributes.frame
//        frame.size.width = ceil(size.width)
//        frame.size.height = 30
//        layoutAttributes.frame = frame
//        return layoutAttributes
//    }
}
