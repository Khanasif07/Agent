//
//  UserModel.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON
struct UserModel{
    
    static var main = UserModel(AppUserDefaults.value(forKey: .fullUserProfile)) {
        didSet {
            main.saveToUserDefaults()
        }
    }
    
    var id : String
    var accessToken : String
    var countryCode : String
    var createdAt : String
    var email : String
    var emailVerified : Int
    var image : String
    var isDelete : Int
    var language : String
    var name : String
    var nickName : String
    var otp : String
    var otpExpiry : String
    var password : String
    var phoneNo : String
    var phoneVerified : Int
    var status : String
    var updatedAt : String
    var isStudent : Bool
    var isTeacher : Bool
    var currentRole : String
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json : JSON = JSON()){
        self.id = json[ApiKey._id].stringValue
        self.accessToken = json[ApiKey.authToken].stringValue
        self.countryCode = json[ApiKey.countryCode].stringValue
        self.createdAt = json[ApiKey.createdAt].stringValue
        self.email = json[ApiKey.email].stringValue
        self.emailVerified = json[ApiKey.emailVerified].intValue
        self.image = json[ApiKey.image].stringValue
        self.isDelete = json[ApiKey.isDelete].intValue
        self.language = json[ApiKey.language].stringValue
        self.name = json[ApiKey.name].stringValue
        self.nickName = json[ApiKey.nickName].stringValue
        self.otp = json[ApiKey.otp].stringValue
        self.otpExpiry = json[ApiKey.otpExpiry].stringValue
        self.password = json[ApiKey.password].stringValue
        self.phoneNo = json[ApiKey.phoneNo].stringValue
        self.phoneVerified = json[ApiKey.phoneVerified].intValue
        self.status = json[ApiKey.status].stringValue
        self.updatedAt = json[ApiKey.updatedAt].stringValue
        self.isTeacher = json[ApiKey.isTeacher].boolValue
        self.isStudent = json[ApiKey.isStudent].boolValue
        self.currentRole = json[ApiKey.currentRole].stringValue
    }
    
    func saveToUserDefaults() {
        
        let dict: JSONDictionary = [
            ApiKey._id : id,
            ApiKey.authToken: accessToken,
            ApiKey.countryCode : countryCode,
            ApiKey.createdAt : createdAt,
            ApiKey.email : email,
            ApiKey.emailVerified : emailVerified,
            ApiKey.image : image,
            ApiKey.isDelete : isDelete,
            ApiKey.language : language,
            ApiKey.name : name,
            ApiKey.nickName : nickName,
            ApiKey.otp : otp,
            ApiKey.otpExpiry : otpExpiry,
            ApiKey.password : password,
            ApiKey.phoneNo : phoneNo,
            ApiKey.phoneVerified : phoneVerified,
            ApiKey.status : status,
            ApiKey.updatedAt : updatedAt,
            ApiKey.currentRole : currentRole,
            
        ]
        AppUserDefaults.save(value: dict, forKey: .fullUserProfile)
    }
}
