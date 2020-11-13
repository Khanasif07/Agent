//
//  ReceiverAudioCell.swift
//  Tara
//
//  Created by Admin on 04/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ReceiverAudioCell: UITableViewCell {

    
    var playBtnTapped :(()->())?
    var sliderValueChangedAction : ((UISlider)->())?
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var customSlider: UISlider!
    @IBOutlet weak var receiverImgView: UIImageView!
    @IBOutlet weak var receiverNameLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var audioBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customSlider.value = 0.0
        loadingView.isHidden = true
        customSlider.setThumbImage( #imageLiteral(resourceName: "slider"), for: .normal)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dataContainerView.roundCorners([.topLeft, .topRight, .bottomRight], radius: 15)
        receiverImgView.round()
        audioBtn.round()
    }
    
    public func setSlider(model: Message){
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
