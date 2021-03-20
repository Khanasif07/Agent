//
//  ReceiverPaymentCardCell.swift
//  Tara
//
//  Created by Admin on 02/12/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ReceiverPaymentCardCell: UITableViewCell {
    
    //    MARK: OUTLETS
    //    =============
    @IBOutlet weak var paymentRequestLbl: UILabel!
    @IBOutlet weak var buttonsView: UIStackView!
    @IBOutlet weak var payNowBtn: AppButton!
    @IBOutlet weak var declineBtn: AppButton!
    @IBOutlet weak var receiverNameLbl: UILabel!
    @IBOutlet weak var receiverImgView: UIImageView!
    @IBOutlet weak var msgContainerView: UIView!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var paymentRequestLabel: UILabel!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var sarLabel: UILabel!

    //    MARK: Life Cycle
    //    ===============
    override func awakeFromNib() {
        super.awakeFromNib()
        payNowBtn.setTitle(LocalizedString.payNow.localized, for: .normal)
        declineBtn.setTitle(LocalizedString.decline.localized, for: .normal)
        paymentRequestLbl.text = LocalizedString.paymentRequest.localized
        msgLabel.text = LocalizedString.make_Payment_to_get_hassle_free_service.localized
        sarLabel.text = LocalizedString.sar.localized
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        msgContainerView.roundCorners([.topLeft, .topRight, .bottomRight], radius: 4)
        bottomContainerView.addShadow(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        receiverImgView.round()
    }
    
    
}
