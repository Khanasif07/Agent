//
//  ReceiverMediaCell.swift
//  Tara
//
//  Created by Admin on 03/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Firebase

class ReceiverMediaCell: UITableViewCell {
    
    //    MARK: VARIABLES
    //    ===============
    
    //    MARK: OUTLETS
    //    =============
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var msgContainerView: UIView!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var deliveredImgview: UIImageView!
    @IBOutlet weak var readImageView: UIImageView!
    
    //    MARK: CELL LIFE CYCLE
    //    =====================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        msgContainerView.roundCorners([.topLeft, .topRight, .bottomLeft], radius: 15)
        mediaImageView.round(radius: 4.0)
        userImgView.round()
    }
    
}

//MARK: PRIVATE FUNCTIONS
//=======================
extension ReceiverMediaCell {
    
    private func initialSetup() {
        
    }
    
    public func configureCellWith(model: Message) {
        self.userImgView.setImage_kf(imageString: UserModel.main.image, placeHolderImage: #imageLiteral(resourceName: "placeHolder"), loader: false)
        self.mediaImageView.setImage_kf(imageString: model.mediaUrl, placeHolderImage: #imageLiteral(resourceName: "icImg"), loader: true)
        let date = model.messageTime.dateValue()
        self.timeLabel.text = date.convertToTimeString()//"\(date.timeAgoSince)"
        self.deliveredImgview.image = model.messageStatus < 2 ? #imageLiteral(resourceName: "icSingletick") : #imageLiteral(resourceName: "redTickOne")
        self.readImageView.isHidden = model.messageStatus < 2
        self.contentView.layoutIfNeeded()
    }
    
    public func populateData(dict: [String: Any]) {
        self.deliveredImgview.image = #imageLiteral(resourceName: "icSingletick")
        self.readImageView.isHidden = true
        guard let url = dict[ApiKey.mediaUrl] as? String else { return }
        mediaImageView.setImage_kf(imageString: url, placeHolderImage: #imageLiteral(resourceName: "icImg"), loader: true)
//        let date = ((dict[ApiKey.messageTime] as? Timestamp) ?? Timestamp()).dateValue()
//        self.timeLabel.text = date.convertToTimeString()//"\(date.timeAgoSince)"
        self.contentView.layoutIfNeeded()
    }
}
