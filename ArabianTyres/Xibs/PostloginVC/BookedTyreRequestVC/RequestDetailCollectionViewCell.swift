//
//  RequestDetailCollectionViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 06/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class RequestDetailCollectionViewCell: UICollectionViewCell {
    
    //MARK:-IBOutlets
    @IBOutlet weak var createdByLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var bidFinalisedBtn: UIButton!
    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bidFinalContainerView: UIView!
    @IBOutlet weak var helpBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupFont()
        // Initialization code
    }
    
    private func setupFont() {
        createdByLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        userNameLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        bidFinalisedBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        
    }
    func bindCell(_ cellType: CellType) {
        createdByLbl.text = cellType.text
        mainImgView.image = cellType.image
        bidFinalContainerView.isHidden = cellType != .created
        userNameLbl.textColor = cellType == .payAmount ? #colorLiteral(red: 0.1725490196, green: 0.7137254902, blue: 0.4549019608, alpha: 1) : #colorLiteral(red: 0.1098039216, green: 0.1137254902, blue: 0.1411764706, alpha: 1)
    }
    
    @IBAction func bidFinalisedBtnAction(_ sender: UIButton) {
        
    }
    
    @IBAction func helpBtnAction(_ sender: UIButton) {
        CommonFunctions.showToastWithMessage(LocalizedString.underDevelopment.localized)
    }
}
