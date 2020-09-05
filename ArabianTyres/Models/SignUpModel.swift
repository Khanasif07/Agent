//
//  SignUpModel.swift
//  ArabianTyres
//
//  Created by Admin on 04/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON

struct  SignUpModel{
    
    var name: String = ""
    var email : String = ""
    var password: String = ""
    var countryCode: String = ""
    var phoneNo: String = ""
    
    init(){}
    
    func getSignUpModelDict()-> JSONDictionary {
        
        let dict: JSONDictionary = [
            ApiKey.name : name,
            ApiKey.email: email,
            ApiKey.password : password,
            ApiKey.countryCode : countryCode,
            ApiKey.phoneNo : phoneNo]
        return dict
    }
}

