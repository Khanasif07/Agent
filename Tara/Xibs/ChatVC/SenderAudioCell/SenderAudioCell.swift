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
    
//    var player:AVPlayer?
//    var playerItem:AVPlayerItem?
    fileprivate let seekDuration: Float64 = 10
    var playBtnTapped : (()->())?

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
    // Add playback slider
//        let url = URL(string: "https://s3.amazonaws.com/appinventiv-development/iOS/042F20FD-5A85-414A-BA53-1CC4BDB148D3-21530-000038DD82B5020E.m4a")
//        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
//        player = AVPlayer(playerItem: playerItem)
//        customSlider.minimumValue = 0
//        let duration : CMTime = playerItem.asset.duration
//        let seconds : Float64 = CMTimeGetSeconds(duration)
//        customSlider.maximumValue = Float(seconds)
//        customSlider.isContinuous = true
//        customSlider.tintColor = AppColors.appRedColor
//        timeLbl.text = self.stringFromTimeInterval(interval: seconds)
//
////       lblcurrentText.text = self.stringFromTimeInterval(interval: seconds1)
//
//       player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
//           if self.player!.currentItem?.status == .readyToPlay {
//               let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
//               self.customSlider.value = Float ( time );
//
////               self.lblcurrentText.text = self.stringFromTimeInterval(interval: time)
//           }
//
//           let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
//           if playbackLikelyToKeepUp == false{
//               print("IsBuffering")
//               self.playBtn.isHidden = true
////               self.loadingView.isHidden = false
//           } else {
//               //stop the activity indicator
//               print("Buffering completed")
//               self.playBtn.isHidden = false
////               self.loadingView.isHidden = true
//           }
//        }
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
//        if player?.rate == 0
//        {
//            player!.play()
//            self.playBtn.isHidden = true
////            self.loadingView.isHidden = false
//            playBtn.setImage(#imageLiteral(resourceName: "group3714"), for: UIControl.State.normal)
//        } else {
//            player!.pause()
//            playBtn.setImage(#imageLiteral(resourceName: "group3714"), for: UIControl.State.normal)
//        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
//        let seconds : Int64 = Int64(customSlider.value)
//        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
//
//        player!.seek(to: targetTime)
//
//        if player!.rate == 0
//        {
//            player?.play()
//        }
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
