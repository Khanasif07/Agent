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
    var emailVerified : Bool
    var image : String
    var isDelete : Bool
    var name : String
    var otp : String
    var otpExpiry : String
    var password : String
    var phoneNo : String
    var phoneVerified : Bool
    var phoneNoAdded: Bool
    var isgarageProfileComplete : Bool
    var canChangePassword : Bool
    var status : String
    var updatedAt : String
    var userType : String
    var emailVerifyToken: String
    var garageName: String
    var garageAddress : String
    var commission : Double
    var logoUrl: String
//    var garageModel = GarageProfilePreFillModel()
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json : JSON = JSON()){
        self.id = json[ApiKey._id].stringValue
        self.accessToken = json[ApiKey.authToken].stringValue
        self.countryCode = json[ApiKey.countryCode].stringValue
        self.createdAt = json[ApiKey.createdAt].stringValue
        self.email = json[ApiKey.email].stringValue
        self.emailVerified = json[ApiKey.emailVerified].boolValue
        self.image = json[ApiKey.image].stringValue
        self.isDelete = json[ApiKey.isDelete].boolValue
        self.name = json[ApiKey.name].stringValue
        self.otp = json[ApiKey.otp].stringValue
        self.otpExpiry = json[ApiKey.otpExpiry].stringValue
        self.password = json[ApiKey.password].stringValue
        self.phoneNo = json[ApiKey.phoneNo].stringValue
        self.phoneVerified = json[ApiKey.phoneVerified].boolValue
        self.status = json[ApiKey.status].stringValue
        self.phoneNoAdded = !json[ApiKey.phoneNo].stringValue.isEmpty  // json[ApiKey.phoneNoAdded].boolValue
        self.updatedAt = json[ApiKey.updatedAt].stringValue
        self.userType = json[ApiKey.currentRole].stringValue
        self.emailVerifyToken = json[ApiKey.emailVerifyToken].stringValue
        self.canChangePassword = json[ApiKey.canChangePassword].boolValue
        self.garageName = json[ApiKey.garageProfile][ApiKey.name].stringValue
        self.garageAddress = json[ApiKey.garageProfile][ApiKey.address].stringValue
        self.isgarageProfileComplete = json[ApiKey.canChangePassword].boolValue
        self.commission = json[ApiKey.commission].doubleValue
        self.logoUrl = json[ApiKey.garageProfile][ApiKey.logo].stringValue
//        self.garageModel = GarageProfilePreFillModel(json[ApiKey.garageProfile])
    }
    
//    func garageProfileData ()-> Data{
//        do {
//            let encodedData =  (try? NSKeyedArchiver.archivedData(withRootObject: garageModel, requiringSecureCoding: false)) ?? nil
//            return encodedData ?? Data()
//        } catch {
//            printDebug("error occured")
//        }
//    }
//
//    func garageProfileDataDict (garageData: Data)-> JSONDictionary{
//        do {
//            let decodedData =  (try? NSKeyedUnarchiver.unarchiveObject(with: garageData)) ?? JSONDictionary()
//            return decodedData as! JSONDictionary
//        } catch {
//            printDebug("error occured")
//        }
//    }
    
     func fetchUserModel(dict: JSONDictionary) -> UserModel {
        var model = UserModel()
        model.id = dict[ApiKey._id] as? String ?? ""
        model.accessToken = dict[ApiKey.authToken] as? String ?? ""
        model.countryCode = dict[ApiKey.countryCode] as? String ?? ""
        model.createdAt = dict[ApiKey.createdAt] as? String ?? ""
        model.email = dict[ApiKey.email] as? String ?? ""
        model.emailVerified = dict[ApiKey.emailVerified] as? Bool ?? false
        model.image = dict[ApiKey.image] as? String ?? ""
        model.isDelete = dict[ApiKey.isDelete] as? Bool ?? false
        model.name = dict[ApiKey.name] as? String ?? ""
        model.otp = dict[ApiKey.otp] as? String ?? ""
        model.otpExpiry = dict[ApiKey.otpExpiry] as? String ?? ""
        model.password = dict[ApiKey.password] as? String ?? ""
        model.phoneNo = dict[ApiKey.phoneNo] as? String ?? ""
        model.phoneVerified = dict[ApiKey.phoneVerified] as? Bool ?? false
        model.status = dict[ApiKey.status] as? String ?? ""
        model.phoneNoAdded = dict[ApiKey.phoneNoAdded] as? Bool ?? false
        model.updatedAt = dict[ApiKey.updatedAt] as? String ?? ""
        model.userType = dict[ApiKey.currentRole] as? String ?? ""
        model.emailVerifyToken = dict[ApiKey.emailVerifyToken] as? String ?? ""
        model.canChangePassword = dict[ApiKey.canChangePassword] as? Bool ?? false
        model.garageName = dict[ApiKey.garageName] as? String ?? ""
        model.garageAddress = dict[ApiKey.garageAddress] as? String ?? ""
        model.isgarageProfileComplete = dict[ApiKey.canChangePassword] as? Bool ?? false
        model.commission = dict[ApiKey.commission] as? Double ?? 0.0
        model.logoUrl = dict[ApiKey.logoUrl] as? String ?? ""
        return model
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
            ApiKey.name : name,
            ApiKey.otp : otp,
            ApiKey.otpExpiry : otpExpiry,
            ApiKey.password : password,
            ApiKey.phoneNo : phoneNo,
            ApiKey.phoneVerified : phoneVerified,
            ApiKey.status : status,
            ApiKey.updatedAt : updatedAt,
            ApiKey.userType : userType,
            ApiKey.canChangePassword : canChangePassword,
            ApiKey.garageName: garageName,
            ApiKey.garageAddress: garageAddress,
            ApiKey.isgarageProfileComplete : isgarageProfileComplete,
            ApiKey.commission : commission,
            ApiKey.logoUrl : logoUrl
        ]
        self.userType == "1" ? AppUserDefaults.save(value: "1",forKey: .currentUserType) : AppUserDefaults.save(value: "2",forKey: .currentUserType)
        
        AppUserDefaults.save(value: dict, forKey: .fullUserProfile)
    }
}
