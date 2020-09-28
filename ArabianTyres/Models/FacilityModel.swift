//
//  FacilityModel.swift
//  ArabianTyres
//
//  Created by Arvind on 21/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON

var categoryArr : [String] = ["MRF","Nokian Tyre","Apollo Tyres","CEAT Ltd","Goodyear","Peerless Tyre"]

class FacilityModel{

    var status : String = ""
    var isDelete : String = ""
    var createdAt : String = ""
    var name : String = ""
    var updatedAt : String = ""
    var id : String = ""
    var category : [SubCategoryModel] = []
    var isSelected: Bool = false
    var isSubCategorySelected : Bool = false
    
    init(_ json : JSON = JSON()) {
        self.id = json[ApiKey._id].stringValue
        self.status = json[ApiKey.status].stringValue
        self.createdAt = json[ApiKey.createdAt].stringValue
        self.name = json[ApiKey.name].stringValue
        self.updatedAt = json[ApiKey.updatedAt].stringValue
        self.isDelete = json[ApiKey.isDelete].stringValue
       
        for cat in categoryArr {
            self.category.append(SubCategoryModel(cat))
        }
    }
    
    func updateModel() {
        self.isSelected = false
        self.isSubCategorySelected = false
    }
}

class SubCategoryModel{
    var name: String = ""
    var isSelected: Bool = false
    
    init(_ name: String) {
        self.name = name
    }
}

