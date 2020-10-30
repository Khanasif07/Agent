//
//  FilterCollectionViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 06/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var subCategoryName: UILabel!
    @IBOutlet weak var numberOfSubCategoryName: UILabel!
    @IBOutlet weak var checkImgView: UIImageView!
    @IBOutlet weak var lineView: UIView!

    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        subCategoryName.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        numberOfSubCategoryName.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        numberOfSubCategoryName.isHidden = true
    }

    func setupForOfferFilter() {
        checkImgView.image =   #imageLiteral(resourceName: "frame3854")
        checkImgView.highlightedImage = #imageLiteral(resourceName: "group3815")
    }
}
