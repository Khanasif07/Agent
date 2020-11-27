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
    var commercialRegister          : [ImageModel] = []
    var vatCertificate              : [ImageModel] = []
    var municipalityLicense         : [ImageModel] = []
    var ownerId                     : [ImageModel] = []
    var bankName                    : String = ""
    var accountNumber               : String = ""
    var confirmAccountNumber        : String = ""
    var serviceCenterDist           : String = ""
    var minInstallationPrice        : Int = 500
    var maxInstallationPrice        : Int = 800
    var services                    : [JSONDictionary] = []
    
    
    func getGarageProfileDict()-> JSONDictionary {
        
        let dict: JSONDictionary = [
            ApiKey.logo : logoUrl,
            ApiKey.name: serviceCenterName,
            ApiKey.latitude : latitude,
            ApiKey.longitude : longitude,
            ApiKey.address : address,
            ApiKey.images : getGarageImgUrl(),
            ApiKey.commercialRegister : getDocDict(imageModelArr: commercialRegister),
            ApiKey.vatCertificate : getDocDict(imageModelArr: vatCertificate),
            ApiKey.municipalityLicense : getDocDict(imageModelArr: municipalityLicense),
            ApiKey.ownerId : getDocDict(imageModelArr: ownerId),
            ApiKey.bank : bankName,
            ApiKey.accountNumber : accountNumber
           
        ]

        return dict
    }
    
    func getGarageImgUrl() -> [String] {
        var arr : [String] = []
        serviceCenterImages.forEach { (model) in
            arr.append(model.url)
        }
        return arr
    }
    
    
    func getDocDict(imageModelArr: [ImageModel]) -> [JSONDictionary]{
        var arr: [JSONDictionary] = []
        imageModelArr.forEach { (model) in
            arr.append(model.dictionary())
        }
        return arr
    }
    
    func getCompleteProfileDict()-> JSONDictionary {
           
           let dict: JSONDictionary = [
               ApiKey.logo : logoUrl,
               ApiKey.name: serviceCenterName,
               ApiKey.latitude : latitude,
               ApiKey.longitude : longitude,
               ApiKey.address : address,
               ApiKey.images : getGarageImgUrl(),
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
    var phoneNo                        : String = ""
    var name                           : String = ""
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
       var minInstallationPrice        : Int = 500
       var maxInstallationPrice        : Int = 800
       var services                    : [ServicesModel] = []
       var requestTime                 : String = ""
    
    init(_ json : JSON = JSON()) {
        self.phoneNo = json[ApiKey.phoneNo].stringValue
        self.name = json[ApiKey.name].stringValue
        self.services = json[ApiKey.services].arrayValue.map{((ServicesModel($0)))}
        self.logoUrl = json[ApiKey.logo].stringValue
        self.serviceCenterName = json[ApiKey.name].stringValue
        self.bankName = json[ApiKey.bank].stringValue
        self.address = json[ApiKey.address].stringValue
        self.maxInstallationPrice = json[ApiKey.maxInstallationPrice].intValue
        self.minInstallationPrice = json[ApiKey.minInstallationPrice].intValue
        
        self.commercialRegister = json[ApiKey.commercialRegister].arrayValue.map{(($0.stringValue))}
        self.municipalityLicense = json[ApiKey.municipalityLicense].arrayValue.map{(($0.stringValue))}
        self.vatCertificate = json[ApiKey.commercialRegister].arrayValue.map{(($0.stringValue))}
        self.ownerId = json[ApiKey.commercialRegister].arrayValue.map{(($0.stringValue))}

        self.latitude = json[ApiKey.latitude].doubleValue
        self.longitude = json[ApiKey.longitude].doubleValue
        
        self.accountNumber = json[ApiKey.accountNumber].stringValue
        self.serviceCenterDist = json[ApiKey.district].stringValue
        self.serviceCenterImages = json[ApiKey.images].arrayValue.map{((ImageModel(withJSON: $0)))}

    }
    
    func updateGarageProfileModel(_ model: GarageProfilePreFillModel) {
        GarageProfileModel.shared.logoUrl = model.logoUrl
        GarageProfileModel.shared.serviceCenterName = model.serviceCenterName
        GarageProfileModel.shared.bankName = model.bankName
        GarageProfileModel.shared.address = model.address
        GarageProfileModel.shared.maxInstallationPrice = model.maxInstallationPrice
        GarageProfileModel.shared.minInstallationPrice = model.minInstallationPrice
        GarageProfileModel.shared.latitude = model.latitude
        GarageProfileModel.shared.longitude = model.longitude
        GarageProfileModel.shared.accountNumber = model.accountNumber
        GarageProfileModel.shared.serviceCenterDist = model.serviceCenterDist
        GarageProfileModel.shared.serviceCenterImages = model.serviceCenterImages
        GarageProfileModel.shared.services = model.services.map({$0.getSelectedService()})
    }
    
    func getBrandAndServiceName()-> [String] {
        var arr : [String] = []
        services.forEach { (model) in
            if model.brands.isEmpty {
                arr.append(model.serviceName)
            }else {
                model.brands.forEach { (brand) in
                    let txt = brand.name + " (\(model.serviceName))"
                    arr.append(txt)
                }
            }
        }
        return arr
    }
}

struct ServicesModel {
    var serviceName : String = ""
    var serviceId : String = ""
    var brands : [Brands] = []
    
    init(_ json : JSON = JSON()) {
        self.serviceName = json[ApiKey.serviceName].stringValue
        self.serviceId = json[ApiKey.serviceId].stringValue
        self.brands = json[ApiKey.brands].arrayValue.map({Brands($0,isSelected: true)})
    }

    func getSelectedService() -> JSONDictionary {
         var brandArr : [JSONDictionary] = []
         var dict : JSONDictionary = [ApiKey.serviceId: self.serviceId, ApiKey.serviceName: self.serviceName]
         for cat in brands {
                 brandArr.append(cat.getSelectedBrands())
         }
         dict[ApiKey.brands] = brandArr
         return dict
     }
}


