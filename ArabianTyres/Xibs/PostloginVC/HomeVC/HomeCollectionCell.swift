//
//  HomeCollectionCell.swift
//  ArabianTyres
//
//  Created by Admin on 09/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class HomeCollectionCell: UICollectionViewCell {
    //MARK:- OUTLETS
    //==============
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabelBackGroundView: UIView!
    @IBOutlet weak var cellLabel: UILabel!

    
    //MARK:- AWAKE FROM NIV FUNCTION
    //==============================
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cellLabelBackGroundView.round(radius: 12.0)
    }
}

//MARK:- EXTENSION FOR PRIVATE FUNCTION
//=====================================
extension HomeCollectionCell{
    private func initialSetUp(){
    }
}
