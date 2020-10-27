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
    case bidClosed = "closed"
    case expired = "expired"
    
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
        case .bidClosed:
            return "Bid Closed"
        case .expired:
            return "Expired"
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
        case .bidClosed:
             return AppColors.successGreenColor
        case .expired:
            return AppColors.appRedColor
        }
    }
}


enum BidStatus: String, Codable{
    
    case openForBidding = "Open For Biding"
    case bidPlaced = "Bid Placed"
    case bidFinalsed = "Bid Finalised"
    case bidClosed = "Biding Closed"
    case bidRejected = "Bid Rejected"
    
    var text : String {
        switch self {
        case .openForBidding:
            return "In a Bid"
        case .bidPlaced:
            return "Bid Placed"
        case .bidFinalsed:
            return "Bid Finalised"
        case .bidClosed:
            return "Closed for Bid"
        case .bidRejected:
            return "Bid Rejected"
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
        case .bidClosed:
            return AppColors.appRedColor
        case .bidRejected:
            return AppColors.appRedColor
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
    var bidStatus: BidStatus?
    var bidData: [BidDatum]?
    var bidPlacedByGarage: [BidDatum]?
    let year: Int?
    let make, model,userName: String?
    let requestType : Category
    let userLongitude: Double?
    let userLatitude: Double?
    let userImage: String?
    let userAddress: String?
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case id = "_id"
        case requestType
        case requestID = "requestId"
        case bidPlacedByGarage
        case width, preferredBrands, profile, rimSize, quantity, images, preferredCountries, status, year, make, model, userName, bidStatus, bidData, userLongitude, userLatitude, userImage, userAddress
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
        bidPlacedByGarage = []
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
        userAddress = ""
    }
}
