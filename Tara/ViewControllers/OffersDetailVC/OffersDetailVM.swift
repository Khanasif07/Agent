//
//  UserAllOfferVM.swift
//  ArabianTyres
//
//  Created by Arvind on 12/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import Foundation
import SwiftyJSON


protocol OffersDetailVMDelegate: class {
    func getOfferDetailSuccess(message: String)
    func getOfferDetailFailed(error:String)
    func acceptUserBidDataSuccess(message: String)
    func acceptUserBidDataFailed(error:String)
    func rejectUserBidDataSuccess(message: String)
    func rejectUserBidDataFailed(error:String)
    func countryDataFilter()
}

extension OffersDetailVMDelegate {
    func countryDataFilter(){}
}

class OffersDetailVM{
    
    //MARK:- Variables
    //================
    var bidId: String  = ""
    var garageName : String = ""
    var userBidDetail = UserBidModel()
    weak var delegate: OffersDetailVMDelegate?
    var bidData : [BidDatum] = []
    
    //MARK:- Functions
    
    func acceptUserBidData(params: JSONDictionary){
        WebServices.acceptUserBidData(parameters: params, success: { (json) in
            self.delegate?.acceptUserBidDataSuccess(message: json[ApiKey.message].stringValue)
        }) { (error) -> (Void) in
            self.delegate?.acceptUserBidDataFailed(error: error.localizedDescription)
        }
    }
    
    func rejectUserBidData(params: JSONDictionary){
        WebServices.rejectUserBidData(parameters: params, success: { (json) in
            self.delegate?.rejectUserBidDataSuccess(message: json[ApiKey.message].stringValue)
        }) { (error) -> (Void) in
            self.delegate?.rejectUserBidDataFailed(error: error.localizedDescription)
        }
    }
    
    func getOfferDetailData(params: JSONDictionary){
        WebServices.getOfferDetailData(parameters: params, success: { (json) in
            self.parseToOfferDetailData(result: json)
        }) { (error) -> (Void) in
            self.delegate?.getOfferDetailFailed(error: error.localizedDescription)
        }
    }
    
    func parseToOfferDetailData(result: JSON) {
        if let jsonString = result[ApiKey.data].rawString(), let data = jsonString.data(using: .utf8) {
            do {
                let modelList = try JSONDecoder().decode(UserBidModel.self, from: data)
                printDebug(modelList)
                self.userBidDetail = modelList
                getBidData()
            } catch {
                self.delegate?.getOfferDetailFailed(error: "error occured")
                printDebug("error occured")
            }
        }
    }
    
    func getBidData(country: String = "") {
        if country.isEmpty {
            bidData = (userBidDetail.countries?.isEmpty ?? false) ? userBidDetail.bidData : []
            self.delegate?.getOfferDetailSuccess(message: "")
        }else {
            bidData = userBidDetail.bidData.filter({ (data) -> Bool in
                return data.countryName == country
            })
            delegate?.countryDataFilter()
        }
    }
}
