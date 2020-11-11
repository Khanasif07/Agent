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

    //MARK:- Variables
    var reportReviewBtnTapped: (()->())?
    
    //MARK:-Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextAndFonts()
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
}
