//
//  TyreRequestModel.swift
//  ArabianTyres
//
//  Created by Admin on 21/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

struct TyreRequestModel {
    
    
    static var shared = TyreRequestModel()

    var width                     : String = ""
    var profile                        : String = ""
    var rimSize           : String = ""
    var quantity                    : Int = 0
    var selectedBrands                  : [String] = []
    var selectedCountry                     : [String] = []
    var latitude : String = ""
    var longitude: String = ""
    func getGarageProfileDict()-> JSONDictionary {
        
        let dict: JSONDictionary = [:
//            ApiKey.logo : logoUrl,
//            ApiKey.name: serviceCenterName,
//            ApiKey.latitude : latitude,
//            ApiKey.longitude : longitude,
//            ApiKey.address : address,
//            ApiKey.images : images,
//            ApiKey.commercialRegister : commercialRegister,
//            ApiKey.vatCertificate : vatCertificate,
//            ApiKey.municipalityLicense : municipalityLicense,
//            ApiKey.ownerId : ownerId,
//            ApiKey.bank : bankName,
//            ApiKey.accountNumber : accountNumber
            
        ]

        return dict
    }
}
