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
    
    // MARK: - Show Landing Screen
    //===========================
    static func checkAppInitializationFlow() {
//        goToTestingVC()
        if isUserLoggedin {
            if !isPhoneNoVerified{
                AppUserDefaults.removeValue(forKey: .accesstoken)
                UserModel.main = UserModel()
                AppRouter.makeLoginVCRoot()
                return
            }
            switch isCurrentUserType {
            case .user:
                AppRouter.goToUserHome()
            case .garage:
                AppRouter.goToGarageHome()
            default:
                let lang = AppUserDefaults.value(forKey: .currentLanguage).stringValue
                AppUserDefaults.removeAllValues()
                AppUserDefaults.save(value: lang, forKey: .currentLanguage)
                AppUserDefaults.save(value: true, forKey: .isLanguageSelect)
            }
        } else {
            self.makeChooseLanguageVCRoot()
        }
    }
    
    static func goToTestingVC(){
        let scene = GarageProfileStep2VC.instantiate(fromAppStoryboard: .Garage)
        setAsWindowRoot(scene)
    }
    
    static func goToProfileSettingVC(vc: UIViewController){
        let scene = ProfileSettingVC.instantiate(fromAppStoryboard: .PostLogin)
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
    
    static func goToOtpVerificationVC(vc: UIViewController,phoneNo: String, countryCode: String,isComeForVerifyPassword: Bool = false){
        let scene = OtpVerificationVC.instantiate(fromAppStoryboard: .Prelogin)
        scene.viewModel.isComeForVerifyPassword = isComeForVerifyPassword
        scene.viewModel.countryCode = countryCode
        scene.viewModel.phoneNo = phoneNo
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToDovelopmentVC(vc: UIViewController){
        let scene = UnderDevelopmentVC.instantiate(fromAppStoryboard: .Prelogin)
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
    
    static func presentBottomSheetVC(vc: UIViewController){
        let scene = BottomSheetVC.instantiate(fromAppStoryboard: .PostLogin)
        vc.modalPresentationStyle = .fullScreen
        vc.present(scene, animated: true, completion: nil)
        
    }
    
    
    static func goToURTyreStep1VC(vc: UIViewController){
        let scene = URTyreStep1VC.instantiate(fromAppStoryboard: .UserRequest)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    
    static func goToOilBrandsVC(vc: UIViewController){
        let scene = OilBrandsVC.instantiate(fromAppStoryboard: .UserHomeScreen)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToOilTypeVC(vc: UIViewController){
        let scene = OilTypeVC.instantiate(fromAppStoryboard: .UserHomeScreen)
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
