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
    public  var unreadNotificationCount = 0
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
        AWSS3Manager.shared.setupAmazonS3(withPoolID: AppConstants.awss3PoolId)
        self.getGoogleInfoPlist()
        Messaging.messaging().delegate = self
        GMSServices.provideAPIKey(AppConstants.googlePlaceApiKey)
        GMSPlacesClient.provideAPIKey(AppConstants.googlePlaceApiKey)
        GoogleLoginController.shared.configure(withClientId: AppConstants.googleId)
        guard let unreadCount = AppUserDefaults.value(forKey: .unreadCount).int else {
            AppUserDefaults.save(value: 0, forKey: .unreadCount)
            return true
        }
        AppDelegate.shared.unreadNotificationCount = unreadCount
        AppRouter.checkAppInitializationFlow()
        
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print(fcmToken ?? "")
        AppUserDefaults.save(value: fcmToken ?? "" , forKey: .fcmToken) // Used for saving device token
        DeviceDetail.deviceToken = fcmToken ?? ""
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
    
    func registerPushNotification() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            // 1. Check if permission granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}


extension AppDelegate {
    // To fetch different google infoplist according to different servers
    func getGoogleInfoPlist() {
        var filePath = ""
        #if ENV_DEV
        filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        #elseif ENV_QA
        filePath = Bundle.main.path(forResource: "GoogleService-Info-QA", ofType: "plist")!
        #elseif ENV_PROD
        filePath = Bundle.main.path(forResource: "GoogleService-Info-Prod", ofType: "plist")!
        #else
        filePath = Bundle.main.path(forResource: "GoogleService-Info-Prod", ofType: "plist")!
        #endif
        if let options = FirebaseOptions(contentsOfFile: filePath) {
            FirebaseApp.configure(options: options)
        } else {
            FirebaseApp.configure()
        }
    }
    
    func getGoogleClientID() {
        let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        if let options = FirebaseOptions(contentsOfFile: filePath) {
            GoogleLoginController.shared.configure(withClientId: options.clientID ?? "")
            GIDSignIn.sharedInstance().clientID = options.clientID
        }
    }
}

//MARK:- Push Notification
//=========================
extension AppDelegate{
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        AppUserDefaults.save(value: deviceTokenString, forKey: .token)
        print("APNs device token: \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        guard let userInfo = (notification.request.content.userInfo as? [String: Any]) else { return }
        guard let value = userInfo[ApiKey.gcm_notification_type] as? String else { return }
        
        if value == PushNotificationType.other.rawValue {
            AppDelegate.shared.unreadNotificationCount += 1
            AppUserDefaults.save(value: AppDelegate.shared.unreadNotificationCount, forKey: .unreadCount)
//            NotificationCenter.default.post(name: .didReceiveNotification, object: nil)
            completionHandler([.alert, .badge, .sound])
        }
        
        if value == PushNotificationType.other.rawValue {
            completionHandler([.alert, .badge, .sound])
        }
        
        if value == PushNotificationType.other.rawValue || value == PushNotificationType.other.rawValue {
            if let nav = AppDelegate.shared.window?.rootViewController as? UINavigationController {
                if let topVC = nav.viewControllers.last?.presentedViewController as? UserChatVC {
//                    let _ = userInfo[ApiKey.notificationViewId]
//                    let _ = userInfo[ApiKey.notificationEventId]
//                    let postId = userInfo[ApiKey.notificationPostId] as! String
//                    topVC.viewModel.getCommentListing(params: [ApiKey.postId: postId,ApiKey.page: 1 ,ApiKey.limit: 10])
                    completionHandler([])
                    return
                }
            }
            completionHandler([.alert, .badge, .sound])
        }
        
        guard let roomId = userInfo[ApiKey.notificationId] as? String, let roomType = userInfo[ApiKey.gcm_notification_type] as? String else {
            return }
        
        if let nav = AppDelegate.shared.window?.rootViewController as? UINavigationController {
            if let topVC = nav.viewControllers.last as? OneToOneChatVC {
                if (roomType == ApiKey.singleCaps || roomType == ApiKey.single), roomId == topVC.roomId {
                    completionHandler([])
                } else {
                    completionHandler([.alert, .badge, .sound])
                }
            } else if let topVC = nav.viewControllers.last as? UserChatVC {
                if roomType == ApiKey.group, roomId == topVC.currentUserId {
                    completionHandler([])
                } else {
                    completionHandler([.alert, .badge, .sound])
                }
            }else {
                completionHandler([.alert, .badge, .sound])
            }
        } else {
            completionHandler([.alert, .badge, .sound])
        }
    }
    
    func application(_ application: UIApplication,didReceiveRemoteNotification userInfo: [AnyHashable: Any],fetchCompletionHandler completionHandler:@escaping (UIBackgroundFetchResult) -> Void) {
        
        let state : UIApplication.State = application.applicationState
        if (state == .inactive || state == .background) {
            print("background")
            printDebug("Did receive remote notification \(userInfo)")
        } else {
            print("foreground")
            printDebug("Did receive remote notification \(userInfo)")
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let userInfo = response.notification.request.content.userInfo as? [String: Any] else { return }
        PushNotificationRedirection.redirectionOnNotification(userInfo)
        print("tap on on forground app", userInfo)
        completionHandler()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        FirestoreController.updateUserOnlineStatus(isOnline: false)
    }
    
}
