//
//  LocalizedString.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

enum LocalizedString : String {
    
    // MARK:- App Title
    //===================
    case appTitle = "NewProject"
    case ok = "ok"
    case dot = "\u{2022}"
    
}


extension LocalizedString {
    var localized : String {
        return self.rawValue.localized
    }
}
