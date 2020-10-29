//
//  ModelData.swift
//  ArabianTyres
//
//  Created by Admin on 25/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import Foundation



// MARK: - Result
struct ModelData: Codable , Equatable{
    var model: String
    
    enum CodingKeys: String, CodingKey {
        case model
    }
    
   static func == (lhs: ModelData, rhs: ModelData) -> Bool {
        return (lhs.model == rhs.model)
    }
    
    init(){
        model = ""
    }
}
