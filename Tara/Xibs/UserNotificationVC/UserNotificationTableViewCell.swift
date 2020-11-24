//
//  UserNotificationTableViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 27/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class UserNotificationTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var subHeadingLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var crossbtn: UIButton!

    //MARK:- Variables
    var cancelBtnTapped :(()->())?
    
    //MARK:-Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextAndFont()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        
    }
    
    private func setupTextAndFont() {
        headingLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        subHeadingLbl.font = AppFonts.NunitoSansSemiBold.withSize(12.0)
        timeLbl.font = AppFonts.NunitoSansSemiBold.withSize(12.0)
        
    }
    
    func bindData(_ model: NotificationModel) {
        containerView.backgroundColor = model.isRead ? #colorLiteral(red: 0.6078431373, green: 0.6509803922, blue: 0.6823529412, alpha: 0.2) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        headingLbl.text = model.title
        subHeadingLbl.text = model.message
        let date = (model.createdAt)?.toDate(dateFormat: Date.DateFormat.givenDateFormat.rawValue) ?? Date()
        timeLbl.text = date.timeAgoSince
        lineView.backgroundColor = model.code?.color
        imgView.image = model.code?.image
        
    }
    
    @IBAction func crossbtnAction(_ sender: UIButton) {
        cancelBtnTapped?()
    }
}
