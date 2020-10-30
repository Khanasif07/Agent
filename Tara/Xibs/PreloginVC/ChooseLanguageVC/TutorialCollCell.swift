//
//  TutorialCollCell.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TutorialCollCell: UICollectionViewCell {
    
    @IBOutlet weak var tutorialLbl: UILabel!
    @IBOutlet weak var tutorialImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.tutorialImgView.image = nil
    }
    
    //MARK:- Private Functions
    //===========================
    func populate(withImage image : UIImage,withTitle title : String) {
        self.tutorialImgView.image = image
        self.tutorialLbl.text = title
    }
    
    
}
