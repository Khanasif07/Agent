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
    case guest
    case garage
}

enum PushNotificationType : String {
    case checkin, checkout, other
}

enum SelectedLangauage: String{
    case english = "English"
    case esponal = "Español"
}

enum ListingType {
    case brands
    case countries
}

enum Category : String{
    case oil = "Oil"
    case tyres = "Tyres"
    case battery = "Battery"
}

enum CellType : CaseIterable{
  
    case created
    case accepted
    case payAmount
    case none
    case serviceDetail
    case userDetail
   
    var text: String {
        switch self {
            
        case .created:
            return LocalizedString.requestCreatedBy.localized
        case .accepted:
            return LocalizedString.requestAcceptedOn.localized
        case .payAmount:
            return LocalizedString.paybleAmount.localized
        case .serviceDetail:
            return LocalizedString.serviceDetails.localized
        case .userDetail:
            return LocalizedString.userDetails.localized
        default:
            return ""
        }
    }
    
    var image: UIImage? {
        switch self {
            
        case .created:
            return #imageLiteral(resourceName: "profileSelected")
        case .accepted:
            return  #imageLiteral(resourceName: "subtract")
        case .payAmount:
            return  #imageLiteral(resourceName: "icAtm")
        default :
            return nil
        }
    }
}
