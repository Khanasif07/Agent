//
//  URTyreStep1VM.swift
//  ArabianTyres
//
//  Created by Admin on 05/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON


// MARK: - Width
struct TyreWidthModel: Codable , Equatable{
    var width: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case width
    }
    
   static func == (lhs: TyreWidthModel, rhs: TyreWidthModel) -> Bool {
        return (lhs.width == rhs.width)
    }
    
    init(){
        width = 0
    }
}

// MARK: - Profile
struct TyreProfileModel: Codable , Equatable{
    var profile: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case profile
    }
    
   static func == (lhs: TyreProfileModel, rhs: TyreProfileModel) -> Bool {
        return (lhs.profile == rhs.profile)
    }
    
    init(){
        profile = 0
    }
}

// MARK: - RimSize
struct TyreRimSizeModel: Codable , Equatable{
    var rimSize: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case rimSize
    }
    
   static func == (lhs: TyreRimSizeModel, rhs: TyreRimSizeModel) -> Bool {
        return (lhs.rimSize == rhs.rimSize)
    }
    
    init(){
        rimSize = 0
    }
}



protocol URTyreStep1VMDelegate: class {
    func getWidthListingDataSuccess(message: String)
    func getWidthListingDataFailed(error:String)
    func getProfileListingDataSuccess(message: String)
    func getProfileListingDataFailed(error:String)
    func getRimSizeListingDataSuccess(message: String)
    func getRimSizeListingDataFailed(error:String)
    
}

class URTyreStep1VM{
    
    //MARK:- Variables
    //================
    var tyreWidthListing = [TyreWidthModel]()
    var tyreProfileListing = [TyreProfileModel]()
    var tyreRimSizeListing = [TyreRimSizeModel]()
    weak var delegate: URTyreStep1VMDelegate?
    
    //MARK:- Functions
    func getWidthListingData(dict: JSONDictionary){
        WebServices.getWidthListingData(parameters: dict,endPoint: .userServiceWidth, success: { (json) in
            self.parseToWidthListingData(result: json)
        }) { (error) -> (Void) in
            self.delegate?.getWidthListingDataFailed(error: error.localizedDescription)
        }
    }
    
    //MARK:- Functions
    func getProfileListingData(dict: JSONDictionary){
        WebServices.getWidthListingData(parameters: dict,endPoint: .userServiceProfile, success: { (json) in
            self.parseToProfileListingData(result: json)
        }) { (error) -> (Void) in
            self.delegate?.getProfileListingDataFailed(error: error.localizedDescription)
        }
    }
   
    //MARK:- Functions
    func getRimSizeListingData(dict: JSONDictionary){
        WebServices.getWidthListingData(parameters: dict,endPoint: .userServicerimSize, success: { (json) in
            self.parseToRimSizeListingData(result: json)
        }) { (error) -> (Void) in
            self.delegate?.getRimSizeListingDataFailed(error: error.localizedDescription)
        }
    }
    
    func parseToWidthListingData(result: JSON) {
           if let jsonString = result[ApiKey.data].rawString(), let data = jsonString.data(using: .utf8) {
               do {
                   if result[ApiKey.data].arrayValue.isEmpty {
                       self.tyreWidthListing = []
                       self.delegate?.getWidthListingDataSuccess(message: "")
                       return
                   }
                   let modelList = try JSONDecoder().decode([TyreWidthModel].self, from: data)
                   self.tyreWidthListing = modelList
                   self.delegate?.getWidthListingDataSuccess(message: "")
               } catch {
                   self.delegate?.getWidthListingDataFailed(error: "error occured")
                   printDebug("error occured")
               }
           }
       }
    
    func parseToProfileListingData(result: JSON) {
        if let jsonString = result[ApiKey.data].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                if result[ApiKey.data].arrayValue.isEmpty {
                    self.tyreProfileListing = []
                    self.delegate?.getProfileListingDataSuccess(message: "")
                    return
                }
                let modelList = try JSONDecoder().decode([TyreProfileModel].self, from: data)
                self.tyreProfileListing = modelList
                self.delegate?.getProfileListingDataSuccess(message: "")
            } catch {
                self.delegate?.getProfileListingDataFailed(error: "error occured")
                printDebug("error occured")
            }
        }
    }
    
    func parseToRimSizeListingData(result: JSON) {
           if let jsonString = result[ApiKey.data].rawString(), let data = jsonString.data(using: .utf8) {
               do {
                   if result[ApiKey.data].arrayValue.isEmpty {
                       self.tyreProfileListing = []
                       self.delegate?.getRimSizeListingDataSuccess(message: "")
                       return
                   }
                   let modelList = try JSONDecoder().decode([TyreRimSizeModel].self, from: data)
                   self.tyreRimSizeListing = modelList
                   self.delegate?.getRimSizeListingDataSuccess(message: "")
               } catch {
                   self.delegate?.getRimSizeListingDataFailed(error: "error occured")
                   printDebug("error occured")
               }
           }
       }
}
