//
//  TyreSizeModel.swift
//  ArabianTyres
//
//  Created by Admin on 25/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

// MARK: - Result
struct TyreSizeModel: Codable , Equatable{
    var rimSize , width, profile: Int
    
    enum CodingKeys: String, CodingKey {
        case profile
        case width
        case rimSize
    }
    init(){
        profile = 0
        width = 0
        rimSize = 0
    }
}
