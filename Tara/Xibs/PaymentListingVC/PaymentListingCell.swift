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
    
    @IBOutlet weak var containerView: UIView!
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
    
    func bindData(_ model: GarageRequestModel, screenType: ServiceCompletedVC.ScreenType) {
        let type = model.requestType == .tyres ? "Tyre" : model.requestType?.rawValue
        serviceTypeLbl.text = (type ?? "") + LocalizedString.service.localized
        requestIdLbl.text = "#" + "\(model.requestID ?? "")"
        typeOfPaymentLbl.text = "\(model.paymentMode ?? "")"
        amountValueLbl.text =  "\(model.amount ?? 0.0)" + " SAR"
        let date = (model.createdAt)?.breakCompletDate(outPutFormat: Date.DateFormat.ddMMyyyy.rawValue, inputFormat: Date.DateFormat.yyyyMMddTHHmmsssssz.rawValue)
        timeLbl.text = date
        
    }
    
}
