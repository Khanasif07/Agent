//
//  TyreCountryModel.swift
//  ArabianTyres
//
//  Created by Admin on 22/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Foundation


struct TyreCountryModel: Codable ,Equatable{
    let createdAt, updatedAt, type: String
    let flag: String
    let name: String
    let isDelete: Bool
    let categoryID, id, status: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt, updatedAt, type, flag, name, isDelete
        case categoryID = "categoryId"
        case id = "_id"
        case status
    }
    
    static func == (lhs: TyreCountryModel, rhs: TyreCountryModel) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    init(){
        id = ""
        updatedAt = ""
        name  = ""
        createdAt = ""
        isDelete = false
        categoryID = ""
        flag = ""
        type = ""
        status = ""
    }
}
