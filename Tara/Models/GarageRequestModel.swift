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

enum ServiceState : String, Codable{
    case startService = "start_service"
    case carReceived = "car_received"
    case inProgress = "in_progress"
    case completed = "service_completed"
    case readyToBeTaken = "ready_to_be_taken"
    case delivered = "delivered"
    case none = "completed"
    case inGarage = "in_garage"
    
    var serviceBtnTitle: String {
        switch self {
        case .startService:
            return "Start Service"
        case .carReceived:
            return "Car Received"
        case .inProgress:
            return "In Progress"
        case .completed:
            return "Service Completed"
        case .readyToBeTaken:
            return "Ready To Be Taken"
        case .delivered:
            return "Delivered"
        default:
            return ""
        }
    }
}

struct GarageRequestModel: Codable {
  
    let createdAt, id, requestID: String?
    var preferredBrands: [PreferredBrand]?
    let profile, rimSize, width: Int?
    let quantity: Int?
    let images: [String]?
    var preferredCountries: [PreferredBrand]?
    let status: RequestStatus?
    var bidStatus: BidStatus?
    var bidData: [BidDatum]?
    var ratingDetails: RatingModel?
    var bidPlacedByGarage: [BidDatum]?
    let year: Int?
    let make, model,userName: String?
    let requestType : Category
    let userLongitude: Double?
    let userLatitude: Double?
    let userImage: String?
    let userId: String?
    let userAddress: String?
    let requestDocId : String?
    let payableAmount : Double?
    let requestedBy : String?
    var serviceStatus: ServiceState? // for car Received, in Progress, complete, ready to be taken
    let garageName: String?
    let logo : String?
    let isServiceStarted: Bool?
    var isServiceCompleted: Bool?
    
    //Review listing Api key
    let rating : Int?
    let review : String?
    let garageId : String?
    let serviceType : String?
    var isReviewReported :Bool?
    let ratingId: String?
    var reportedTime: String?
    var reportReason: String?

    //Service Complete Api key
    let isRated : Bool?
    let serviceCompletedOn : String?
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case userId
        case id = "_id"
        case requestType
        case ratingDetails
        case requestID = "requestId"
        case bidPlacedByGarage, requestedBy
        case rating, review, garageId, serviceType, serviceStatus
        case width, preferredBrands, profile, rimSize, quantity, images, preferredCountries, status, year, make, model, userName, bidStatus, bidData, userLongitude, userLatitude, userImage, userAddress, requestDocId, payableAmount
        case isRated, serviceCompletedOn, garageName, logo, isReviewReported, ratingId, reportedTime, reportReason, isServiceStarted, isServiceCompleted
    }
    
    init() {
        userId = ""
        createdAt = ""
        id = ""
        requestType = .battery
        requestID = ""
        make = ""
        model = ""
        userName = ""
        ratingDetails = RatingModel()
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
        requestDocId = ""
        payableAmount = 0.0
        requestedBy = ""
        logo = ""
        rating = 0
        review = ""
        garageId = ""
        serviceType = ""
        serviceStatus = .carReceived
        isRated = false
        serviceCompletedOn = ""
        garageName = ""
        isReviewReported = false
        ratingId = ""
        reportedTime = ""
        reportReason = ""
        isServiceStarted = false
        isServiceCompleted = false
    }
}

struct RatingModel: Codable {
    let rating : Int?
    let review : String?
    let garageId : String?
    let serviceType : String?
    var isReported :Bool?
    let ratingId: String?
    let updatedAt: String?
    let createdAt, _id,userId, requestID: String?
    let isDelete : Bool?
    let images: [String]?
    
    init(){
        rating = 0
        review = ""
        garageId = ""
        serviceType = ""
        updatedAt = ""
        createdAt = ""
        isReported = false
        _id = ""
        requestID = ""
        userId = ""
        images = []
        isDelete = false
        ratingId = ""
    }
    
}
