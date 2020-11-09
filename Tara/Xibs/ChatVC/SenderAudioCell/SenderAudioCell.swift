//
//  SenderAudioCell.swift
//  Tara
//
//  Created by Admin on 04/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import AVFoundation

class SenderAudioCell: UITableViewCell {
    

    var playBtnTapped : (()->())?
    var sliderValueChangedAction : ((UISlider)->())?

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var customSlider: UISlider!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var senderImgView: UIImageView!
    @IBOutlet weak var senderNameLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var audioBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customSlider.value = 0.0
        loadingView.isHidden = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dataContainerView.roundCorners([.topLeft, .topRight, .bottomLeft], radius: 15)
        senderImgView.round()
        audioBtn.round()
    }
    
    
    public func setSlider(model: Message){
        self.senderImgView.setImage_kf(imageString: UserModel.main.image, placeHolderImage: #imageLiteral(resourceName: "placeHolder"), loader: false)
        self.customSlider.minimumValue = 0
        self.customSlider.maximumValue = Float(model.messageDuration).rounded()
        self.customSlider.isContinuous = true
        self.customSlider.tintColor = AppColors.appRedColor
        self.timeLbl.text = self.stringFromTimeInterval(interval: TimeInterval(model.messageDuration))
        
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d",minutes, seconds)
    }
    
     
    @IBAction func playBtnAction(_ sender: UIButton) {
        if let handle = playBtnTapped{
            handle()
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        if let handle = sliderValueChangedAction{
            handle(sender)
        }
    }
    
}

//MARK:- CustomSlider
//================

class CustomSliderr: UISlider {
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 2.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
    
}
