//
//  RectangularDashedView.swift
//  ArabianTyres
//
//  Created by Admin on 17/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

class RectangularDashedView: UIView {
    
//    @IBInspectable var cornerRadius: CGFloat = 0 {
//        didSet {
//            layer.cornerRadius = cornerRadius
//            layer.masksToBounds = cornerRadius > 0
//        }
//    }
    @IBInspectable var dashWidth: CGFloat = 1.00
    @IBInspectable var dashColor: UIColor = #colorLiteral(red: 0.3294117647, green: 0.337254902, blue: 0.3607843137, alpha: 0.5)
    @IBInspectable var dashLength: CGFloat = 8.0
    @IBInspectable var betweenDashesSpace: CGFloat = 5.0
    
    var dashBorder: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}
