//
//  FilterTableViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 06/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

class FilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addImgView : UIImageView!
    @IBOutlet weak var categoryLbl : UILabel!
    @IBOutlet weak var cellBtn : UIButton!
    @IBOutlet weak var bottomView : UIView!
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var collView : UICollectionView!
    @IBOutlet weak var collViewHeightConstraint : NSLayoutConstraint!

    var cellBtnTapped : (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        categoryLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
    }
    
    @IBAction func cellBtnAction(_ sender: UIButton) {
//        checkBtn.isSelected.toggle()
        cellBtnTapped?()
    }
}
