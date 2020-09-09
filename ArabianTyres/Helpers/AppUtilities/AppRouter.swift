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
        navigationController.setNavigationBarHidden(true, animated: false)
        AppDelegate.shared.window?.rootViewController = navigationController
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    // MARK: - Show Landing Screen
    //===========================
    static func checkAppInitializationFlow() {
        if isUserLoggedin {
            switch isCurrentUserType {
            case .user:
                AppRouter.goToUserHome()
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
        let homeScene = UserTabBarController.instantiate(fromAppStoryboard: .Home)
        setAsWindowRoot(homeScene)
    }
    
    static func goToSignUpVC(vc: UIViewController){
        let scene = SignUpVC.instantiate(fromAppStoryboard: .Prelogin)
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToResetPasswordVC(vc: UIViewController,resetToken: String){
        let scene = ResetPasswordVC.instantiate(fromAppStoryboard: .Prelogin)
        scene.viewModel.resetToken = resetToken
        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToSignWithPhoneVC(vc: UIViewController,isComefromForgotpass: Bool = false ){
           let scene = LoginWithPhoneVC.instantiate(fromAppStoryboard: .Prelogin)
           scene.viewModel.isComefromForgotpass = isComefromForgotpass
           vc.navigationController?.pushViewController(scene, animated: true)
       }
    
    static func makeChooseLanguageVCRoot(){
        let scene = ChooseLanguageVC.instantiate(fromAppStoryboard: .Prelogin)
        setAsWindowRoot(scene)
    }
    
    static func showSuccessPopUp(vc: UIViewController & SuccessPopupVCDelegate,title: String,desc: String){
        let scene = SuccessPopupVC.instantiate(fromAppStoryboard: .Prelogin)
        scene.delegate = vc
        scene.textSetUp(title: title, desc: desc)
        vc.present(scene, animated: true, completion: nil)
    }
    
    static func showCountryVC(vc: UIViewController & CountryDelegate){
        let scene = CountryVC.instantiate(fromAppStoryboard: .Prelogin)
        scene.countryDelegate = vc
        scene.modalPresentationStyle = .fullScreen
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
}
