//
//  PaymentCardCell.swift
//  Tara
//
//  Created by Arvind on 19/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class PaymentCardCell: UITableViewCell {

    
    //    MARK: OUTLETS
    //    =============
    @IBOutlet weak var receiverNameLbl: UILabel!
    @IBOutlet weak var receiverImgView: UIImageView!
    @IBOutlet weak var msgContainerView: UIView!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var paymentRequestLabel: UILabel!
    @IBOutlet weak var payNowBtn: UIButton!
    @IBOutlet weak var declineBtn: UIButton!
    
    //    MARK: Life Cycle
    //    ===============
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func declineBtnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func payNowBtnTapped(_ sender: UIButton) {
        
    }
}
