//
//  AppEnums.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit


enum Signup {
    case signUp
    case socialSignup
}

enum UserType {
    case user
    case garageOwner
    case none
}

enum PushNotificationType : String {
    case checkin, checkout, other
}

enum SelectedLangauage: String{
    case english = "English"
    case esponal = "Español"
}
