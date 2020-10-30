//
//  LineDashedView.swift
//  ArabianTyres
//
//  Created by Admin on 24/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import UIKit
import Foundation

class LineDashedView: UIView {
    
    
    var dashBorder: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = AppColors.fontTertiaryColor.withAlphaComponent(0.5).cgColor
        shapeLayer.lineWidth = 2
        // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
        shapeLayer.lineDashPattern = [2,3]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: self.frame.width, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
        self.dashBorder = shapeLayer
    }
}
