//
//  AppGlobals.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import Foundation
import UIKit

/// Print Debug
func printDebug<T>(_ obj : T) {
    #if DEBUG
    print(obj)
    #endif
}

/// Is Simulator or Device
var isSimulatorDevice: Bool {
    
    var isSimulator = false
    #if arch(i386) || arch(x86_64)
    //simulator
    isSimulator = true
    #endif
    return isSimulator
}

/// Is this iPhone X or not
func isDeviceIsIphoneX() -> Bool {
    if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 1136: return false
        case 1334: return false
        case 2208: return false
        case 2436: return true
        default: return false
        }
    }
    return false
}

var isUserLoggedin: Bool {
    let token = AppUserDefaults.value(forKey: .accesstoken).stringValue
    if !token.isEmpty {
        return true
    } else {
        return false
    }
}

var isCurrentUserType : UserType {
    let user = AppUserDefaults.value(forKey: .currentUserType).stringValue
    switch user{
    case "1":
        return .user
    case "2":
        return .garage
    default:
        return .guest
    }
}


var categoryType : Category = .battery

var fromGarage : GarageProfile = .normal

var isPhoneNoVerified : Bool {
    return AppUserDefaults.value(forKey: .phoneNoVerified).boolValue
}

// for Language
var selectedLanguage =  AppUserDefaults.value(forKey: .language).stringValue

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

