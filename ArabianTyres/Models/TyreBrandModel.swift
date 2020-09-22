//
//  TyreBrandModel.swift
//  ArabianTyres
//
//  Created by Admin on 22/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation



// MARK: - Result
struct TyreBrandModel: Codable {
    let id, updatedAt, name, createdAt: String
    let isDelete: Bool
    let categoryID: String
    let iconImage: String
    let type, status: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case updatedAt, name, createdAt, isDelete
        case categoryID = "categoryId"
        case iconImage, type, status
    }
    
    init(){
        id = ""
        updatedAt = ""
        name  = ""
        createdAt = ""
        isDelete = false
        categoryID = ""
        iconImage = ""
        type = ""
        status = ""
    }
}
