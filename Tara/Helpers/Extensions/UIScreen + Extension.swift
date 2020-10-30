//
//  UIScreen + Extension.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

extension UIScreen {
    static var width:CGFloat {
        return UIScreen.main.bounds.width
    }
    static var height:CGFloat {
        return UIScreen.main.bounds.height
    }
    static var size:CGSize {
        return UIScreen.main.bounds.size
    }
}
