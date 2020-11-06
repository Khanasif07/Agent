//
//  ReceiverLocationCell.swift
//  Tara
//
//  Created by Arvind on 06/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ReceiverLocationCell: UITableViewCell {
    
    //MARK:-IBOutlets
    
    @IBOutlet weak var mapImgView: UIImageView!
    @IBOutlet weak var garageImgView: UIImageView!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var receiverNameLabel: UILabel!
    @IBOutlet weak var msgContainerView: UIView!

    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}
