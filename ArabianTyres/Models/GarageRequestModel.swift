//
//  GarageRequestModel.swift
//  ArabianTyres
//
//  Created by Arvind on 07/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct GarageRequestModel : Codable {
    let id, createdAt: String
    let preferredBrands: [PreferredBrand]
    let preferredCountries: [String] = []
    let status: String
    let images: [String] = []
    let width, profile, rimSize, quantity: Int
    let requestType, requestID: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case createdAt, preferredBrands, preferredCountries, status, images, width, profile, rimSize, quantity, requestType
        case requestID = "requestId"
    }
}

