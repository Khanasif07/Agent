//
//  AllRequestVM.swift
//  ArabianTyres
//
//  Created by Arvind on 07/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

import Foundation
protocol AllRequestVMDelegate: class {

}
class AllRequestVM {
    
    // MARK: Variables
    //=================================
    weak var delegate: ProfileVMDelegate?
    var userModel = UserModel()
    
    // MARK: Functions
      //=================================
      func getGarageRequestData(params: JSONDictionary,loader: Bool = false) {
          WebServices.getGarageRequestListing(parameters: params, success: { [weak self] (json) in
              guard let `self` = self else { return }
              let msg = json[ApiKey.message].stringValue
             
              printDebug(json)
          }) { [weak self] (error) in
              guard let `self` = self else { return }
              self.delegate?.getProfileDataFailed(msg: error.localizedDescription,error: error)
          }
      }
}


// MARK: - Result
struct GarageRequestModel : Codable {
    let id, createdAt: String
    let preferredBrands: [PreferredBrand]
    let preferredCountries: [String] = []
    let status: String
    let images: [String] = []
    let width, profile, rimSize, quantity: Int
    let requestType, requestID: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case createdAt, preferredBrands, preferredCountries, status, images, width, profile, rimSize, quantity, requestType
        case requestID = "requestId"
    }
}

// MARK: - PreferredBrand
struct PreferredBrand: Codable {
    let id, name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}

