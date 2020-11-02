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
    
    public var window: UIWindow?
    static var shared: AppDelegate {
           if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
               return appDelegate
           }
           fatalError("invalid access of AppDelegate")
       }
    var currentLocation : CLLocation?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(2)
        self.setUpKeyboardSetup()
        self.setUpTextField()
        self.registerPushNotification()
        GMSServices.provideAPIKey(AppConstants.googlePlaceApiKey)
        GMSPlacesClient.provideAPIKey(AppConstants.googlePlaceApiKey)
        AWSS3Manager.shared.setupAmazonS3(withPoolID: AppConstants.awss3PoolId)
        GoogleLoginController.shared.configure(withClientId: AppConstants.googleId)
        getGoogleInfoPlist()
        AppRouter.checkAppInitializationFlow()
        
        return true
    }
   
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        if fcmToken != AppUserDefaults.value(forKey: .fcmToken).stringValue {
            print(fcmToken)
        }
        AppUserDefaults.save(value: fcmToken , forKey: .fcmToken) // Used for saving device token
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
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        AppUserDefaults.save(value: deviceTokenString, forKey: .token)
        print("APNs device token: \(deviceTokenString)")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if isUserLoggedin{
            if !(SocketIOManager.isSocketConnected) {
                SocketIOManager.shared.establishConnection()
            }
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
//        UIBarButtonItem.appearance().tintColor = AppColors.fontPrimaryColor
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
    
    func registerPushNotification(){
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        }
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
    }
}


extension AppDelegate {
    // To fetch different google infoplist according to different servers
    func getGoogleInfoPlist() {
//        var filePath = ""
//        #if ENV_DEV
//        filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
//        #elseif ENV_QA
//        filePath = Bundle.main.path(forResource: "GoogleService-Info-QA", ofType: "plist")!
//        #elseif ENV_PROD
//        filePath = Bundle.main.path(forResource: "GoogleService-Info-Prod", ofType: "plist")!
//        #else
//        filePath = Bundle.main.path(forResource: "GoogleService-Info-Stg", ofType: "plist")!
//        #endif
        
//        if let options = FirebaseOptions(contentsOfFile: filePath) {
//            FirebaseApp.configure(options: options)
//        } else {
            FirebaseApp.configure()
//        }
    }
    
    func getGoogleClientID() {
        let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        if let options = FirebaseOptions(contentsOfFile: filePath) {
            GoogleLoginController.shared.configure(withClientId: options.clientID ?? "")
            GIDSignIn.sharedInstance().clientID = options.clientID
        }
    }
}
