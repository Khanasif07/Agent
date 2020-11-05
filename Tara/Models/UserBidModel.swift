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
    let distance: Double?
    let garage : String?
    let createdAt: String
    let garageName: String?
    let garageAddress : String?
    var countries: [String]?
    var userId : String?
    let logo: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId
        case status, bidData
        case requestID = "requestId"
        case garageID = "garageId"
        case distance, createdAt, garageName,garage, countries, logo ,garageAddress
    }
    
    init(){
        id = ""
        userId = ""
        status = ""
        bidData = []
        requestID = ""
        garageID = ""
        garage = ""
        distance = 0.0
        createdAt = ""
        garageName = ""
        countries = []
        logo = ""
        garageAddress = ""
    }
    
    func getMinAmount() -> (Double, Int){
//        var bidSortedArr: [BidDatum] = []
        if let firstIndex = bidData.firstIndex(where: { (data) -> Bool in
            return (data.isAccepted ?? false)
        }) {
            return (bidData[firstIndex].amount,bidData[firstIndex].quantity)
        }
//        bidSortedArr = bidData.sorted { (first, second) -> Bool in
//            return first.amount < second.amount
//        }
        return (bidData.first?.amount ?? 0.0,bidData.first?.quantity ?? 0)
    }
}

// MARK: - BidDatum
struct BidDatum: Codable {
    var isAccepted: Bool? = false
    let id: String
    let amount: Double
    let brandID, brandName: String
    let quantity: Int
    var isSelected: Bool? = false
    let countryName: String?
    let countryId: String?
    enum CodingKeys: String, CodingKey {
        case isAccepted
        case id = "_id"
        case amount
        case brandID = "brandId"
        case brandName, quantity
        case isSelected,countryName,countryId
    }
}
