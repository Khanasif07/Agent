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
        amountPaidLbl.text = LocalizedString.amountPaid.localized + ":"
        modeOfPaymentLbl.text = LocalizedString.mode_Of_Payment.localized  + ":"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
    
    func bindData(_ model: GarageRequestModel, screenType: ServiceCompletedVC.ScreenType) {
        
        var type = ""
        switch model.requestType?.rawValue {
        
        case "Tyres":
            type = LocalizedString.tireService.localized
            
        case "Battery":
            type = LocalizedString.batteryService.localized
            
        default:
            type = LocalizedString.oilService.localized
        }
//        let type = model.requestType?.rawValue == "Tyres" ? LocalizedString.tyre.localized : ( model.requestType?.rawValue == "Battery" ? LocalizedString.battery.localized : LocalizedString.oil.localized)
        serviceTypeLbl.text = type
        requestIdLbl.text = "#" + "\(model.requestID ?? "")"
        typeOfPaymentLbl.text = "\(model.paymentMode ?? "")"
        amountValueLbl.text =  "\(model.amount ?? 0.0)" + " " + LocalizedString.sar.localized
        let date = (model.createdAt)?.breakCompletDate(outPutFormat: Date.DateFormat.ddMMyyyy.rawValue, inputFormat: Date.DateFormat.yyyyMMddTHHmmsssssz.rawValue)
        timeLbl.text = date
        
    }
    
}
