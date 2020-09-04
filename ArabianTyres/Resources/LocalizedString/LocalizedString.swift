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
    case login_with_emailId = "login_with_emailId"
    case chooseLanguage = "chooseLanguage"
    
    // MARK: - Login VC Values
    //==============================
    case emailID = "emailId"
    case password = "password"
    case emailIdPlaceHolder = "emailIdPlaceHolder"
    case usePhoneNumber = "usePhoneNumber"
    case forgotPassword = "forgotPassword"
    case sign_in = "sign_in"
    case signupcap = "signupcap"
    case Login_with_social_accounts = "Login_with_social_accounts"
    case sKIP_LOGIN_CONTINUE = "sKIP_LOGIN_CONTINUE"
    case dont_have_an_account = "dont_have_an_account"
}


extension LocalizedString {
    var localized : String {
        return self.rawValue.localized
    }
}
