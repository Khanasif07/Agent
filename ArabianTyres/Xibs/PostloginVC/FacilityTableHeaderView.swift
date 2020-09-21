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

    var cellBtnTapped : ((Bool)->())?
    var isSelected : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryName.font = AppFonts.NunitoSansBold.withSize(14.0)
    }
    
    @IBAction func checkBtnAction(_ sender: UIButton) {
//        checkBtn.isSelected.toggle()
    }
    
    @IBAction func cellBtnTapped(_ sender: UIButton) {
        isSelected.toggle()
        cellBtnTapped?(isSelected)
        arrowImg.isHighlighted.toggle()
    }
}
