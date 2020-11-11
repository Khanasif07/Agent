//
//  ChatModel.swift
//  Tara
//
//  Created by Arvind on 05/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct ChatModel: Codable {
    let garageName: String?
    let longitude, latitude: Double
    let garageImage: String
    let totalAmount: Int?
    let address: String?
    let garageID : String
    let garageAddress: String?
    let userID: String
    let garageOwner: String
    let totalRequests: Int
    let userName: String
    let garageRating: Double?
    let garageLogo: String
    let userImage, id: String
    let requestId: String?
    
    enum CodingKeys: String, CodingKey {
        case garageName, longitude, latitude, garageImage, totalAmount, address, requestId
        case garageID = "garageId"
        case garageAddress
        case userID = "userId"
        case garageOwner
        case totalRequests = "TotalRequests"
        case userName, garageRating, garageLogo, userImage
        case id = "_id"
    }
    
    init(){
        id = ""
        garageName = ""
        longitude = 0.0
        latitude = 0.0
        garageImage = ""
        totalAmount = 0
        address = ""
        garageID = ""
        userID = ""
        garageOwner = ""
        garageAddress = ""
        totalRequests = 0
        userName = ""
        garageRating = 0.0
        garageLogo = ""
        userImage = ""
        requestId = ""
    }
}
