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
    
    @IBOutlet weak var refundedPaymentView: UIStackView!
    @IBOutlet weak var serviceStatusLbl: UILabel!
    @IBOutlet weak var ratingContainerView: UIView!
    @IBOutlet weak var reviewLbl: UILabel!
    @IBOutlet weak var noRatingContainerView: UIView!
    @IBOutlet weak var ratingLbl: UILabel!
   
    @IBOutlet weak var carReceivedLbl: UILabel!
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var completeLbl: UILabel!
    @IBOutlet weak var takenLbl: UILabel!
    @IBOutlet weak var amtRefundLbl: UILabel!
    @IBOutlet weak var paymentStatusLbl: UILabel!

    @IBOutlet weak var carReceivedStepBtn: UIButton!
    @IBOutlet weak var progressStepBtn: UIButton!
    @IBOutlet weak var completeStepBtn: UIButton!
    @IBOutlet weak var takenStepBtn: UIButton!
    
    @IBOutlet weak var carReceivedUpdateBtn: AppButton!
    @IBOutlet weak var progressUpdateBtn: AppButton!
    @IBOutlet weak var completeUpdateBtn: AppButton!
    @IBOutlet weak var takenUpdateBtn: AppButton!
    
    @IBOutlet weak var refundedAmountLbl: UILabel!
    @IBOutlet weak var amountPaidlbl: UILabel!
    @IBOutlet weak var paidLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var carRecievedStackView: UIStackView!

    @IBOutlet weak var carServiceLineView: UIView!
    @IBOutlet weak var completedLineView: UIView!
    @IBOutlet weak var readyToBeTakenLineView: UIView!


    //MARK:-Variables
    var carReceivedUpdateBtnTapped : (()->())?
    var inProgressUpdateBtnTapped : (()->())?
    var completedUpdateBtnTapped : (()->())?
    var takenUpdateBtnTapped : (()->())?
    var yesBtnTapped : (()->())?
    var noBtnTapped : (()->())?
    var rateNowBtnTapped : ((UIButton)->())?
    var editRatingReviewBtnTapped : ((UIButton)->())?

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
        
        amtRefundLbl.font = AppFonts.NunitoSansBold.withSize(13.0)
        amtRefundLbl.text = LocalizedString.amountRefunded.localized

        
        carReceivedLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        progressLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        completeLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        takenLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
      
        carReceivedLbl.text = LocalizedString.carReceived.localized
        progressLbl.text    = LocalizedString.carServiceInProgress.localized
        completeLbl.text    = LocalizedString.carServiceCompleted.localized
        takenLbl.text       = LocalizedString.carReadyToBeTaken.localized
        
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
    
    func populateData(status: ServiceState?) {
       
        if status == nil {
            carReceivedUpdateBtn.isHidden = false
            carReceivedUpdateBtn.isEnabled = true
        }
        
        if status == .startService {
            carReceivedLbl.textColor = AppColors.fontPrimaryColor
            carReceivedStepBtn.setTitle(nil, for: .normal)
            carReceivedStepBtn.setImage(#imageLiteral(resourceName: "group467"), for: .normal)
            carReceivedUpdateBtn.isHidden = true
            progressUpdateBtn.isEnabled = true
        }
        
        if status == .inProgress {
            carReceivedLbl.textColor = AppColors.fontPrimaryColor
            progressLbl.textColor = AppColors.fontPrimaryColor
            carReceivedStepBtn.setTitle(nil, for: .normal)
            carReceivedStepBtn.setImage(#imageLiteral(resourceName: "group467"), for: .normal)
            progressStepBtn.setImage(#imageLiteral(resourceName: "group467"), for: .normal)
            progressStepBtn.setTitle(nil, for: .normal)
            carReceivedUpdateBtn.isHidden = true
            progressUpdateBtn.isHidden = true
            carServiceLineView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.6352941176, blue: 0.5411764706, alpha: 1)
            completeUpdateBtn.isEnabled = true

        }
        
        if status == .readyToBeTaken {
            carReceivedLbl.textColor = AppColors.fontPrimaryColor
            progressLbl.textColor = AppColors.fontPrimaryColor
            completeLbl.textColor = AppColors.fontPrimaryColor
         
            carReceivedStepBtn.setTitle(nil, for: .normal)
            carReceivedStepBtn.setImage(#imageLiteral(resourceName: "group467"), for: .normal)
            carReceivedUpdateBtn.isHidden = true
            
            progressStepBtn.setImage(#imageLiteral(resourceName: "group467"), for: .normal)
            progressStepBtn.setTitle(nil, for: .normal)
            progressUpdateBtn.isHidden = true
           
            completeStepBtn.setImage(#imageLiteral(resourceName: "group467"), for: .normal)
            completeUpdateBtn.isHidden = true
            completeStepBtn.setTitle(nil, for: .normal)
            carServiceLineView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.6352941176, blue: 0.5411764706, alpha: 1)
            completedLineView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.6352941176, blue: 0.5411764706, alpha: 1)
            
            takenUpdateBtn.isEnabled = true
        }
        
        if status == .delivered {
            carReceivedLbl.textColor = AppColors.fontPrimaryColor
            progressLbl.textColor = AppColors.fontPrimaryColor
            completeLbl.textColor = AppColors.fontPrimaryColor
            takenLbl.textColor = AppColors.fontPrimaryColor

            carReceivedStepBtn.setTitle(nil, for: .normal)
            carReceivedStepBtn.setImage(#imageLiteral(resourceName: "group467"), for: .normal)
            carReceivedUpdateBtn.isHidden = true
            
            progressStepBtn.setTitle(nil, for: .normal)
            progressStepBtn.setImage(#imageLiteral(resourceName: "group467"), for: .normal)
            progressUpdateBtn.isHidden = true
           
            completeStepBtn.setImage(#imageLiteral(resourceName: "group467"), for: .normal)
            completeStepBtn.setTitle(nil, for: .normal)
            completeUpdateBtn.isHidden = true
          
            takenStepBtn.setImage(#imageLiteral(resourceName: "group467"), for: .normal)
            takenStepBtn.setTitle(nil, for: .normal)
            takenUpdateBtn.isHidden = true
           
            carServiceLineView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.6352941176, blue: 0.5411764706, alpha: 1)
            completedLineView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.6352941176, blue: 0.5411764706, alpha: 1)
            readyToBeTakenLineView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.6352941176, blue: 0.5411764706, alpha: 1)
        }
    }
    
    func populateDataForUserService(status: ServiceState?, isServiceCompleted : Bool,model: GarageRequestModel = GarageRequestModel(),isNoBtnTapped : Bool = false) {
        carReceivedUpdateBtn.isHidden = true
        progressUpdateBtn.isHidden = true
        completeUpdateBtn.isHidden = true
        takenUpdateBtn.isHidden = true
        
        self.noRatingContainerView.isHidden = !(model.ratingDetails?._id?.isEmpty ?? true)
        if status != .delivered  {
            self.noRatingContainerView.isHidden = true
        }
        self.ratingContainerView.isHidden = (model.ratingDetails?._id?.isEmpty ?? true)
//        self.bottomDashedVIew.isHidden =  self.noRatingContainerView.isHidden && self.ratingContainerView.isHidden
        
        if (model.ratingDetails?._id?.isEmpty ?? true) {
            if isNoBtnTapped {
                self.noRatingContainerView.isHidden = !(model.isServiceCompleted ?? true)
//                self.bottomDashedVIew.isHidden = !(model.isServiceCompleted ?? true)
            }else {
                self.noRatingContainerView.isHidden = true
//                self.bottomDashedVIew.isHidden = true
            }
        }

        if status == nil {
            carReceivedUpdateBtn.isHidden = false
            carReceivedUpdateBtn.isEnabled = true
        }
        
        if status == .startService {
            carReceivedLbl.textColor = AppColors.fontPrimaryColor
            carReceivedStepBtn.setTitle(nil, for: .normal)
            carReceivedStepBtn.setImage(#imageLiteral(resourceName: "group467"), for: .normal)
            carReceivedUpdateBtn.isHidden = true
            progressUpdateBtn.isEnabled = true
        }
        
        if status == .inProgress {
            carReceivedLbl.textColor = AppColors.fontPrimaryColor
            progressLbl.textColor = AppColors.fontPrimaryColor
            carReceivedStepBtn.setTitle(nil, for: .normal)
            carReceivedStepBtn.setImage(#imageLiteral(resourceName: "group467"), for: .normal)
            progressStepBtn.setImage(#imageLiteral(resourceName: "group467"), for: .normal)
            progressStepBtn.setTitle(nil, for: .normal)
            carReceivedUpdateBtn.isHidden = true
            progressUpdateBtn.isHidden = true
            carServiceLineView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.6352941176, blue: 0.5411764706, alpha: 1)
            completeUpdateBtn.isEnabled = true

        }
        
        if status == .readyToBeTaken {
            carReceivedLbl.textColor = AppColors.fontPrimaryColor
            progressLbl.textColor = AppColors.fontPrimaryColor
            completeLbl.textColor = AppColors.fontPrimaryColor
         
            carReceivedStepBtn.setTitle(nil, for: .normal)
            carReceivedStepBtn.setImage(#imageLiteral(resourceName: "group467"), for: .normal)
            carReceivedUpdateBtn.isHidden = true
            
            progressStepBtn.setImage(#imageLiteral(resourceName: "group467"), for: .normal)
            progressStepBtn.setTitle(nil, for: .normal)
            progressUpdateBtn.isHidden = true
           
            completeStepBtn.setImage(#imageLiteral(resourceName: "group467"), for: .normal)
            completeUpdateBtn.isHidden = true
            completeStepBtn.setTitle(nil, for: .normal)
            carServiceLineView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.6352941176, blue: 0.5411764706, alpha: 1)
            completedLineView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.6352941176, blue: 0.5411764706, alpha: 1)
            
            takenUpdateBtn.isEnabled = true
        }
        
        if status == .delivered {
            carReceivedLbl.textColor = AppColors.fontPrimaryColor
            progressLbl.textColor = AppColors.fontPrimaryColor
            completeLbl.textColor = AppColors.fontPrimaryColor
            takenLbl.textColor = AppColors.fontPrimaryColor

            carReceivedStepBtn.setTitle(nil, for: .normal)
            carReceivedStepBtn.setImage(#imageLiteral(resourceName: "group467"), for: .normal)
            carReceivedUpdateBtn.isHidden = true
            
            progressStepBtn.setTitle(nil, for: .normal)
            progressStepBtn.setImage(#imageLiteral(resourceName: "group467"), for: .normal)
            progressUpdateBtn.isHidden = true
           
            completeStepBtn.setImage(#imageLiteral(resourceName: "group467"), for: .normal)
            completeStepBtn.setTitle(nil, for: .normal)
            completeUpdateBtn.isHidden = true
          
            takenStepBtn.setImage(#imageLiteral(resourceName: "group467"), for: .normal)
            takenStepBtn.setTitle(nil, for: .normal)
            takenUpdateBtn.isHidden = true
           
            carServiceLineView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.6352941176, blue: 0.5411764706, alpha: 1)
            completedLineView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.6352941176, blue: 0.5411764706, alpha: 1)
            readyToBeTakenLineView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.6352941176, blue: 0.5411764706, alpha: 1)
            carRecievedStackView.isHidden = false
        }
        
        if isServiceCompleted {
            carRecievedStackView.isHidden = true
        }
        if let paymentStatus = model.paymentStatus{
            self.paidLbl.textColor = (paymentStatus.textColor)
            self.paidLbl.text = (paymentStatus == .paid ) ? LocalizedString.paid_Caps.localized : paymentStatus.text
            self.amountLbl.text = "\(model.amountPaid ?? 0.0)" + " " + LocalizedString.sar.localized
            self.refundedPaymentView.isHidden = !(paymentStatus == .refunded)
        }
       
    }
    
    //MARK:- IBActions
   
    @IBAction func carReceivedBtnAction(_ sender : UIButton) {
        carReceivedUpdateBtnTapped?()
    }
   
    @IBAction func progressBtnAction(_ sender : UIButton) {
        inProgressUpdateBtnTapped?()
    }
    
    @IBAction func completeBtnAction(_ sender : UIButton) {
        completedUpdateBtnTapped?()
    }
    
    @IBAction func takenBtnAction(_ sender : UIButton) {
        takenUpdateBtnTapped?()
    }
    
    
    @IBAction func yesBtnAction(_ sender : UIButton) {
        yesBtnTapped?()
    }
    
    
    @IBAction func noBtnAction(_ sender : UIButton) {
        noBtnTapped?()
    }
    
    @IBAction func rateNowBtnAction(_ sender: UIButton) {
        if let handle = rateNowBtnTapped{
            handle(sender)
        }
    }
    
    @IBAction func editRatingReviewBtnAction(_ sender: UIButton) {
        if let handle = editRatingReviewBtnTapped{
            handle(sender)
        }
    }
}
