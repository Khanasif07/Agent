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
        AppDelegate.shared.window?.becomeKey()
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    // MARK: - Show Landing Screen
    //===========================
    static func checkAppInitializationFlow() {
        if isUserLoggedin {
            switch isCurrentUserType {
            case .user:
                AppRouter.goToUserHome()
            case .garageOwner:
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
        let homeScene = ChooseLanguageVC.instantiate(fromAppStoryboard: .Prelogin)
        setAsWindowRoot(homeScene)
    }
    
    static func goToTutorialVC(vc: UIViewController){
//        let scene = TutorialVC.instantiate(fromAppStoryboard: .Prelogin)
//        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func makeChooseRoleVCRoot(){
//        let scene = ChooseLanguageVC.instantiate(fromAppStoryboard: .Prelogin)
//        setAsWindowRoot(scene)
    }
    
    static func makeChooseLanguageVCRoot(){
        let scene = ChooseLanguageVC.instantiate(fromAppStoryboard: .Prelogin)
        setAsWindowRoot(scene)
    }
    
    static func goToChooseRoleVC(vc: UIViewController, guestCompletion: (()->())? = nil){
//        let scene = ChooseRoleVC.instantiate(fromAppStoryboard: .Prelogin)
//        scene.guestCompletion = guestCompletion
//        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToDovelopmentVC(vc: UIViewController){
//        let scene = HomeVC.instantiate(fromAppStoryboard: .Prelogin)
//        vc.navigationController?.pushViewController(scene, animated: true)
    }
    
    static func goToUserHome() {
//        let homeScene = HomeTabBarController.instantiate(fromAppStoryboard: .Home)
//        setAsWindowRoot(homeScene)
    }
    
    static func goToGarageHome(){
//        let homeScene = TeacherHomeTabBar.instantiate(fromAppStoryboard: .TeacherHome)
//        setAsWindowRoot(homeScene)
    }
    
   
}
