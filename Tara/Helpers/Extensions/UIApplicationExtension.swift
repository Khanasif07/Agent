//
//  UIApplicationExtension.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    ///Opens Settings app
    @nonobjc class var openSettingsApp: Void {
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            } else {
                UIApplication.shared.openURL(settingsUrl)
            }
        }
    }
    
    ///Disables the ideal timer of the application
    @nonobjc class var disableApplicationIdleTimer: Void {
        self.shared.isIdleTimerDisabled = true
    }
    
    ///Enables the ideal timer of the application
    @nonobjc class var enableApplicationIdleTimer: Void {
        self.shared.isIdleTimerDisabled = false
    }
    
    ///Can get & set application icon badge number
    @nonobjc class var appIconBadgeNumber: Int {
        get {
            return UIApplication.shared.applicationIconBadgeNumber
        }
        set {
            UIApplication.shared.applicationIconBadgeNumber = newValue
        }
    }
    
    var visibleViewController: UIViewController? {
        guard let rootViewController = UIWindow.key?.rootViewController else {
            return nil
        }
        return getVisibleViewController(rootViewController)
    }
    
    private func getVisibleViewController(_ rootViewController: UIViewController) -> UIViewController? {
        
        if let presentedViewController = rootViewController.presentedViewController {
            return getVisibleViewController(presentedViewController)
        }
        
        if let navigationController = rootViewController as? UINavigationController {
            if let tabBarController = navigationController.visibleViewController as? UITabBarController {
                if let selectedTab = tabBarController.selectedViewController {
                    return getVisibleViewController(selectedTab)
                }
                return tabBarController.selectedViewController
            }
            return navigationController.visibleViewController
        }
        
        if let tabBarController = rootViewController as? UITabBarController {
            if let selectedTab = tabBarController.selectedViewController {
                return getVisibleViewController(selectedTab)
            }
            return tabBarController.selectedViewController
        }
        
        return rootViewController
    }
}
