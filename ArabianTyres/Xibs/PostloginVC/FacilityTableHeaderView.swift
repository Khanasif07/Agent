//
//  FacilityTableHeaderView.swift
//  ArabianTyres
//
//  Created by Arvind on 16/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class FacilityTableHeaderView: UITableViewHeaderFooterView {
    
    //MARK:- IBOutlets
    @IBOutlet weak var checkBtn : UIButton!
    @IBOutlet weak var categoryName : UILabel!
    @IBOutlet weak var arrowImg : UIImageView!
    @IBOutlet weak var cellBtn : UIButton!
    @IBOutlet weak var bottomView : UIView!
    
    var cellBtnTapped : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryName.font = AppFonts.NunitoSansBold.withSize(14.0)
    }
    
    func configureCell(isPowerSelected: Bool, model: TyreBrandModel){
        checkBtn.isSelected = isPowerSelected
    }
    
    func configureCell(isPowerSelected: Bool, model: TyreCountryModel){
        checkBtn.isSelected = isPowerSelected
    }
    
    
    
    @IBAction func cellBtnTapped(_ sender: UIButton) {
        cellBtnTapped?()
        arrowImg.isHighlighted.toggle()
    }
}
