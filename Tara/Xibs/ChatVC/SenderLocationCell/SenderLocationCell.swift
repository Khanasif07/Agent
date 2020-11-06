//
//  SenderLocationCell.swift
//  Tara
//
//  Created by Arvind on 06/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SenderLocationCell: UITableViewCell {

    //MARK:-IBOutlets

    @IBOutlet weak var mapImgView: UIImageView!
    @IBOutlet weak var garageImgView: UIImageView!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var msgContainerView: UIView!

    //MARK:- Variables
    var finalLatitude = "28.5355"
    var finalLongitude = "77.391029"
    
    //MARK:-LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setStaticImgViewByMap()
    }

    private func setStaticImgViewByMap(){
        let url = "https://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=\(2 * Int(mapImgView.frame.size.width))x\(2 * Int(mapImgView.frame.size.height))&maptype=roadmap&key=\(AppConstants.googlePlaceApiKey)"

//        let staticMapUrl: String = "http://maps.google.com/maps/api/staticmap?markers=\(self.finalLatitude),\(self.finalLongitude)&\("zoom=15&size=\(2 * Int(mapImgView.frame.size.width))x\(2 * Int(mapImgView.frame.size.height))")&sensor=true"
        let mapUrl: NSURL = NSURL(string: url)!
        self.mapImgView.setImage_kf(imageString: "\(mapUrl)", placeHolderImage: #imageLiteral(resourceName: "icFadeTyre"), loader: true)

    }
}
