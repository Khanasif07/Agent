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
  
    var text : String {
        switch self {
            
        case .openForBidding:
            return "open For Bidding"
        case .bidPlaced:
            return "Bid Placed"
            
        case .bidFinalsed:
            return "Bid Finalsed"
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
//    let status: RequestStatus?
    let status: String
    let year: Int?
    let make, model,userName: String?
    let requestType : Category
    enum CodingKeys: String, CodingKey {
        case createdAt
        case id = "_id"
        case requestType
        case requestID = "requestId"
        case width, preferredBrands, profile, rimSize, quantity, images, preferredCountries, status, year, make, model, userName
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
        status = ""
//        status = .bidFinalsed
        preferredCountries = []
        preferredBrands = []
        images = []
        quantity = 0
        profile = 0
        rimSize = 0
        width = 0
    }
}
