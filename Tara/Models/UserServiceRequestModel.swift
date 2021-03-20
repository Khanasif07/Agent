//
//  UserServiceRequestModel.swift
//  ArabianTyres
//
//  Created by Admin on 07/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

enum ServiceStatus : String,Codable {
    case pending
    case ongoing
    case cancelled
    case completed
    case allocated
    case expired
    
    var text :String{
        switch self {
          
        case .pending:
            return LocalizedString._pending.localized
        case .ongoing:
            return LocalizedString.ongoing.localized
        case .cancelled:
            return LocalizedString.cancelled.localized
        case .completed:
            return LocalizedString.completed.localized
        default:
            return LocalizedString.expired.localized
        }
    }
    
    var textColor : UIColor {
        switch self {
            
        case .pending:
            return #colorLiteral(red: 0.937254902, green: 0.6509803922, blue: 0.1803921569, alpha: 1)
        case .ongoing:
            return #colorLiteral(red: 0.937254902, green: 0.6509803922, blue: 0.1803921569, alpha: 1)
        case .cancelled:
            return #colorLiteral(red: 0.8784313725, green: 0.137254902, blue: 0.2588235294, alpha: 1)
        case .completed:
            return #colorLiteral(red: 0.1725490196, green: 0.7137254902, blue: 0.4549019608, alpha: 1)
        default:
            return #colorLiteral(red: 0.8784313725, green: 0.137254902, blue: 0.2588235294, alpha: 1)
        }
    }
}

enum ServiceStatuss : String,Codable {
    case start_service
    case in_progress
    case ready_to_be_taken
    case delivered
    case car_received
    case completed
    
    var text :String{
        switch self {
        case .start_service:
            return "Service started"//"Car Received"
        case .in_progress:
            return "In garage"//"In Garage"
        case .ready_to_be_taken:
            return "Ready to pick"//"Service Completed"
        case .delivered:
            return "Delivered"//"Delivered"
        case .car_received:
            return "Car Received"
        default:
            return "Completed"
        }
    }
    
    var textColor : UIColor {
        switch self {
        case .start_service:
            return #colorLiteral(red: 0.937254902, green: 0.6509803922, blue: 0.1803921569, alpha: 1)
        case .in_progress:
            return #colorLiteral(red: 0.937254902, green: 0.6509803922, blue: 0.1803921569, alpha: 1)
        case .delivered:
            return #colorLiteral(red: 0.1725490196, green: 0.7137254902, blue: 0.4549019608, alpha: 1)
        case .ready_to_be_taken:
            return #colorLiteral(red: 0.937254902, green: 0.6509803922, blue: 0.1803921569, alpha: 1)
        default:
            return #colorLiteral(red: 0.937254902, green: 0.6509803922, blue: 0.1803921569, alpha: 1)
        }
    }
}


// MARK: - Result
struct UserServiceRequestModel: Codable {
    let requestID, createdAt: String
    let profile: Int?
    let requestType: String
    let rimSize: Int?
    var status: ServiceStatus
    var serviceStatus : ServiceStatuss?
    let preferredBrands: [PreferredBrand]
    let preferredCountries: [PreferredBrand]
    let quantity, width: Int?
    let id: String
    let make: String?
    let model: String?
    let year: Int?
    let images: [String]
    let totalBids: Int?
    let lowestBid: Double?
    let nearestBidder: Double?
    let totalOffers : Int?
    let isOfferAccepted : Bool?
    let seenBy: Int?
    let isServiceStarted : Bool?
    let paymentStatus : PaymentStatus?
    let otp : Int?
    
    enum CodingKeys: String, CodingKey {
        case requestID = "requestId"
        case createdAt, profile, requestType, rimSize, status, preferredBrands, preferredCountries, quantity, width , make ,model
        case id = "_id"
        case paymentStatus
        case images , serviceStatus
        case totalBids,lowestBid,nearestBidder,isOfferAccepted, totalOffers, seenBy,year, isServiceStarted, otp
    }
    
    init(){
        requestID = ""
        createdAt = ""
        profile = 0
        requestType = ""
        rimSize = 0
        status = .pending
        serviceStatus = .start_service
        preferredBrands = []
        preferredCountries = []
        quantity = 0
        width = 0
        id = ""
        make  = ""
        model = ""
        year = 0
        images = []
        nearestBidder = 0.0
        totalBids = 0
        lowestBid = 0
        isOfferAccepted = false
        totalOffers = 0
        seenBy = 0
        isServiceStarted = false
        otp = 0
        paymentStatus = .pending
    }
}

// MARK: - PreferredBrand
struct PreferredBrand: Codable {
    let id, name: String
    var bidId : String? = ""
    let countrySpecificBrands : [String]?
    var isSelected: Bool?
    var amount: Double?
    var quantity: Int?
    var countryId: String?
    var countryName: String?
 
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case isSelected
        case countrySpecificBrands ,countryName,countryId
        case amount
        case bidId
        case quantity
    }
    init(){
        bidId = ""
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
