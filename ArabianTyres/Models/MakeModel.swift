//
//  MakeModel.swift
//  ArabianTyres
//
//  Created by Admin on 25/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
//
//  TyreBrandModel.swift
//  ArabianTyres
//
//  Created by Admin on 22/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation



// MARK: - Result
struct MakeModel: Codable , Equatable{
    var id, updatedAt, name, createdAt: String
    let isDelete: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case updatedAt, name, createdAt, isDelete
    }
    
   static func == (lhs: MakeModel, rhs: MakeModel) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    init(){
        id = ""
        updatedAt = ""
        name  = ""
        createdAt = ""
        isDelete = false
    }
}
