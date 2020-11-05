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
        setSlider()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dataContainerView.roundCorners([.topLeft, .topRight, .bottomLeft], radius: 15)
        senderImgView.round()
        audioBtn.round()
    }
    
    
    public func setSlider(){
        loadingView.isHidden = true
       }
    
//    func stringFromTimeInterval(interval: TimeInterval) -> String {
//
//           let interval = Int(interval)
//           let seconds = interval % 60
//           let minutes = (interval / 60) % 60
//           let hours = (interval / 3600)
//           return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
//       }
     
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
