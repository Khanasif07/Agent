//
//  ServiceCompletedTableViewCell.swift
//  Tara
//
//  Created by Arvind on 06/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ServiceCompletedTableViewCell: UITableViewCell {

    //MARK:-IBOutlet
    @IBOutlet weak var serviceTypeLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var amountPaidLbl: UILabel!
    @IBOutlet weak var amountValueLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var containerView: UIView!

    //MARK:-Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImgView.round()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
}
