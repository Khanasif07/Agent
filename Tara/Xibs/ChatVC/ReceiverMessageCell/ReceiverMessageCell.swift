//
//  ReceiverMessageCell.swift
//  Tara
//
//  Created by Admin on 02/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ReceiverMessageCell: UITableViewCell {
    
    //    MARK: VARIABLES
    //    ===============
    
    //    MARK: OUTLETS
    //    =============
    
    @IBOutlet weak var receiverNameLbl: UILabel!
    @IBOutlet weak var receiverImgView: UIImageView!
    @IBOutlet weak var msgContainerView: UIView!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    //    MARK: CELL LIFE CYCLE
    //    =====================
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        msgContainerView.roundCorners([.topLeft, .topRight, .bottomRight], radius: 15)
    }
    
}

//MARK: PRIVATE FUNCTIONS
//=======================
extension ReceiverMessageCell {
    
    private func initialSetup() {
    }
    
    
    public func configureCellWith(model: Message) {
        self.msgLabel.isHidden = false
        self.msgLabel.text = model.messageText
        let date = model.messageTime.dateValue()
//        self.deliveredImgview.image = model.messageStatus < 2 ? #imageLiteral(resourceName: "icSingletick") : #imageLiteral(resourceName: "redTickOne")
//        self.readImageView.isHidden = model.messageStatus < 2
        self.timeLabel.text = date.convertToTimeString()
    }
    
    public func populateCellWith(dict: [String: Any]) {
//        self.deliveredImgview.image = #imageLiteral(resourceName: "icSingletick")
//        self.readImageView.isHidden = true
        self.msgLabel.isHidden = false
        self.msgLabel.text = dict[ApiKey.messageText] as? String ?? ""
        let date = (dict[ApiKey.messageTime] as? Timestamp ?? Timestamp()).dateValue()
        self.timeLabel.text = date.convertToTimeString()//"\(date.timeAgoSince)"
    }
}
