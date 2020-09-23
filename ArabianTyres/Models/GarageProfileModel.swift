//
//  GarageProfileModel.swift
//  ArabianTyres
//
//  Created by Arvind on 15/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SwiftyJSON

struct GarageProfileModel {
    
    
    static var shared = GarageProfileModel()

    var logoUrl                     : String = ""
    var logo                        : UIImage? = nil
    var serviceCenterName           : String = ""
    var latitude                    : Double = 0.0
    var longitude                   : Double = 0.0
    var address                     : String = ""
    var serviceCenterImages         : [ImageModel] = []
    var images                      : [String] = []
    var commercialRegister          : [String] = []
    var vatCertificate              : [String] = []
    var municipalityLicense         : [String] = []
    var ownerId                     : [String] = []
    var bankName                    : String = ""
    var accountNumber               : String = ""
    var confirmAccountNumber        : String = ""
    var serviceCenterDist           : String = ""
    var minInstallationPrice        : Int = 0
    var maxInstallationPrice        : Int = 0
    var services                    : [JSONDictionary] = []
    
    
    func getGarageProfileDict()-> JSONDictionary {
        
        let dict: JSONDictionary = [
            ApiKey.logo : logoUrl,
            ApiKey.name: serviceCenterName,
            ApiKey.latitude : latitude,
            ApiKey.longitude : longitude,
            ApiKey.address : address,
            ApiKey.images : images,
            ApiKey.commercialRegister : commercialRegister,
            ApiKey.vatCertificate : vatCertificate,
            ApiKey.municipalityLicense : municipalityLicense,
            ApiKey.ownerId : ownerId,
            ApiKey.bank : bankName,
            ApiKey.accountNumber : accountNumber
           
        ]

        return dict
    }
    
    func getCompleteProfileDict()-> JSONDictionary {
           
           let dict: JSONDictionary = [
               ApiKey.logo : logoUrl,
               ApiKey.name: serviceCenterName,
               ApiKey.latitude : latitude,
               ApiKey.longitude : longitude,
               ApiKey.address : address,
               ApiKey.images : images,
               ApiKey.bank : bankName,
               ApiKey.accountNumber : accountNumber,
               ApiKey.minInstallationPrice : minInstallationPrice,
               ApiKey.maxInstallationPrice : maxInstallationPrice,
               ApiKey.services : services,
               ApiKey.district: serviceCenterDist
           ]

           return dict
       }
       
    
}

struct GarageProfilePreFillModel {
       var logoUrl                     : String = ""
       var logo                        : UIImage? = nil
       var serviceCenterName           : String = ""
       var latitude                    : Double = 0.0
       var longitude                   : Double = 0.0
       var address                     : String = ""
       var serviceCenterImages         : [ImageModel] = []
       var images                      : [String] = []
       var commercialRegister          : [String] = []
       var vatCertificate              : [String] = []
       var municipalityLicense         : [String] = []
       var ownerId                     : [String] = []
       var bankName                    : String = ""
       var accountNumber               : String = ""
       var confirmAccountNumber        : String = ""
       var serviceCenterDist           : String = ""
       var minInstallationPrice        : Int = 0
       var maxInstallationPrice        : Int = 0
       var services                    : [JSONDictionary] = []
       var requestTime                 : String = ""
    
    init(_ json : JSON = JSON()) {
        self.logoUrl = json[ApiKey.logo].stringValue
        self.bankName = json[ApiKey.bank].stringValue
        self.address = json[ApiKey.address].stringValue
        self.maxInstallationPrice = json[ApiKey.maxInstallationPrice].intValue
        self.minInstallationPrice = json[ApiKey.minInstallationPrice].intValue
        
//        self.commercialRegister = json[ApiKey.commercialRegister].arrayValue.map{(($0 as? String))}
//        self.municipalityLicense = json[ApiKey.municipalityLicense].arrayValue.st
//        self.commercialRegister = json[ApiKey.commercialRegister].arrayValue.map{(ImageModel(withJSON: $0))}
//        self.commercialRegister = json[ApiKey.commercialRegister].arrayValue.map{(ImageModel(withJSON: $0))}

        self.latitude = json[ApiKey.latitude].doubleValue
        self.longitude = json[ApiKey.longitude].doubleValue
        
//        self.accountNumber = json[ApiKey.accountNumber].stringValue
//        self.serviceCenterDist = json[ApiKey.district].stringValue
//        self.serviceCenterImages = json[ApiKey.images]

    }
}
