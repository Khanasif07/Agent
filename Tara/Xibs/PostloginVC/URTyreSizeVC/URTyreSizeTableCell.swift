//
//  URTyreSizeTableCell.swift
//  ArabianTyres
//
//  Created by Admin on 21/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class URTyreSizeTableCell: UITableViewCell {

    @IBOutlet weak var internalView: UIView!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var tyreVehicleLbl: UILabel!
    @IBOutlet weak var tyreSizeLbl: UILabel!
    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var radioBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func  populateData(isPowerSelected: Bool,model: TyreSizeModel){
        self.tyreSizeLbl.text = "\(model.width)" + "/ " +  "\(model.profile)"  + "R - " + "\(model.rimSize)"
        self.tyreVehicleLbl.text = LocalizedString.suitableFor.localized + " :" + TyreRequestModel.shared.makeName + "," + TyreRequestModel.shared.modelName
        radioBtn.isSelected = isPowerSelected
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.internalView.round(radius: 4.0)
        self.dataContainerView.addShadow(cornerRadius: 8, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 8)
    }
    
    
    func bindData(categoryType: Category) {
        switch categoryType {
        case .oil:
           mainImgView.image =  #imageLiteral(resourceName: "icOil")
            break
        case .tyres:
            mainImgView.image = #imageLiteral(resourceName: "radialCarTireI151")
            break
        case .battery:
            break
     
        }
    }
}
