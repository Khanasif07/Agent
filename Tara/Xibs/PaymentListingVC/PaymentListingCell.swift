//
//  PaymentListingCell.swift
//  Tara
//
//  Created by Arvind on 21/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class PaymentListingCell: UITableViewCell {

    //MARK:- IBOutlets
    
    @IBOutlet weak var serviceTypeLbl: UILabel!
    @IBOutlet weak var requestIdLbl: UILabel!
    @IBOutlet weak var amountPaidLbl: UILabel!
    @IBOutlet weak var amountValueLbl: UILabel!
    @IBOutlet weak var modeOfPaymentLbl: UILabel!
    @IBOutlet weak var typeOfPaymentLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!

    //MARk:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
