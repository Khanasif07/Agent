//
//  DayValueCell.swift
//  Tara
//
//  Created by Admin on 03/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class DayValueCell: UITableViewCell {
    
    //    MARK: VARIABLES
    //    ===============
    
    //    MARK: OUTLETS
    //    =============
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    //    MARK: CELL LIFE CYCLE
    //    =====================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.round(radius: 5)
    }
}

//MARK: PRIVATE FUNCTIONS
//=======================
extension DayValueCell {
    
    private func initialSetup() {
        
    }
}


