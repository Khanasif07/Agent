//
//  UserServiceRequestModel.swift
//  ArabianTyres
//
//  Created by Admin on 07/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation


// MARK: - Result
struct UserServiceRequestModel: Codable {
    let requestID, createdAt: String
    let profile: Int
    let requestType: String
    let rimSize: Int
    let status: String
    let preferredBrands: [PreferredBrand]
    let preferredCountries: [String]
    let quantity, width: Int
    let id: String
    let images: [String]

    enum CodingKeys: String, CodingKey {
        case requestID = "requestId"
        case createdAt, profile, requestType, rimSize, status, preferredBrands, preferredCountries, quantity, width
        case id = "_id"
        case images
    }
    
    init(){
        requestID = ""
        createdAt = ""
        profile = 0
        requestType = ""
        rimSize = 0
        status = ""
        preferredBrands = []
        preferredCountries = []
        quantity = 0
        width = 0
        id = ""
        images = []
    }
}

// MARK: - PreferredBrand
struct PreferredBrand: Codable {
    let id, name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
    init(){
        id  = ""
        name  = ""
    }
}
