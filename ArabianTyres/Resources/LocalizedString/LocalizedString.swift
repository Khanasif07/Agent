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
    
    // MARK: - Alert Values
    //==============================
    case chooseOptions = "chooseOptions"
    case chooseFromGallery = "chooseFromGallery"
    case takePhoto = "takePhoto"
    case cancel = "cancel"
    case removePicture = "removePicture"
    case alert
    case settings
    case english
    case arabic
    case continueTitle
    
    case tutorialTitle1 = "tutorialTitle1"
    case tutorialTitle2 = "tutorialTitle2"
    case tutorialTitle3 = "tutorialTitle3"
    
}


extension LocalizedString {
    var localized : String {
        return self.rawValue.localized
    }
}
