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
  
    case byServiceType([String],Bool)
    case byStatus([String],Bool)
    case date(Date?,Date?,Bool)
    case bidReceived(String,Bool)
    case distance(String,String,Bool)
    case allRequestServiceType([String],Bool)
    case allRequestByStatus([String],Bool)

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
        case .allRequestServiceType(_, _):
            return LocalizedString.byServiceType.localized
        case .allRequestByStatus(_, _):
            return LocalizedString.byStatus.localized
            
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
        case .allRequestServiceType:
            return [LocalizedString.tyreService.localized,
                    LocalizedString.oilSevice.localized,
                    LocalizedString.batteryService.localized]
            
        case .allRequestByStatus:
            return [LocalizedString.bidFinalized.localized,
                    LocalizedString.openForBid.localized,
                    LocalizedString.bidPlaced.localized,
                    LocalizedString.bidRejected.localized]
        case .bidReceived:
            return [LocalizedString.lowToHigh.localized,
                    LocalizedString.highToLow.localized,
                    LocalizedString.ratingHighToLow.localized]
        default:
            return [""]
            
        }
    }
    
    var isSelected : FilterScreen {
        switch self {
            
        case .byServiceType(let arr,let hide):
            return .byServiceType(arr, !hide)
       
        case .byStatus(let arr,let hide):
            return .byStatus(arr, !hide)
        
        case .date(let date1, let date2, let hide):
            return .date(date1, date2, !hide)
        
        case .bidReceived(let txt,let hide):
            return .bidReceived(txt, !hide)
        
        case .distance(let minValue,let maxValue,let hide):
            return .distance(minValue,maxValue, !hide)
        
        case .allRequestServiceType(let arr,let hide):
            return .allRequestServiceType(arr, !hide)
        
        case .allRequestByStatus(let arr,let hide):
            return .allRequestByStatus(arr, !hide)
            
        }
    }
    
    var isHide : Bool {
        switch self {
        
        case .byServiceType(_ ,let hide), .byStatus(_ ,let hide), .date(_ ,_ ,let hide), .bidReceived(_ ,let hide),.distance(_,_,let hide), .allRequestServiceType(_ ,let hide), .allRequestByStatus(_ ,let hide) :
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
           case .allRequestServiceType:
            return ["Tyres",
                    "Oil",
                    "Battery"]
           case .allRequestByStatus:
            return ["finalised",
                    "open",
                    "placed",
                    "rejected"]
           case .bidReceived:
            return ["1",
            "-1",
            "2"]//dummy data for rating high to low
            
           default:
            return [""]
        }
    }
}
