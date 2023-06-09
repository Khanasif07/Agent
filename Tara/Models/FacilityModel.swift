//
//  FacilityModel.swift
//  ArabianTyres
//
//  Created by Arvind on 21/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON

var categoryArr : [String] = []//["MRF","Nokian Tyre","Apollo Tyres","CEAT Ltd","Goodyear","Peerless Tyre"]

class FacilityModel{

    var status : String = ""
    var isDelete : String = ""
    var createdAt : String = ""
    var name : String = ""
    var updatedAt : String = ""
    var id : String = ""
    var subCategory: [Brands] = []
    var isSelected: Bool = false
    var isSubCategorySelected : Bool = false
    
    init(_ json : JSON = JSON()) {
        self.id = json[ApiKey._id].stringValue
        self.status = json[ApiKey.status].stringValue
        self.createdAt = json[ApiKey.createdAt].stringValue
        self.name = json[ApiKey.name].stringValue
        self.updatedAt = json[ApiKey.updatedAt].stringValue
        self.isDelete = json[ApiKey.isDelete].stringValue
        self.subCategory = json[ApiKey.brands].arrayValue.map({Brands($0)})
   
    }
    
    init(_ json : JSONDictionary = [:]) {
        self.id = JSON(json[ApiKey.serviceId]).stringValue
        self.name = JSON(json[ApiKey.serviceName]).stringValue
        self.subCategory = JSON(json[ApiKey.brands]).arrayValue.map({Brands($0,isSelected: true)})
        
    }
    
    func getSelectedService() -> JSONDictionary {
        var brandArr : [JSONDictionary] = []
        var dict : JSONDictionary = [ApiKey.serviceId: self.id,ApiKey.serviceName: self.name]
        for cat in subCategory {
            if cat.isSelected {
                brandArr.append(cat.getSelectedBrands())
            }
        }
        dict[ApiKey.brands] = brandArr
        return dict
    }
    
    func updateModel() {
        self.isSelected = false
        self.isSubCategorySelected = false
        subCategory.forEach { (brand) in
            brand.isSelected = false
        }
    }
}


class Brands {
 
    var id :String = ""
    var categoryId: String = ""
    var countryId : String = ""
    var countryName : String = ""
    var createdAt : String = ""
    var iconImage : String = ""
    var isDelete : String = ""
    var name : String = ""
    var brandName : String = ""
    var brandId : String = ""
    var serviceId : String = ""
    var status: String = ""
    var updatedAt: String = ""
    var type: String = ""
    var isSelected: Bool = false
   
    init(_ json : JSON = JSON()) {
        self.id = json[ApiKey._id].stringValue
        self.categoryId = json[ApiKey.categoryId].stringValue
        self.countryId = json[ApiKey.countryId].stringValue
        self.countryName = json[ApiKey.countryName].stringValue
        self.createdAt = json[ApiKey.createdAt].stringValue
        self.iconImage = json[ApiKey.iconImage].stringValue
        self.isDelete = json[ApiKey.name].stringValue
        
        self.brandName = json[ApiKey.brandName].stringValue
        self.brandId = json[ApiKey.brandId].stringValue
        self.name = json[ApiKey.name].stringValue
        self.serviceId = json[ApiKey.serviceId].stringValue
        self.status = json[ApiKey.status].stringValue
        self.updatedAt = json[ApiKey.updatedAt].stringValue
        self.type = json[ApiKey.type].stringValue
        
    }
    
    init(_ dict : JSON = JSON(), isSelected: Bool = false) {
        self.name = dict[ApiKey.brandName].stringValue
        self.id = dict[ApiKey.brandId].stringValue
    }
    
    func getSelectedBrands() -> JSONDictionary {
        let dict : JSONDictionary = [ApiKey.brandName: self.name, ApiKey.brandId: self.id]
        return dict
    }
}
