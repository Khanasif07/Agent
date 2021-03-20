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

var firestoreServerUrl: String {
    #if ENV_DEV
    return "AAAAvMebQI4:APA91bHonAa5qUlD1Ogpqe2-umkToUqKRU8dQuaFHdviOItVHWEuz4kCGfyRnCGpWl_Wb_ghE8L5kitQ0u_geaG5HGr7ip3mB7L7NVsGSyZZdyuJHoV_mBvZtN1Q0Bim7Zu_azNj0Emq"
    return "AAAAAWkz5pQ:APA91bEd7Dtty8RMJI9ieIvIWGGqIGC4CD4xJ_vxQRKMdjdf4f0jHRmbFac9Z_PeVxgw6zr-VSMl2TZ2YbC18AHxmtligcnRDSHh_iX6B0j6IyDDlXCveW5BwZeq9pW2rUQnFqAcMbmy"
    #elseif ENV_STAG
    return "AAAAvMebQI4:APA91bHonAa5qUlD1Ogpqe2-umkToUqKRU8dQuaFHdviOItVHWEuz4kCGfyRnCGpWl_Wb_ghE8L5kitQ0u_geaG5HGr7ip3mB7L7NVsGSyZZdyuJHoV_mBvZtN1Q0Bim7Zu_azNj0Emq"
    #elseif ENV_QA
    return "AAAAwvZ9zW0:APA91bENRk9IgDvEdllqlrycdtbsUDbyqEDVqepD-YSqn9UdrH34SM0ZFyvMVH7fqbcd8C4tL3aBOBzt_YFmvdmBdA4WPiajpUxi0RymP7z7l7BUiKlMsfhLTbDg316aqndpizczmf3D"
    #elseif ENV_PROD
    return "AAAAvMebQI4:APA91bHonAa5qUlD1Ogpqe2-umkToUqKRU8dQuaFHdviOItVHWEuz4kCGfyRnCGpWl_Wb_ghE8L5kitQ0u_geaG5HGr7ip3mB7L7NVsGSyZZdyuJHoV_mBvZtN1Q0Bim7Zu_azNj0Emq"
    #else
    return ""
    #endif
}

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

