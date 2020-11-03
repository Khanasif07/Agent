//
//  SenderMediaCell.swift
//  Tara
//
//  Created by Admin on 03/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit
import Firebase

class SenderMediaCell: UITableViewCell {
    
    
    //    MARK: OUTLETS
    //    =============
    @IBOutlet weak var senderImageView: UIImageView!
    @IBOutlet weak var msgContainerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var senderNameLabel: UILabel!
    
    //    MARK: CELL LIFE CYCLE
    //    =====================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialSetup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        senderNameLabel.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        senderImageView.round()
        msgContainerView.roundCorners([.topRight,.bottomRight,.bottomLeft], radius: 15)
        mediaImageView.round(radius: 4.0)
    }
    
}

//MARK: PRIVATE FUNCTIONS
//=======================
extension SenderMediaCell {
    
    private func initialSetup() {
        senderNameLabel.isHidden = true
        senderImageView.isUserInteractionEnabled = true
    }
    
    public func configureCellWith(model: Message) {
        self.mediaImageView.setImage_kf(imageString: model.mediaUrl, placeHolderImage: #imageLiteral(resourceName: "icImg"), loader: true)
        let date = model.messageTime.dateValue()
        self.timeLabel.text = date.convertToTimeString()//"\(date.timeAgoSince)"
        self.contentView.layoutIfNeeded()
    }
    
    public func populateData(dict: [String: Any]) {
        senderNameLabel.isHidden = false
        guard let url = dict[ApiKey.mediaUrl] as? String else { return }
        mediaImageView.setImage_kf(imageString: url, placeHolderImage: #imageLiteral(resourceName: "icImg"), loader: true)
        let date = ((dict[ApiKey.messageTime] as? Timestamp) ?? Timestamp()).dateValue()
        self.timeLabel.text = date.convertToTimeString()//"\(date.timeAgoSince)"
        self.contentView.layoutIfNeeded()
    }
}
