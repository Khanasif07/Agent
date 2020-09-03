//
//  AppDelegate.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AWSS3

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    var window: UIWindow?
    var blockView = UIView()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(2)
        self.setUpKeyboardSetup()
        self.setUpTextField()
        AWSS3Manager.shared.setupAmazonS3(withPoolID: AppConstants.awss3PoolId)
        AppRouter.checkAppInitializationFlow()
        return true
    }
    
    // Setup IQKeyboard Manager (Third party for handling keyboard in app)
    private func setUpKeyboardSetup() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    
    private func setUpTextField(){
        UITextField.appearance().tintColor = AppColors.paleRed
        UISearchBar.appearance().tintColor = AppColors.paleRed
        UIToolbar.appearance().tintColor = AppColors.paleRed
        UIButton.appearance().tintColor = AppColors.paleRed
        UIBarButtonItem.appearance().tintColor = AppColors.paleRed
    }
    
    func setUpAppearance(){
        UITextField.appearance().tintColor = AppColors.paleRed
        UISearchBar.appearance().tintColor = AppColors.paleRed
        UIToolbar.appearance().tintColor = AppColors.paleRed
        UIButton.appearance().tintColor = AppColors.paleRed
        UIBarButtonItem.appearance().tintColor = AppColors.paleRed
    }
    
    func setUpKeyboard(){
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
}

