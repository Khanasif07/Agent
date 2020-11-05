//
//  ChatModel.swift
//  Tara
//
//  Created by Arvind on 05/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct ChatModel: Codable {
    let garageName: String
    let longitude, latitude: Double
    let garageImage: String
    let totalAmount: Int
    let address, garageID, garageAddress, userID: String
    let garageOwner: String
    let totalRequests: Int
    let userName: String
    let garageRating: Int
    let garageLogo: String
    let userImage, id: String
    
    enum CodingKeys: String, CodingKey {
        case garageName, longitude, latitude, garageImage, totalAmount, address
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
        garageRating = 0
        garageLogo = ""
        userImage = ""
    }
}