//
//  GarageRequestModel.swift
//  ArabianTyres
//
//  Created by Arvind on 07/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

enum RequestStatus: String, Codable{
    
    case openForBidding = "pending"
    case bidPlaced = "cancelled"
    case bidFinalsed = "allocated"
    case ongoing = "ongoing"
    
    var text : String {
        switch self {
            
        case .openForBidding:
            return "open For Bidding"
        case .bidPlaced:
            return "Bid Placed"
            
        case .bidFinalsed:
            return "Bid Finalsed"
        case .ongoing:
            return ""
        }
    }
    
    var textColor : UIColor {
        switch self {
        case .openForBidding:
            return AppColors.linkTextColor
        case .bidPlaced:
            return AppColors.warningYellowColor
        case .bidFinalsed:
            return AppColors.successGreenColor
        case .ongoing:
        return AppColors.successGreenColor
        }
    }
}


enum BidStatus: String, Codable{
    
    case openForBidding = "Open For Biding"
    case bidPlaced = "Bid Placed"
    case bidFinalsed = "Bid Finalised"
    
    var textColor : UIColor {
        switch self {
        case .openForBidding:
            return AppColors.linkTextColor
        case .bidPlaced:
            return AppColors.warningYellowColor
        case .bidFinalsed:
            return AppColors.successGreenColor
        }
    }
}
struct GarageRequestModel: Codable {
    let createdAt, id, requestID: String?
    var preferredBrands: [PreferredBrand]
    let profile, rimSize, width: Int?
    let quantity: Int?
    let images: [String]
    var preferredCountries: [PreferredBrand]
    let status: RequestStatus?
    let bidStatus: BidStatus?
    var bidData: [BidDatum]?
    let year: Int?
    let make, model,userName: String?
    let requestType : Category
    let userLongitude: Double?
    let userLatitude: Double?
    let userImage: String?
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case id = "_id"
        case requestType
        case requestID = "requestId"
        case width, preferredBrands, profile, rimSize, quantity, images, preferredCountries, status, year, make, model, userName, bidStatus, bidData, userLongitude, userLatitude, userImage
    }
    
    init() {
        createdAt = ""
        id = ""
        requestType = .battery
        requestID = ""
        make = ""
        model = ""
        userName = ""
        year = 0
        status = .bidFinalsed
        preferredCountries = []
        preferredBrands = []
        images = []
        quantity = 0
        profile = 0
        rimSize = 0
        width = 0
        bidStatus = .bidFinalsed
        bidData = []
        userImage = ""
        userLatitude = 0.0
        userLongitude = 0.0

    }
}
