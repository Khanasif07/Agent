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
    case logout
    
    //MARK:- User TabBar Values
    //=========================
    case home
    case setting
    case notification
    case profile
    
    // MARK: - Alert Values
    //==============================
    case chooseOptions = "chooseOptions"
    case chooseFromGallery = "chooseFromGallery"
    case takePhoto = "takePhoto"
    case cancel = "cancel"
    case send
    case removePicture = "removePicture"
    case alert
    case settings
    case submit
    case login
    case sendOtp
    case english
    case arabic
    case continueTitle
    case mobileNo
    
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
    case addPhoneNumber = "addPhoneNumber"
    case sign_in = "sign_in"
    case sign_in_Cap
    case signupcap = "signupcap"
    case signup = "signup"
    case Login_with_social_accounts = "Login_with_social_accounts"
    case signup_with_social_accounts = "signup_with_social_accounts"
    case sKIP_LOGIN_CONTINUE = "sKIP_LOGIN_CONTINUE"
    case skip_signup_continue = "skip_signup_continue"
    case dont_have_an_account = "dont_have_an_account"
    case alreadyHaveAnAccount = "alreadyHaveAnAccount"
    
    // MARK: - Validation Messages
    //==================================
    case pleaseEnterValidEmail = "pleaseEnterValidEmail"
    case pleaseEnterValidPassword = "pleaseEnterValidPassword"
    case passwordDoesNotMatch = "passwordDoesNotMatch"
    case nameShouldBeAtleastMinCharacters = "nameShouldBeAtleastMinCharacters"
    case phoneNoShouldBeAtleastMinCharacters = "phoneNoShouldBeAtleastMinCharacters"
    case pleaseEnterName = "pleaseEntertName"
    case pleaseEnterMinTwoChar = "pleaseEnterMinTwoChar"
    case enterYourName = "enterYourName"
    case pleaseEnterNickName = "pleaseEnterNickName"
    case pleaseEnterEmail = "pleaseEnterEmail"
    case enterYourEmailId = "enterYourEmailId"
    case pleaseEnterPassword = "pleaseEnterPassword"
    case pleaseEnterValidPhoneNo = "pleaseEnterValidPhoneNo"
    case pleaseEnterPhoneNumber = "pleaseEnterPhoneNumber"
    case pleaseEnterminimumdigitsphonenumber
    case enterYourMobNumber = "enterYourMobNumber"
    case confirmPassword = "confirmPassword"
    case enterPhoneNumber = "enterPhoneNumber"
    case enterNewPassword = "enterNewPassword"
    case newPassword = "newPassword"
    case confirmNewPassword = "confirmNewPassword"
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
    case wait_Img_Upload
    case registerAgain
    case completeProfile
    case yourRegistrationRequestIsStillUnder
    case addFollowingGovtIssuedLicenceOrDocumentsHereForVerification
    case govtIssuedDoc
    case commercialRegister
    case vatCertificate
    case municipalityLicense
    case idOfTheOwner
    case register
    
    // MARK: - Sign Up VC Values
    //==============================
    case bySigningDec = "bySigningDec"
    case tos = "tos"
    case privacyPolicy = "privacyPolicy"
    
    // MARK: - Profile VC Values
    //==============================
    case my_vehicle
    case service_history
    case payments
    case saved_cards
    case added_location
    case change_password

    // MARK: - Profile VC Values
      //==============================
    case aboutUs
    case terms_Condition
    case privacy_policy
    case contactUs
    case changeLanguage
    case switchProfileTogarage
    case reportAnIssue
    case faq
    case referFriend
    
    case garageRegistration
    case startRegistration
    case requirementToRegister
    case garageLogo
    case authorisedNameOfServiceCenter
    case locationOfYourServiceCenter
    case imagesOfyourServiceCenter
    case govtIssuedlicensesandDocuments
    
    case garageLogoDesc
    case authorisedNameOfServiceCenterDesc
    case locationOfYourServiceCenterDesc
    case imagesOfyourServiceCenterDesc
    case govtIssuedlicensesandDocumentsDesc
    
    case addDetails
    case thisAllAboutMyServiceCenter
    case addFollowingGarageDetails
    case addLogo
    case saveContinue
    case enterServiceCenterName
    case serviceCenterName
    case saveAndContinueBtn
    case help
    case addAccounts
    case addBankAccountDetails
    case addCreditDebitCardDetails
    case and
    case iAgreeTo
    case add
    case selectYourBank
    case enterAccountNumber
    case confirmAccountNumber
    case selectBank
    case AccountNo
    case confirmAccountNo
    case pleaseEnterYourBankAccountDetails
    case linkedAccount
    case selectServiceCenterFacility
    case serviceCenterFacility
    case serviceCenterImage
    case done
    case clearAll
    case uploadGarageLogo
    
    // MARK: - Home  VC Values
    //==============================
    case tyre
    case oil
    case battery
}


extension LocalizedString {
    var localized : String {
        return self.rawValue.localized
    }
}
