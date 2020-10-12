//
//  DistanceSliderCollViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 09/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import TTRangeSlider

class DistanceSliderCollViewCell: UICollectionViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var rangeSlider: TTRangeSlider!
    var sliderValueChanged: ((String, String)->())?
  
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        handleRangeSlider()
        
        // Initialization code
    }
    
    //MARK:- functions
    private func handleRangeSlider(){
        rangeSlider.minLabelFont = AppFonts.NunitoSansSemiBold.withSize(12.0)
        rangeSlider.maxLabelFont = AppFonts.NunitoSansSemiBold.withSize(12.0)
        rangeSlider.handleImage = #imageLiteral(resourceName: "slider")
        rangeSlider.delegate = self
        rangeSlider.minValue = 0
        rangeSlider.maxValue = 100
        rangeSlider.selectedMinimum = 10
        rangeSlider.selectedMaximum = 50
        rangeSlider.selectedHandleDiameterMultiplier = 1
        let formatter = NumberFormatter()
        formatter.positiveSuffix = "KM"
        rangeSlider.numberFormatterOverride = formatter
    }
    
}

extension DistanceSliderCollViewCell : TTRangeSliderDelegate{
    func didEndTouches(in sender: TTRangeSlider!) {
        sliderValueChanged?("\(sender.selectedMinimum.rounded())", "\(sender.selectedMaximum.rounded())")
    }
}
