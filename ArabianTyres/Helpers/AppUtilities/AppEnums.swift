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

enum Category : String,Codable{
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


enum FilterScreen {
  
    case byServiceType(String,Bool)
    case byStatus(String,Bool)
    case date(Date,Date,Bool)
    case bidReceived(String,Bool)
    case distance(String,Bool)
    
    var text: String {
        switch self {
            
        case .byServiceType:
            return LocalizedString.byServiceType.localized
        case .byStatus:
            return LocalizedString.byStatus.localized
        case .date:
            return LocalizedString.byDate.localized
        case .bidReceived:
            return LocalizedString.bidReceived.localized
        case .distance:
            return LocalizedString.distance.localized
        }
    }
    
    var fliterTypeArr : [String] {
        switch self {
         
        case .byServiceType:
            return [LocalizedString.tyreService.localized,
                    LocalizedString.oilSevice.localized,
                    LocalizedString.batteryService.localized]
            
        case .byStatus:
            return [LocalizedString.offerAccepted.localized,
                    LocalizedString.offerReceived.localized,
                    LocalizedString.noOffers.localized]
    
        default:
            return [""]
        
        }
    }
    
    var isSelected : FilterScreen {
        switch self {
        
        case .byServiceType(let str,let hide):
            return .byServiceType(str, !hide)
        case .byStatus(let str,let hide):
            return .byStatus(str, !hide)
        case .date(let date1, let date2, let hide):
            return .date(date1, date2, !hide)
        case .bidReceived(let str,let hide):
            return .bidReceived(str, !hide)
        case .distance(let str,let hide):
            return .distance(str, !hide)
        
        }
    }
    
    var isHide : Bool {
        switch self {
        
        case .byServiceType(_ ,let hide), .byStatus(_ ,let hide), .date(_ ,_ ,let hide), .bidReceived(_ ,let hide),.distance(_ ,let hide):
            return hide

        }
    }
    
     var apiValue : [String] {
           switch self {
            
           case .byServiceType:
               return ["Tyres",
                       "Oil",
                       "Battery"]
               
           case .byStatus:
               return ["accepted",
                       "received",
                       "noOffer"]
       
           default:
               return [""]
           
        }
    }
}
