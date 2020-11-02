//
//  UserNotificationTableViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 27/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class UserNotificationTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var subHeadingLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var crossbtn: UIButton!

    //MARK:- Variables
    
    //MARK:-Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        
    }
    
    @IBAction func crossbtnAction(_ sender: UIButton) {
        
    }
}
