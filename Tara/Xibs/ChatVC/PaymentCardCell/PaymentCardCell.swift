//
//  PaymentCardCell.swift
//  Tara
//
//  Created by Arvind on 19/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class PaymentCardCell: UITableViewCell {

    
    var payNowBtnAction :((UIButton)->())?
    var declineBtnAction : ((UIButton)->())?
    
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
    @IBOutlet weak var bottomContainerView: UIView!
    
    //    MARK: Life Cycle
    //    ===============
    override func awakeFromNib() {
        super.awakeFromNib()
        msgLabel.text = LocalizedString.make_Payment_to_get_hassle_free_service.localized
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        msgContainerView.roundCorners([.topLeft, .topRight, .bottomRight], radius: 4)
        bottomContainerView.addShadow(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        receiverImgView.round()
    }
    
    
    @IBAction func declineBtnTapped(_ sender: UIButton) {
        if let handle = declineBtnAction{
            handle(sender)
        }
    }
    
    @IBAction func payNowBtnTapped(_ sender: UIButton) {
        if let handle = payNowBtnAction{
            handle(sender)
        }
    }
}
