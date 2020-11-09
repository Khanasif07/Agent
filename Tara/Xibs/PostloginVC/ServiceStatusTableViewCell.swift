//
//  ServiceStatusTableViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 07/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ServiceStatusTableViewCell: UITableViewCell {
    
    //MARK:-IBOutlet
    @IBOutlet weak var serviceStatusLbl: UILabel!
    
    @IBOutlet weak var carReceivedLbl: UILabel!
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var completeLbl: UILabel!
    @IBOutlet weak var takenLbl: UILabel!
    
    @IBOutlet weak var carReceivedStepBtn: UIButton!
    @IBOutlet weak var progressStepBtn: UIButton!
    @IBOutlet weak var completeStepBtn: UIButton!
    @IBOutlet weak var takenStepBtn: UIButton!
    
    @IBOutlet weak var carReceivedUpdateBtn: AppButton!
    @IBOutlet weak var progressUpdateBtn: AppButton!
    @IBOutlet weak var completeUpdateBtn: AppButton!
    @IBOutlet weak var takenUpdateBtn: AppButton!
    
    @IBOutlet weak var paymentStatusLbl: UILabel!
    @IBOutlet weak var amountPaidlbl: UILabel!
    @IBOutlet weak var paidLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var carRecievedStackView: UIStackView!

    @IBOutlet weak var carServiceLineView: UIView!
    @IBOutlet weak var completedLineView: UIView!
    @IBOutlet weak var readyToBeTakenLineView: UIView!


    //MARK:-Variables
    
    //MARK:-LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFontAndText()
        // Initialization code
    }

    private func setupFontAndText() {
        serviceStatusLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        serviceStatusLbl.text = LocalizedString.serviceStatus.localized
        
        paymentStatusLbl.font = AppFonts.NunitoSansBold.withSize(13.0)
        paymentStatusLbl.text = LocalizedString.paymentStatus.localized
        
        amountPaidlbl.font = AppFonts.NunitoSansBold.withSize(13.0)
        amountPaidlbl.text = LocalizedString.amountPaid.localized
        
        carReceivedLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        progressLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        completeLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        takenLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        
        [carReceivedUpdateBtn,progressUpdateBtn,completeUpdateBtn,takenUpdateBtn].forEach { (btn) in
            btn?.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(14.0)
            btn?.setTitle(LocalizedString.update.localized, for: .normal)
            btn?.isEnabled = false
            btn?.alpha = 0.5
        }
        
        carServiceLineView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        completedLineView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        readyToBeTakenLineView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        carRecievedStackView.isHidden = true
    }
    
    //MARK:-Functions
    
    func populateData(status: ServiceState) {
       
        if status == nil {
            carReceivedUpdateBtn.isHidden = false
            carReceivedUpdateBtn.isUserInteractionEnabled = true
            
        }
        
        if status == .carReceived {
            carReceivedStepBtn.setImage(#imageLiteral(resourceName: "icRgt"), for: .normal)
            carReceivedUpdateBtn.isHidden = true
        }
        
        if status == .inProgress {
            carReceivedStepBtn.setImage(#imageLiteral(resourceName: "icRgt"), for: .normal)
            carReceivedUpdateBtn.isHidden = true
            progressStepBtn.setImage(#imageLiteral(resourceName: "icRgt"), for: .normal)
            progressUpdateBtn.isHidden = true
            carServiceLineView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.6352941176, blue: 0.5411764706, alpha: 1)
            
        }
        
        if status == .completed {
            carReceivedStepBtn.setImage(#imageLiteral(resourceName: "icRgt"), for: .normal)
            carReceivedUpdateBtn.isHidden = true
            progressStepBtn.setImage(#imageLiteral(resourceName: "icRgt"), for: .normal)
            progressUpdateBtn.isHidden = true
            completeStepBtn.setImage(#imageLiteral(resourceName: "icRgt"), for: .normal)
            completeUpdateBtn.isHidden = true
            carServiceLineView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.6352941176, blue: 0.5411764706, alpha: 1)
            completedLineView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.6352941176, blue: 0.5411764706, alpha: 1)
        }
        
        if status == .readyToBeTaken {
            carReceivedStepBtn.setImage(#imageLiteral(resourceName: "icRgt"), for: .normal)
            carReceivedUpdateBtn.isHidden = true
            progressStepBtn.setImage(#imageLiteral(resourceName: "icRgt"), for: .normal)
            progressUpdateBtn.isHidden = true
            completeStepBtn.setImage(#imageLiteral(resourceName: "icRgt"), for: .normal)
            completeUpdateBtn.isHidden = true
            takenStepBtn.setImage(#imageLiteral(resourceName: "icRgt"), for: .normal)
            takenUpdateBtn.isHidden = true
            carServiceLineView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.6352941176, blue: 0.5411764706, alpha: 1)
            completedLineView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.6352941176, blue: 0.5411764706, alpha: 1)
            readyToBeTakenLineView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.6352941176, blue: 0.5411764706, alpha: 1)
            
            carRecievedStackView.isHidden = false
        }
    }
    
    
    //MARK:- IBActions
   
    @IBAction func carReceivedBtnAction(_ sender : UIButton) {
        
    }
   
    @IBAction func progressBtnAction(_ sender : UIButton) {
        
    }
    
    @IBAction func completeBtnAction(_ sender : UIButton) {
        
    }
    
    @IBAction func takenBtnAction(_ sender : UIButton) {
        
    }
    
    
    @IBAction func yesBtnAction(_ sender : UIButton) {
        
    }
    
    
    @IBAction func noBtnAction(_ sender : UIButton) {
        
    }
}
