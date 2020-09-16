//
//  GarageProfileModel.swift
//  ArabianTyres
//
//  Created by Arvind on 15/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct GarageProfileModel {
    
    
    static var shared = GarageProfileModel()

    var logo                        : String = ""
    var serviceCenterName           : String = ""
    var latitude                    : Double = 0.0
    var longitude                   : Double = 0.0
    var address                     : String = ""
    var images                      : [String] = []
    var commercialRegister          : [String] = []
    var vatCertificate              : [String] = []
    var municipalityLicense         : [String] = []
    var ownerId                     : [String] = []
    var bankName                    : String = ""
    var accountNumber               : String = ""

    func getGarageProfileDict()-> JSONDictionary {
        
        let dict: JSONDictionary = [
            ApiKey.logo : logo,
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
}
