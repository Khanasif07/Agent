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
    case imageUploadingFailed
    case accountNumberAreNotSame
    case minTenDigitInAccountNumber
    
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
    case yourRegRequestHasBeenAccepted
    case byDate
    case byServiceType
    case byStatus
    case tyreService
    case oilSevice
    case batteryService
    case offerAccepted
    case offerReceived
    case noOffers
    
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
    
    // MARK: - Garage Profile VC Values
    //==============================
    case service_Completed
    case bank_Account
    case my_Subscription
    case installation_price_range
    case location
   

    // MARK: - Profile VC Values
      //==============================
    case aboutUs
    case terms_Condition
    case privacy_policy
    case contactUs
    case changeLanguage
    case switchProfileTogarage
    case switchProfileToUser
    case createGarageProfile
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
    case serviceCenterNames
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
    case update
    case enterVehicleMake
    case enterVehicleModel
    case enterModelYear
    case enteryYourVehicleDetails
    case wellGetYouExactTyreSize
    case vehicleMake
    case vehicleModel
    case modelYear
    case thePreferredOriginForMytyreWouldBe
    case setYourPreferencesAmongTyreBrandOrCountryOrigin
    case tyreBrand
    case countryOrigin
    case selectTyreBrand
    case selectCountryOrigin
    case brands
    case origin
    case selectBrand
    case brandName
    case selectCountry
    case countryName
    case arabianTyresWantToAccessYourCurrentLocation
    case allowCureentLocationWillHelpYouInGettingGreatOffers
    case allow
    case installationPriceRange
    case chooseOilType
    case theTypeOfOilAreYouLookingFor
    case thePreferredBrandForMyOilWouldBe
    case chooseOilBrand
    case selectType
    case oilType
    case selectTyreSize
    case weHaveFoundSutiableTyreForYourVehicleAsPerTheProvidedDetails
    case pleaseSelectAnyTyreToProceed
    case selectViscosity
    case weHaveFoundSutiableOilViscosity
    case pleaseSelectAnyViscosityToProceed
    case next
    case proceed
    case thePreferredBrandForBatteryWouldBe
    case chooseBatteryBrands
    case enterNumber
    case country
    case chooseYourVehicleDetails
    case wellGetYouOilAccordingToTheProvidedDetails
    case numberOfTyre
    case edit
    case submitRequest
    case youAreRequestingForTyreServiceWith
    case sizeOfTyre
    case originOfTyre
    case productYear
    case skipAndSubmit
    case chooseQuantity
    case vehicleDetails
    case batteyRequest
    case batteryBrand
    case numberOfBattery
    case oilBrands
    case numberOfUnit
    case oilRequest
    case oilImage
    case selectNumberOfUnitYouWant
    case viewTutorial
    case underDevelopment
    case pleaseSelectServices
    case pleaseSelectServiceCenterImage
    case ongoingServices
    case tyreServiceRequest
    case regNo
    case serviceStatus
    case enterBiddingAmount
    case placeBid
    case biddingAmountOnceSubmittedWillNeverBeChanged
    case sar
    case notNow
    case placeABid
    case weHaveSent
    case otp
    case pleaseVerifyTheSameInOrderToStartServicing
    case to
    case verify
    case filter
    case apply
    case requestCreatedBy
    case requestAcceptedOn
    case paybleAmount
    case serviceDetails
    case tyreSize
    case preferredBrand
    case chat
    case startService
    case userDetails
    case paymentStatus
    case amountPaid
    case serviceRequest
    case distance
    case bidReceived
    case howWasOverAllExp
    case rateOutOfFive
    case describeWhy
    case uploadAnyPictureOfYourExperience
    case rateService
    case typeHere
    case fromDate
    case endDate
    // MARK: - Home  VC Values
    //==============================
    case tyre
    case oil
    case battery
    
    
    // MARK:c - Complete profile 1  VC Values
    //==============================
    case enterServiceCenterDist
    case enterServiceCenterAddress
    case serviceCenterDist
    case serviceCenterAddress
    
    case width
    case rimSize
    case quantity
    case enter_number_of_tyre_you_want
   
}


extension LocalizedString {
    var localized : String {
        return self.rawValue.localized
    }
}
