//
//  ReviewTableViewCell.swift
//  Tara
//
//  Created by Arvind on 04/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    //MARK:-IBOutlets
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var serviceTypeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var reviewLbl: UILabel!
    @IBOutlet weak var garageFirstImgView: UIImageView!
    @IBOutlet weak var garageSecondImgView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var ratingImg: UIImageView!
    @IBOutlet weak var imgStackView: UIStackView!


    //MARK:-Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
}
