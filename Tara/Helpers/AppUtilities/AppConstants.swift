//
//  AppConstants.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

enum AppConstants {
    
    static var appName              = "TARA"
    static var format               = "SELF MATCHES %@"
    static let emailRegex           = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    static var mobileRegex          = "^[0-9]{7,15}$"
    static var passwordRegex        = "^[a-zA-Z0-9!@#$%&*]{6,16}"
    static var defaultDate          = "0000-00-00"
    static var emptyString          = ""
    static var whiteSpace
        = " "
    static let facebookAppId = "267648971573037"// Prod; //"331106654612712"//testing
    static let AppPassword = "Tara@123"
    static let googleClientId = "54007076081-naglk75b8d7gcvgsn4orvbl2t8boekoe.apps.googleusercontent.com" //Prod; //"945865667688-17hgjjn4tgqikhmcq7ufigggcqta2t75.apps.googleusercontent.com"//Testing
    static var awss3PoolId          =  "us-east-2:d52903e7-5429-40a6-8bf0-8defffee8ca3" //Prod; //b1f250f2-66a7-4d07-96e9-01817149a439"//Testing
    static var googlePlaceApiKey = "AIzaSyBCoD6Kx9JgRbePKiVYDPzaCCMwJBTaMmk" //Prod; //"AIzaSyAmeRcKb4_NVo6ROBq9dwcqJfTydaGitdY"//Testing
    static var adminId = ""
}
