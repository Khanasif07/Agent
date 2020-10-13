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
    var bidData: [BidDatum]
    let requestID, garageID: String
    let distance: Int
    let garage : String?
    let createdAt: String
    let garageName: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case status, bidData
        case requestID = "requestId"
        case garageID = "garageId"
        case distance, createdAt, garageName,garage
    }
    
    init(){
        id = ""
        status = ""
        bidData = []
        requestID = ""
        garageID = ""
        garage = ""
        distance = 0
        createdAt = ""
        garageName = ""
    }
}

// MARK: - BidDatum
struct BidDatum: Codable {
    let isAccepted: Bool?
    let id: String
    let amount: Int
    let brandID, brandName: String
    let quantity: Int
    var isSelected: Bool? = false

    enum CodingKeys: String, CodingKey {
        case isAccepted
        case id = "_id"
        case amount
        case brandID = "brandId"
        case brandName, quantity
        case isSelected
    }
}
