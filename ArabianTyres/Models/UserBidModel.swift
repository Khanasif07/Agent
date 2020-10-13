//
//  UserBidModel.swift
//  ArabianTyres
//
//  Created by Arvind on 12/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct UserBidModel: Codable {
    let id, status: String
    let bidData: [BidDatum]
    let requestID, garageID: String
    let distance: Int
    let createdAt, garageName: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case status, bidData
        case requestID = "requestId"
        case garageID = "garageId"
        case distance, createdAt, garageName
    }
}

// MARK: - BidDatum
struct BidDatum: Codable {
    let isAccepted: Bool?
    let id: String
    let amount: Int
    let brandID, brandName: String
    let quantity: Int

    enum CodingKeys: String, CodingKey {
        case isAccepted
        case id = "_id"
        case amount
        case brandID = "brandId"
        case brandName, quantity
    }
}
