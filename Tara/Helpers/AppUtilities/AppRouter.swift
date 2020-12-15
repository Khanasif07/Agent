//
//  AppRouter.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

enum AppRouter {
    
    // MARK: - General Method to set Root VC
    //=========================================
    static func setAsWindowRoot(_ viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.setNavigationBarHidden(true, animated: true)
        UIView.transition(with: AppDelegate.shared.window!, duration: 0.33, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            AppDelegate.shared.window?.rootViewController = navigationController
        }, completion: nil)
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    // MARK: - General Method to set Root VC
    //=========================================
    static func defaultSetAsWindowRoot(_ navigationController: UINavigationController) {
        AppDelegate.shared.window?.rootViewController = navigationController
        AppDelegate.shared.window?.becomeKey()
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
       
    
    // MARK: - Show Landing Screen
    //===========================
    static func checkAppInitializationFlow() {
        //goToTestingVC()
       // return
        if isUserLoggedin {
            SocketIOManager.shared.establishConnection()
            switch isCurrentUserType {
            case .user:
                AppRouter.goToUserHome()
            case .garage:
                AppRouter.goToGarageHome()
            default:
                let lang = AppUserDefaults.value(forKey: .language).stringValue
                AppUserDefaults.removeAllValues()
                AppUserDefaults.save(value: lang, forKey: .language)
                AppUserDefaults.save(value: true, forKey: .isLanguageSelect)
            }
        } else {
            if AppUserDefaults.value(forKey: .isLanguageSelect).boolValue {
                AppRouter.goToUserHome()
            }else{
                self.makeChooseLanguageVCRoot()
            }
        }
    }
    
    static func goToTestingVC(){
        let scene = PaymentListingVC.instantiate(fromAppStoryboard: .GarageRequest)
        setAsWindowRoot(scene)
    }
    
    static func goToProfileSettingVC(vc: UIViewController){
        let scene = ProfileSettingVC.instantiate(fromAppStoryboard: .PostLogin)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToServiceCompletedVC(vc: UIViewController,screenType : ServiceCompletedVC.ScreenType){
        let scene = ServiceCompletedVC.instantiate(fromAppStoryboard: .GarageRequest)
        scene.screenType = screenType
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToReportPopupVC(vc: UIViewController){
        let scene = ReportPopupVC.instantiate(fromAppStoryboard: .GarageRequest)
        scene.delegate = vc as? PickerDataDelegate
        vc.modalPresentationStyle = .fullScreen
        vc.present(scene, animated: true, completion: nil)
        
    }
    
    
    static func goToGarageCustomerRatingVC(vc: UIViewController, requestId: String,name: String, screenType: ServiceCompletedVC.ScreenType){
        let scene = GarageCustomerRatingVC.instantiate(fromAppStoryboard: .GarageRequest)
        scene.requestId = requestId
        scene.name = name
        scene.screenType = screenType
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToEditProfileVC(vc: UIViewController & EditProfileVCDelegate,model: UserModel,isEditProfileFrom : EditProfileFrom){
        let scene = EditProfileVC.instantiate(fromAppStoryboard: .PostLogin)
        scene.delegate = vc
        scene.isEditProfileFrom = isEditProfileFrom
        scene.viewModel.userModel = model
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToBookedTyreRequestVC(vc: UIViewController, requestId : String,requestType : Category){
        let scene = BookedTyreRequestVC.instantiate(fromAppStoryboard: .GarageRequest)
        scene.requestId = requestId
        scene.viewModel.requestType = requestType
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToUserServiceRequestVC(vc: UIViewController ,requestId:String = "",serviceType:String = ""){
        let scene = UserServiceRequestVC.instantiate(fromAppStoryboard: .Garage)
        scene.viewModel.requestId = requestId
        scene.viewModel.serviceType = serviceType
        scene.delegate = vc as? UserServiceRequestVCDelegate
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToSignUpVC(vc: UIViewController){
        let scene = SignUpVC.instantiate(fromAppStoryboard: .Prelogin)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToLoginVC(vc: UIViewController){
        let scene = LoginVC.instantiate(fromAppStoryboard: .Prelogin)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToResetPasswordVC(vc: UIViewController,resetToken: String){
        let scene = ResetPasswordVC.instantiate(fromAppStoryboard: .Prelogin)
        scene.viewModel.resetToken = resetToken
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToSignWithPhoneVC(vc: UIViewController,loginOption:LoginWithPhoneOption = .basic ){
        let scene = LoginWithPhoneVC.instantiate(fromAppStoryboard: .Prelogin)
        scene.loginOption = loginOption
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func makeChooseLanguageVCRoot(){
        let scene = ChooseLanguageVC.instantiate(fromAppStoryboard: .Prelogin)
        setAsWindowRoot(scene)
    }
    
    static func makeLoginVCRoot(){
        let scene = LoginVC.instantiate(fromAppStoryboard: .Prelogin)
        setAsWindowRoot(scene)
    }
    
    static func makeSignUpVCRoot(){
        let scene = SignUpVC.instantiate(fromAppStoryboard: .Prelogin)
        setAsWindowRoot(scene)
    }
    
    static func showSuccessPopUp(vc: UIViewController & SuccessPopupVCDelegate,title: String,desc: String){
        let scene = SuccessPopupVC.instantiate(fromAppStoryboard: .Prelogin)
        scene.delegate = vc
        scene.titleLbl = title
        scene.desc = desc
        vc.modalPresentationStyle = .fullScreen
        vc.present(scene, animated: true, completion: nil)
    }
    
    static func showCountryVC(vc: UIViewController & CountryDelegate){
        let scene = CountryVC.instantiate(fromAppStoryboard: .Prelogin)
        scene.countryDelegate = vc
        vc.modalPresentationStyle = .fullScreen
        vc.present(scene, animated: true, completion: nil)
    }
    
    static func goToOtpVerificationVC(vc: UIViewController,phoneNo: String, countryCode: String,isComeForVerifyPassword: Bool = false,isComeFromSignUpScreen: Bool = false, isComeFromEditProfile: Bool = false,isEditProfileFrom: EditProfileFrom = .none){
        let scene = OtpVerificationVC.instantiate(fromAppStoryboard: .Prelogin)
        scene.viewModel.isComeForVerifyPassword = isComeForVerifyPassword
        scene.viewModel.isComeFromSignupScreen = isComeFromSignUpScreen
        scene.viewModel.isComeFromEditProfile = isComeFromEditProfile
        scene.isEditProfileFrom = isEditProfileFrom
        scene.viewModel.countryCode = countryCode
        scene.viewModel.phoneNo = phoneNo
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToUserHome() {
        let homeScene = UserTabBarController.instantiate(fromAppStoryboard: .Home)
        setAsWindowRoot(homeScene)
    }
    
    static func goToGarageRegistrationVC(vc: UIViewController){
        let scene = GarageRegistrationVC.instantiate(fromAppStoryboard: .Garage)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToAddDetailVC(vc: UIViewController){
        let scene = AddDetailVC.instantiate(fromAppStoryboard: .Garage)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToGarageHome() {
        let homeScene = GarageTabBarController.instantiate(fromAppStoryboard: .GarageHome)
        setAsWindowRoot(homeScene)
    }
    
    static func goToVehicleDetailVC(vc: UIViewController){
        let scene = VechicleDetailVC.instantiate(fromAppStoryboard: .UserHomeScreen)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToRegistraionPendingVC(vc: UIViewController, screenType: RegistraionPendingVC.ScreenType,msg: String, reason: [String], time: String){
        let scene = RegistraionPendingVC.instantiate(fromAppStoryboard: .Garage)
        scene.message = msg
        scene.reason = reason
        scene.time = time
        scene.screenType = screenType
        scene.registerBtnTapped = {
            AppRouter.goToGarageRegistrationVC(vc: vc)
        }
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToCompleteProfileStep1VC(vc: UIViewController){
        let scene = CompleteProfileStep1.instantiate(fromAppStoryboard: .PostLogin)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToTyreRequestedVC(vc: UIViewController){
        let scene = TyreRequestedVC.instantiate(fromAppStoryboard: .UserHomeScreen)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToOilRequestedVC(vc: UIViewController){
        let scene = OilRequestedVC.instantiate(fromAppStoryboard: .UserHomeScreen)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToUploadDocumentVC(vc: UIViewController){
        let scene = UploadDocumentVC.instantiate(fromAppStoryboard: .Garage)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToAddAccountVC(vc: UIViewController, screenType: AddAccountVC.ScreenType){
        let scene = AddAccountVC.instantiate(fromAppStoryboard: .Garage)
        scene.screenType = screenType
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToAddAccountDetailVC(vc: UIViewController, screenType: AddAccountVC.ScreenType){
        let scene = AddAccountDetailVC.instantiate(fromAppStoryboard: .Garage)
        scene.screenType = screenType
        scene.bankDetailDelegate = vc as? BankDetail
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToGarageProfileStep2VC(vc: UIViewController){
        let scene = GarageProfileStep2VC.instantiate(fromAppStoryboard: .Garage)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToGarageAddLocationVC(vc: UIViewController){
        let scene = GarageAddLocationVC.instantiate(fromAppStoryboard: .PostLogin)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToBatteryRequestedVC(vc: UIViewController){
        let scene = BatteryRequestedVC.instantiate(fromAppStoryboard: .UserHomeScreen)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToMyServiceFilterVC(vc: UIViewController,filterArr: [FilterScreen], completion : @escaping (([FilterScreen], Bool) -> ())){
        let scene = MyServiceFilterVC.instantiate(fromAppStoryboard: .GarageRequest)
        scene.sectionArr = filterArr
        scene.onTapApply = { (filterData,isReset) in
            completion(filterData, isReset)
        }
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goOfferFilterVC(vc: UIViewController,filterArr: [FilterScreen], completion : @escaping (([FilterScreen], Bool) -> ())){
        let scene = OfferFilterVC.instantiate(fromAppStoryboard: .GarageRequest)
        scene.sectionArr = filterArr
        scene.onTapApply = { (filterData,isReset) in
            completion(filterData, isReset)
        }
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToGarageAddImageVC(vc: UIViewController){
        let scene = GarageAddImageVC.instantiate(fromAppStoryboard: .PostLogin)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToBankListingVC(vc: UIViewController){
        let scene = BankListingVC.instantiate(fromAppStoryboard: .PostLogin)
        scene.bankDelegate = vc as? BankListingVMDelegate
        vc.modalPresentationStyle = .fullScreen
        vc.present(scene, animated: true)
    }
    
    static func goToTyreBrandVC(vc: UIViewController){
        let scene = TyreBrandVC.instantiate(fromAppStoryboard: .UserHomeScreen)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    
    static func goToBatteryBrandVC(vc: UIViewController){
        let scene = BatteryBrandVC.instantiate(fromAppStoryboard: .UserHomeScreen)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToChatEditBidVC(vc: UIViewController ,requestId:String){
        let scene = ChatEditBidVC.instantiate(fromAppStoryboard: .Chat)
        scene.viewModel.requestId = requestId
        vc.modalPresentationStyle = .fullScreen
        scene.delegate = vc as? ChatEditBidVCDelegate
        vc.present(scene, animated: true, completion: nil)
    }
    
    static func goToVehicleDetailForBatteryVC(vc: UIViewController){
        let scene = VehicleDetailForBatteryVC.instantiate(fromAppStoryboard: .UserHomeScreen)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToVehicleDetailForOilVC(vc: UIViewController){
        let scene = VehicleDetailForOilVC.instantiate(fromAppStoryboard: .UserHomeScreen)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToURTyreSizeVC(vc: UIViewController){
        let scene = URTyreSizeVC.instantiate(fromAppStoryboard: .UserRequest)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func presentLocationPopUpVC(vc: UIViewController){
        let scene = LocationPopUpVC.instantiate(fromAppStoryboard: .UserHomeScreen)
        scene.onAllowTap = {
            switch categoryType {
            case .tyres:
            AppRouter.goToTyreRequestedVC(vc: vc)
            case .battery:
            AppRouter.goToBatteryRequestedVC(vc: vc)
            case .oil:
            AppRouter.goToOilRequestedVC(vc: vc)
            }
        }
        vc.modalPresentationStyle = .fullScreen
        vc.present(scene, animated: true, completion: nil)
        
    }
    
    static func openPlaceBidPopUpVC(vc: UIViewController){
        let scene = PlaceBidPopUpVC.instantiate(fromAppStoryboard: .GarageRequest)
        vc.modalPresentationStyle = .fullScreen
        vc.present(scene, animated: true, completion: nil)
        
    }
    
    static func openOtpPopUpVC(vc: UIViewController, requestByUser : String, requestId : String, _ completion : @escaping (() -> ())){
        let scene = OtpPopUpVC.instantiate(fromAppStoryboard: .GarageRequest)
        scene.requestByUser = requestByUser
        scene.requestId = requestId
        scene.onVerifyTap = {
                completion()
        }
        vc.modalPresentationStyle = .fullScreen
        vc.present(scene, animated: true, completion: nil)
        
    }
    
    static func goToUserAllOffersVC(vc: UIViewController, requestId : String){
        let scene = UserAllOffersVC.instantiate(fromAppStoryboard: .Garage)
        scene.requestId = requestId
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func presentBottomSheetVC(vc: UIViewController){
        let scene = BottomSheetVC.instantiate(fromAppStoryboard: .PostLogin)
        vc.modalPresentationStyle = .fullScreen
        vc.present(scene, animated: true, completion: nil)
        
    }
    
    static func presentOfferDetailVC(vc: UIViewController,bidId: String, garageName: String, completion : @escaping (()-> ())){
        let scene = OffersDetailVC.instantiate(fromAppStoryboard: .Garage)
        scene.viewModel.bidId = bidId
        scene.viewModel.garageName = garageName
        scene.proposalBtnTapped = {
            completion()
        }
        vc.modalPresentationStyle = .overCurrentContext
        vc.present(scene, animated: true, completion: nil)
        
    }
    
    static func goToURTyreStep1VC(vc: UIViewController){
        let scene = URTyreStep1VC.instantiate(fromAppStoryboard: .UserRequest)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToSRFliterVC(vc: UIViewController,filterArr: [FilterScreen], completion : @escaping (([FilterScreen],Bool) -> ())){
        let scene = SRFilterVC.instantiate(fromAppStoryboard: .GarageRequest)
        scene.sectionArr = filterArr
        scene.onTapApply = { (filterData, isReset) in
            completion(filterData, isReset)
        }
        vc.navigationController?.pushViewController(scene, animated: true)
    }
   
    
    static func goToServiceStatusVC(vc: UIViewController, requestId : String,requestType : Category = .tyres, serviceNo: String = ""){
        let scene = ServiceStatusVC.instantiate(fromAppStoryboard: .GarageRequest)
        scene.requestId = requestId
        scene.serviceNo = serviceNo
        scene.viewModel.requestType = requestType
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToUserServiceStatusVC(vc: UIViewController, requestId : String){
        let scene = UserServiceStatusVC.instantiate(fromAppStoryboard: .GarageRequest)
        scene.requestId = requestId
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToRatingVC(vc: UIViewController, requestId : String,garageName: String,ratingId : String = "",ratingModel: RatingModel = RatingModel()){
        let scene = RatingVC.instantiate(fromAppStoryboard: .GarageRequest)
        scene.requestId = requestId
        scene.viewModel.ratingModel = ratingModel
        scene.ratingId = ratingId
        scene.garageName = garageName
        scene.delegate = vc as? PickerDataDelegate
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToContactUsVC(vc: UIViewController){
        let scene = ContactUsVC.instantiate(fromAppStoryboard: .GarageRequest)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    
    static func goToContactusPopupVC(vc: UIViewController, completion : @escaping (() -> ())){
        let scene = ContactusPopupVC.instantiate(fromAppStoryboard: .GarageRequest)
        scene.onContactUsBtnTapped = {
            AppRouter.goToContactUsVC(vc: vc)
        }
        scene.chatBtnTapped = {
            completion()
        }
        vc.modalPresentationStyle = .fullScreen
        vc.present(scene, animated: true, completion: nil)
    }
    
    static func goToGarageServiceRequestVC(vc: UIViewController,requestId : String,requestType : String, bidStatus: BidStatus){
        let scene = GarageServiceRequestVC.instantiate(fromAppStoryboard: .Garage)
        scene.bidStatus = bidStatus
        scene.requestId = requestId
        scene.viewModel.requestType = requestType
        scene.delegate = vc as? UserServiceRequestVCDelegate
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    // Redirect  to  Garage Service Detail screen
    static func goToGarageServiceRequestVCThroughNotification(_ requestId: String) {
        guard let nav: UINavigationController = AppDelegate.shared.window?.rootViewController as? UINavigationController else { return }
        if let homeScene = nav.hasViewController(ofKind: GarageTabBarController.self) as? GarageTabBarController {
            homeScene.selectedIndex = 1
            let navigationController = UINavigationController(rootViewController: homeScene)
            navigationController.setNavigationBarHidden(true, animated: false)
            defaultSetAsWindowRoot(navigationController)
            let serviceScene = GarageServiceRequestVC.instantiate(fromAppStoryboard: .Garage)
            serviceScene.requestId = requestId
            navigationController.pushViewController(serviceScene, animated: true)
        } else {
            if let vwController = (nav.hasViewController(ofKind: GarageServiceRequestVC.self) as? GarageServiceRequestVC) {
                vwController.requestId = requestId
                nav.popToViewController(vwController, animated: true)
                return
            } else {
                let serviceScene = GarageServiceRequestVC.instantiate(fromAppStoryboard: .Garage)
                serviceScene.requestId = requestId
                nav.pushViewController(serviceScene, animated: true)
            }
        }
    }
    
    // Redirect  to   ONETOONECHATVC
    static func goToOneToOneChatVCThroughNotification(_ requestId: String,_ userId: String,_ userImage:String,_ bidRequestId: String,_ userName: String,_ garageUserId: String) {
        guard let nav: UINavigationController = AppDelegate.shared.window?.rootViewController as? UINavigationController else { return }
        if let homeScene = nav.hasViewController(ofKind: GarageTabBarController.self) as? GarageTabBarController {
            homeScene.selectedIndex = 3
            let navigationController = UINavigationController(rootViewController: homeScene)
            navigationController.setNavigationBarHidden(true, animated: true)
            defaultSetAsWindowRoot(navigationController)
            let chatScene = OneToOneChatVC.instantiate(fromAppStoryboard: .Chat)
            chatScene.firstName = userName
            chatScene.userImage = userImage
            chatScene.isSupportChat = requestId.isEmpty
            chatScene.requestId = requestId
            chatScene.garageUserId = garageUserId
            chatScene.requestDetailId = bidRequestId
            chatScene.bidRequestId = bidRequestId
            chatScene.inboxModel.userId = userId //"5e8483230a60177afa95e0b7"
            chatScene.inboxModel.unreadMessages = 0
            navigationController.pushViewController(chatScene, animated: true)
        } else {
            if let vwController = (nav.hasViewController(ofKind: OneToOneChatVC.self) as? OneToOneChatVC) {
                vwController.firstName = userName
                vwController.isSupportChat = requestId.isEmpty
                vwController.requestId = requestId
                vwController.userImage = userImage
                vwController.garageUserId = garageUserId
                vwController.requestDetailId = bidRequestId
                vwController.bidRequestId = bidRequestId
                vwController.inboxModel.userId = userId //"5e8483230a60177afa95e0b7"
                vwController.inboxModel.unreadMessages = 0
                nav.popToViewController(vwController, animated: true)
                return
            } else {
                let chatScene = OneToOneChatVC.instantiate(fromAppStoryboard: .Chat)
                chatScene.firstName = userName
                chatScene.userImage = userImage
                chatScene.isSupportChat = requestId.isEmpty
                chatScene.requestId = requestId
                chatScene.garageUserId = garageUserId
                chatScene.requestDetailId = bidRequestId
                chatScene.bidRequestId = bidRequestId
                chatScene.inboxModel.userId = userId //"5e8483230a60177afa95e0b7"
                chatScene.inboxModel.unreadMessages = 0
                nav.pushViewController(chatScene, animated: true)
            }
        }
    }
    
    // Redirect  to  User All Offer screen
    static func goToUserAllOffersVCThroughNotification(requestId : String){
        guard let nav: UINavigationController = AppDelegate.shared.window?.rootViewController as? UINavigationController else { return }
        if let homeScene = nav.hasViewController(ofKind: UserTabBarController.self) as? UserTabBarController {
            homeScene.selectedIndex = 1
            let navigationController = UINavigationController(rootViewController: homeScene)
            navigationController.setNavigationBarHidden(true, animated: false)
            defaultSetAsWindowRoot(navigationController)
            let serviceScene = UserAllOffersVC.instantiate(fromAppStoryboard: .Garage)
            serviceScene.requestId = requestId
            navigationController.pushViewController(serviceScene, animated: true)
        } else {
            if let vwController = (nav.hasViewController(ofKind: UserAllOffersVC.self) as? UserAllOffersVC) {
                vwController.requestId = requestId
                nav.popToViewController(vwController, animated: true)
                return
            } else {
                let serviceScene = UserAllOffersVC.instantiate(fromAppStoryboard: .Garage)
                serviceScene.requestId = requestId
                nav.pushViewController(serviceScene, animated: true)
            }
        }
    }
    
    // Redirect  to  User Service Detail screen
    static func goToUserServiceDetailVCThroughNotification(requestId : String){
        guard let nav: UINavigationController = AppDelegate.shared.window?.rootViewController as? UINavigationController else { return }
        if let homeScene = nav.hasViewController(ofKind: UserTabBarController.self) as? UserTabBarController {
            homeScene.selectedIndex = 1
            let navigationController = UINavigationController(rootViewController: homeScene)
            navigationController.setNavigationBarHidden(true, animated: false)
            defaultSetAsWindowRoot(navigationController)
            let serviceScene = UserServiceRequestVC.instantiate(fromAppStoryboard: .Garage)
            serviceScene.requestId = requestId
            navigationController.pushViewController(serviceScene, animated: true)
        } else {
            if let vwController = (nav.hasViewController(ofKind: UserServiceRequestVC.self) as? UserServiceRequestVC) {
                vwController.requestId = requestId
                nav.popToViewController(vwController, animated: true)
                return
            } else {
                let serviceScene = UserServiceRequestVC.instantiate(fromAppStoryboard: .Garage)
                serviceScene.requestId = requestId
                nav.pushViewController(serviceScene, animated: true)
            }
        }
    }
    
    // Redirect  to  User Service Status screen
    static func goToUserServiceStatusVCThroughNotification(requestId : String){
        guard let nav: UINavigationController = AppDelegate.shared.window?.rootViewController as? UINavigationController else { return }
        if let homeScene = nav.hasViewController(ofKind: UserTabBarController.self) as? UserTabBarController {
            homeScene.selectedIndex = 1
            let navigationController = UINavigationController(rootViewController: homeScene)
            navigationController.setNavigationBarHidden(true, animated: false)
            defaultSetAsWindowRoot(navigationController)
            let serviceScene = UserServiceStatusVC.instantiate(fromAppStoryboard: .GarageRequest)
            serviceScene.requestId = requestId
            navigationController.pushViewController(serviceScene, animated: true)
        } else {
            if let vwController = (nav.hasViewController(ofKind: UserServiceStatusVC.self) as? UserServiceStatusVC) {
                vwController.requestId = requestId
                nav.popToViewController(vwController, animated: true)
                return
            } else {
                let serviceScene = UserServiceStatusVC.instantiate(fromAppStoryboard: .GarageRequest)
                serviceScene.requestId = requestId
                nav.pushViewController(serviceScene, animated: true)
            }
        }
    }
    
    // Redirect  to  Garage  Service Completed screen
    static func goToGarageServiceCompletedVCThroughNotification(){
        guard let nav: UINavigationController = AppDelegate.shared.window?.rootViewController as? UINavigationController else { return }
        if let homeScene = nav.hasViewController(ofKind: GarageTabBarController.self) as? GarageTabBarController {
            homeScene.selectedIndex = 4
            let navigationController = UINavigationController(rootViewController: homeScene)
            navigationController.setNavigationBarHidden(true, animated: false)
            defaultSetAsWindowRoot(navigationController)
            let serviceScene = ServiceCompletedVC.instantiate(fromAppStoryboard: .GarageRequest)
            serviceScene.screenType = ServiceCompletedVC.ScreenType.serviceComplete
            navigationController.pushViewController(serviceScene, animated: true)
        } else {
            if let vwController = (nav.hasViewController(ofKind: ServiceCompletedVC.self) as? ServiceCompletedVC) {
                vwController.screenType = ServiceCompletedVC.ScreenType.serviceComplete
                nav.popToViewController(vwController, animated: true)
                return
            } else {
                let serviceScene = ServiceCompletedVC.instantiate(fromAppStoryboard: .GarageRequest)
                serviceScene.screenType = ServiceCompletedVC.ScreenType.serviceComplete
                nav.pushViewController(serviceScene, animated: true)
            }
        }
    }
    
    // Redirect  to  Garage Service Status screen
    static func goToGarageServiceStatusVCThroughNotification(requestId : String){
        guard let nav: UINavigationController = AppDelegate.shared.window?.rootViewController as? UINavigationController else { return }
        if let homeScene = nav.hasViewController(ofKind: UserTabBarController.self) as? GarageTabBarController {
            homeScene.selectedIndex = 1
            let navigationController = UINavigationController(rootViewController: homeScene)
            navigationController.setNavigationBarHidden(true, animated: false)
            defaultSetAsWindowRoot(navigationController)
            let serviceScene = ServiceStatusVC.instantiate(fromAppStoryboard: .GarageRequest)
            serviceScene.requestId = requestId
            navigationController.pushViewController(serviceScene, animated: true)
        } else {
            if let vwController = (nav.hasViewController(ofKind: ServiceStatusVC.self) as? ServiceStatusVC) {
                vwController.requestId = requestId
                nav.popToViewController(vwController, animated: true)
                return
            } else {
                let serviceScene = ServiceStatusVC.instantiate(fromAppStoryboard: .GarageRequest)
                serviceScene.requestId = requestId
                nav.pushViewController(serviceScene, animated: true)
            }
        }
    }
       
    
    static func goToOilBrandsVC(vc: UIViewController){
        let scene = OilBrandsVC.instantiate(fromAppStoryboard: .UserHomeScreen)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToChangePasswordVC(vc: UIViewController){
        let scene = ChangePasswordVC.instantiate(fromAppStoryboard: .PostLogin)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToChangeLanguageVC(vc: UIViewController){
        let scene = ChangeLanguageVC.instantiate(fromAppStoryboard: .PostLogin)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToOneToOneChatVC(_ vc: UIViewController, userId: String,requestDetailId: String = "",requestId: String, name: String, image: String, unreadMsgs: Int,isSupportChat: Bool = false,garageUserId:  String = "") {
        let chatScene = OneToOneChatVC.instantiate(fromAppStoryboard: .Chat)
        chatScene.firstName = name
        chatScene.isSupportChat = isSupportChat
        chatScene.requestId = requestId
        chatScene.garageUserId = garageUserId
        chatScene.requestDetailId = requestDetailId
        chatScene.bidRequestId = requestDetailId
        chatScene.userImage = image
        chatScene.inboxModel.userId = userId //"5e8483230a60177afa95e0b7"
        chatScene.inboxModel.unreadMessages = unreadMsgs
        guard let nvc = vc.navigationController else { return }
        nvc.pushViewController(chatScene, animated: true)
    }
    
    static func goToOilTypeVC(vc: UIViewController){
        let scene = OilTypeVC.instantiate(fromAppStoryboard: .UserHomeScreen)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToOfferFilterVC(vc: UIViewController){
        let scene = OfferFilterVC.instantiate(fromAppStoryboard: .GarageRequest)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToReViewListingVC(vc: UIViewController, garageId: String){
        let scene = ReViewListingVC.instantiate(fromAppStoryboard: .GarageRequest)
        scene.garageId = garageId
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    
    static func goToSROtpPopupVC(vc: UIViewController){
           let scene = SROtpPopupVC.instantiate(fromAppStoryboard: .GarageRequest)
           vc.modalPresentationStyle = .fullScreen
           vc.present(scene, animated: true, completion: nil)
        
    }
    
    static func goToWebVC(vc: UIViewController, screenType : WebViewController.WebViewType,requestId: String = "",pdfUrl: String = "") {
        let scene = WebViewController.instantiate(fromAppStoryboard: .PostLogin)
        scene.webViewType = screenType
        scene.requestId = requestId
        scene.pdfUrl = pdfUrl
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToFacilityVC(vc: UIViewController,data: [FacilityModel], brandAndServiceArr: [String]){
        let scene = FacilityVC.instantiate(fromAppStoryboard: .Garage)
        scene.delegate = vc as? FacilitiesDelegate
        scene.selectedItemArr = data
        vc.modalPresentationStyle = .fullScreen
        vc.present(scene, animated: true)
    }
    
    static func goToBrandsListingVC(vc: UIViewController,listingType : ListingType,brandsData : [TyreBrandModel],countryData: [TyreCountryModel], category: Category){
        let scene = BrandsListingVC.instantiate(fromAppStoryboard: .UserHomeScreen)
        if listingType == .brands {
            scene.viewModel.selectedBrandsArr = brandsData
        }else {
            scene.viewModel.selectedCountryArr = countryData
        }
        scene.delegate = vc as? BrandsListnig
        scene.listingType = listingType
        vc.present(scene, animated: true)
    }
    
    static func presentImageViewerVC(_ vc: UIViewController, image: UIImage?, imageURL: String = "") {
        let imgView = ImageViewerVC.instantiate(fromAppStoryboard: .Garage)
        imgView.mainImage = image
        imgView.mainImageURL = imageURL
        guard let nvc = vc.navigationController else { return }
        nvc.present(imgView, animated: true, completion: nil)
    }
    
    
    static func showAlert(alertTitle: String = "Alert!", alertMessage: String, preferredStyle: UIAlertController.Style = .alert, actionBtnTitle: String = "OK", isHitLogOutApi : Bool = false) {
        if isHitLogOutApi {
            guard let topVC = AppDelegate.shared.topViewController() else {return}
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: preferredStyle)
            alert.addAction(UIAlertAction(title: actionBtnTitle, style: .default, handler: { action in
                WebServices.logout(parameters: [:], success: { (msg) in
                    ToastView.shared.showLongToast(topVC.view, msg: msg)
                    alert.dismiss(animated: true, completion: nil)
                }) { (error) -> (Void) in
                    ToastView.shared.showLongToast(topVC.view, msg: error.localizedDescription)
                }
            }))
            topVC.present(alert, animated: true, completion: nil)
        }else {
            if let topVC = AppDelegate.shared.topViewController() {
                CommonFunctions.showToastWithMessage(alertMessage)
                //                ToastView.shared.showLongToast(topVC.view, msg: alertMessage)
            }
            self.makeLoginVCRoot()
        }
    }
}
