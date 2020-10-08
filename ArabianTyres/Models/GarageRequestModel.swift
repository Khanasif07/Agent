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
    case bidPlaced = "satafasdf"
    case bidFinalsed = "sdfsdfs"
  
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

struct GarageRequestModel : Codable {
    let id, createdAt: String
    let preferredBrands: [PreferredBrand]
    let preferredCountries: [String] = []
    let status: RequestStatus
    let images: [String] = []
    let width, profile, rimSize, quantity: Int
    let requestType, requestID: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case createdAt, preferredBrands, preferredCountries, status, images, width, profile, rimSize, quantity, requestType
        case requestID = "requestId"
    }
}

