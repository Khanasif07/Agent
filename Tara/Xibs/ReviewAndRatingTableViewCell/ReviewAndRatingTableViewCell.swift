//
//  ReviewAndRatingTableViewCell.swift
//  Tara
//
//  Created by Arvind on 04/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ReviewAndRatingTableViewCell: UITableViewCell {
    
    //MARK:-IBOutlets
    @IBOutlet var starBtns: [UIButton]!
    @IBOutlet weak var reviewRatingLbl: UILabel!
    @IBOutlet weak var reviewLbl: UILabel!
    @IBOutlet weak var reviewReportedLbl: UILabel!
    @IBOutlet weak var reviewReasonLbl: UILabel!
    @IBOutlet weak var reportReviewBtn: UIButton!
    @IBOutlet weak var imgContainerStackView: UIStackView!
    @IBOutlet weak var reviewReportStackView: UIStackView!
    @IBOutlet weak var firstImgView: UIImageView!
    @IBOutlet weak var secondImgView: UIImageView!

    //MARK:- Variables
    var reportReviewBtnTapped: (()->())?
    
    //MARK:-Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextAndFonts()
        imgContainerStackView.isHidden = true
    }
    
    private func setupTextAndFonts() {
        reviewRatingLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        reviewReportedLbl.font = AppFonts.NunitoSansBold.withSize(13.0)
        reviewReasonLbl.font = AppFonts.NunitoSansBold.withSize(13.0)
        
        reviewRatingLbl.text = LocalizedString.reviewAndRatings.localized
    }
    
    @IBAction func reportReviewBtnAction(_ sender: UIButton) {
        reportReviewBtnTapped?()
    }
    
    func bindData(_ model: GarageRequestModel, screenType: ServiceCompletedVC.ScreenType) {
        if let rating = model.rating {
            for i in 0...starBtns.count - 1{
                if i < Int(rating) {
                    starBtns[i].isSelected = true
                }else {
                    starBtns[i].isSelected = false
                }
            }
        }
        reviewLbl.text = model.review
        setData(model,screenType)
        if !(model.images?.isEmpty ?? true) {
            imgContainerStackView.isHidden = false
            firstImgView.setImage_kf(imageString: model.images?.first ?? "", placeHolderImage: #imageLiteral(resourceName: "placeHolder"), loader: true)
        }else {
            
        }
    }
    
    private func setData(_ model: GarageRequestModel, _ screenType: ServiceCompletedVC.ScreenType) {
       
        //for service complete detail
        if screenType == .serviceComplete {
            if model.isReviewReported ?? false {
                
                reviewReportStackView.isHidden = false
                reportReviewBtn.isHidden = true
                let date = (model.reportedTime)?.breakCompletDate(outPutFormat: Date.DateFormat.profileFormat.rawValue, inputFormat: Date.DateFormat.yyyyMMddTHHmmsssssz.rawValue)
                
                reviewReportedLbl.text = "Review Reported on " + (date ?? "")
                reviewReasonLbl.text = "Reason: " + (model.reportReason ?? "")
            }
            else {
                reportReviewBtn.isHidden = false
                reviewReportStackView.isHidden = true
            }
        }
            
        //for service history detail
        else {
        
            reportReviewBtn.isHidden = true
            reviewReportStackView.isHidden = true
        }
    }
}
