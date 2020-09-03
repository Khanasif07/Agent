//
//  AppConstants.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

enum AppConstants {
    static var appName              = "ArabianTyre"
    static var format               = "SELF MATCHES %@"
    static let emailRegex           = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    static var mobileRegex          = "^[0-9]{7,15}$"
    static var passwordRegex        = "^[a-zA-Z0-9!@#$%&*]{6,16}"
    static var defaultDate          = "0000-00-00"
    static var emptyString          = ""
    static var whiteSpace           = " "
    static let facebookAppId = "1353690468354698"//dev
    
    static let googleId = "1024099896615-uogtb9tpti7526hvkcmilspkivmchvo7.apps.googleusercontent.com"//testing
    
    static var awss3PoolId          =  "us-east-1:b1f250f2-66a7-4d07-96e9-01817149a439"
    

}
