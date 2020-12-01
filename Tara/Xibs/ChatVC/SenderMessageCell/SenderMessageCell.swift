//
//  SenderMessageCell.swift
//  Tara
//
//  Created by Admin on 02/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import Firebase
import FirebaseFirestore
import UIKit

class SenderMessageCell: UITableViewCell {
    
    @IBOutlet weak var senderNameLbl: UILabel!
    @IBOutlet weak var senderMsgLbl: UILabel!
    @IBOutlet weak var senderImgView: UIImageView!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var deliveredImgview: UIImageView!
    @IBOutlet weak var readImageView: UIImageView!
      
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        senderImgView.round()
        dataContainerView.roundCorners([.topRight,.topLeft,.bottomLeft], radius: 15)
    }


}


//MARK: PRIVATE FUNCTIONS
//=======================
extension SenderMessageCell {
    
    private func initialSetup() {
        senderNameLbl.isHidden = true
        senderImgView.isUserInteractionEnabled = true
    }
    
    public func configureCellWith(model: Message) {
        self.senderMsgLbl.text = model.messageText
        self.senderImgView.setImage_kf(imageString: UserModel.main.image, placeHolderImage: #imageLiteral(resourceName: "placeHolder"), loader: false)
        let date = model.messageTime.dateValue()
        self.timeLbl.text = date.convertToTimeString()//"\(date.timeAgoSince)"
        self.deliveredImgview.image = model.messageStatus < 2 ? #imageLiteral(resourceName: "icSingletick") : #imageLiteral(resourceName: "redTickOne")
        self.readImageView.isHidden = model.messageStatus < 2
        self.contentView.layoutIfNeeded()
    }
    
    public func populateCellWith(dict: [String: Any]) {
        self.senderNameLbl.isHidden = false
        self.senderMsgLbl.text = dict[ApiKey.messageText] as? String ?? ""
        let date = (dict[ApiKey.messageTime] as? Timestamp ?? Timestamp()).dateValue()
        self.timeLbl.text = date.convertToTimeString()//"\(date.timeAgoSince)"
        self.contentView.layoutIfNeeded()
    }
}
