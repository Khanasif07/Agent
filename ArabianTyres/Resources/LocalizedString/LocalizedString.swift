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
    case signup_with_social_accounts = "signup_with_social_accounts"
    case sKIP_LOGIN_CONTINUE = "sKIP_LOGIN_CONTINUE"
    case skip_signup_continue = "skip_signup_continue"
    case dont_have_an_account = "dont_have_an_account"
    
    // MARK: - Validation Messages
    //==================================
    case pleaseEnterValidEmail = "pleaseEnterValidEmail"
    case pleaseEnterValidPassword = "pleaseEnterValidPassword"
    case nameShouldBeAtleastMinCharacters = "nameShouldBeAtleastMinCharacters"
    case phoneNoShouldBeAtleastMinCharacters = "phoneNoShouldBeAtleastMinCharacters"
    case pleaseEnterName = "pleaseEntertName"
    case pleaseEnterNickName = "pleaseEnterNickName"
    case pleaseEnterEmail = "pleaseEnterEmail"
    case pleaseEnterPassword = "pleaseEnterPassword"
    case pleaseEnterValidPhoneNo = "pleaseEnterValidPhoneNo"
    case pleaseEnterPhoneNumber = "pleaseEnterPhoneNumber"
    case enterPhoneNumber = "enterPhoneNumber"
    case pleaseEnterZip = "pleaseEnterZip"
    case pleaseFillAllTheFields = "pleaseFillAllTheFields"
    case pleaseEnterNewPassword = "pleaseEnterNewPassword"
    case pleaseEnterConfirmNewPassword = "pleaseEnterConfirmNewPassword"
    case passwordsDoNotMatch = "passwordsDoNotMatch"
    case pleaseChooseCountryCode = "pleaseChooseCountryCode"
    case enterCorrectPhoneNo = "enterCorrectPhoneNo"
    case pleaseEnterEducation = "pleaseEnterEducation"
    case pleaseEnterExperience = "pleaseEnterExperience"
    case pleaseEnterDob = "pleaseEnterDob"
    case phoneNumber = "phoneNumber"
    
    // MARK: - Sign Up VC Values
    //==============================
    case bySigningDec = "bySigningDec"
    case tos = "tos"
    case privacyPolicy = "privacyPolicy"
    
}


extension LocalizedString {
    var localized : String {
        return self.rawValue.localized
    }
}
