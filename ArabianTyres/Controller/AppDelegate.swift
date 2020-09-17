//
//  AppDelegate.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import GooglePlaces
import GoogleMaps
import FirebaseMessaging
import IQKeyboardManagerSwift
import UserNotifications
import AWSS3

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate , MessagingDelegate , UNUserNotificationCenterDelegate{
    
    static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    public var window: UIWindow?
    var currentLocation : CLLocation?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(2)
        self.setUpKeyboardSetup()
        self.setUpTextField()
        GMSServices.provideAPIKey(AppConstants.googlePlaceApiKey)
        GMSPlacesClient.provideAPIKey(AppConstants.googlePlaceApiKey)
        AWSS3Manager.shared.setupAmazonS3(withPoolID: AppConstants.awss3PoolId)
        GoogleLoginController.shared.configure(withClientId: AppConstants.googleId)
        AppRouter.checkAppInitializationFlow()
        
        return true
    }
    
    public func getWindow()-> UIWindow{
        if let window = AppDelegate.shared.window {
            return window
        }
        else {
            AppDelegate.shared.window = UIWindow()
            return AppDelegate.shared.window!
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        if fcmToken != AppUserDefaults.value(forKey: .fcmToken).stringValue {
            print(fcmToken)
        }
        AppUserDefaults.save(value: fcmToken , forKey: .fcmToken) // Used for saving device token
        printDebug(AppUserDefaults.save(value: fcmToken , forKey: .fcmToken))
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
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        InstanceID.instanceID().instanceID(handler: { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
        })
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
          LocationController.sharedLocationManager.fetchCurrentLocation { (location) in
                  LocationController.sharedLocationManager.currentLocation = location
              }
    }
    
    private func setUpTextField(){
        UITextField.appearance().tintColor = AppColors.fontPrimaryColor
        UISearchBar.appearance().tintColor = AppColors.fontPrimaryColor
        UIToolbar.appearance().tintColor = AppColors.fontPrimaryColor
        UIButton.appearance().tintColor = AppColors.fontPrimaryColor
        UIBarButtonItem.appearance().tintColor = AppColors.fontPrimaryColor
        
        UITabBar.appearance().isTranslucent = false
//        UITabBar.appearance().barTintColor = AppColors.primaryBlueColor
        UITabBar.appearance().tintColor = UIColor.white

    }
    
    func setUpAppearance(){
        UITextField.appearance().tintColor = AppColors.fontPrimaryColor
        UISearchBar.appearance().tintColor = AppColors.fontPrimaryColor
        UIToolbar.appearance().tintColor = AppColors.fontPrimaryColor
        UIButton.appearance().tintColor = AppColors.fontPrimaryColor
        UIBarButtonItem.appearance().tintColor = AppColors.fontPrimaryColor
    }
    
    func setUpKeyboard(){
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    func topViewController(_ base: UIViewController? = nil
       ) -> UIViewController? {
        var baseScene = base
        baseScene = baseScene == nil ? window?.rootViewController : baseScene
        if let nav = baseScene as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = baseScene as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = baseScene?.presentedViewController {
            return topViewController(presented)
        }
        return baseScene
    }
}

