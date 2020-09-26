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
    var quantity                    : String = ""
    var tyreBrandsListing                  : [String] = []
    var countriesListing                   : [String] = []
    var tyreBrands                  : [String] = []
    var countries                     : [String] = []
    var latitude : String = ""
    var longitude: String = ""
    var makeId: String  = ""
    var makeName: String  = ""
    var modelName: String  = ""
    var year: String  = ""
    
    func getTyreRequestDict()-> JSONDictionary {
        let dict: JSONDictionary = [
            ApiKey.width : width,
            ApiKey.profile: profile,
            ApiKey.rimSize : rimSize,
            ApiKey.quantity: quantity,
            ApiKey.brands : tyreBrands,
            ApiKey.countries : countries,ApiKey.latitude:latitude,ApiKey.longitude: longitude]

        return dict
    }
}
