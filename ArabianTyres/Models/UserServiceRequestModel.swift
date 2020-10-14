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
    let profile: Int?
    let requestType: String
    let rimSize: Int?
    let status: String
    let preferredBrands: [PreferredBrand]
    let preferredCountries: [PreferredBrand]
    let quantity, width: Int?
    let id: String
    let make: String?
    let model: String?
    let images: [String]
    let totalBids: Int?
    let lowestBid: Int?
    let nearestBidder: Int?
    let totalOffers : Int
    let isOfferAccepted : Bool
    
    enum CodingKeys: String, CodingKey {
        case requestID = "requestId"
        case createdAt, profile, requestType, rimSize, status, preferredBrands, preferredCountries, quantity, width , make ,model
        case id = "_id"
        case images
        case totalBids,lowestBid,nearestBidder,isOfferAccepted, totalOffers
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
        make  = ""
        model = ""
        images = []
        nearestBidder = 0
        totalBids = 0
        lowestBid = 0
        isOfferAccepted = false
        totalOffers = 0
    }
}

// MARK: - PreferredBrand
struct PreferredBrand: Codable {
    let id, name: String
    let countrySpecificBrands : [String]?
    var isSelected: Bool?
    var amount: Int?
    var quantity: Int?
    var countryId: String?
    var countryName: String?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case isSelected
        case countrySpecificBrands ,countryName,countryId
        case amount
        case quantity
    }
    init(){
        id  = ""
        name  = ""
        isSelected = false
        countrySpecificBrands = []
        countryName = ""
        countryId = ""
        amount = 0
        quantity = 0
    }
    
    init(id:String,name:String,countrySpecificBrands: [String]){
        self.id = id
        self.name = name
        self.countrySpecificBrands = countrySpecificBrands
    }
}
