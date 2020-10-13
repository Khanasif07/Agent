//
//  OffersDetailVM.swift
//  ArabianTyres
//
//  Created by Admin on 13/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
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
}


class OffersDetailVM{
    
    //MARK:- Variables
    //================
    var bidId: String  = ""
    var userBidDetail = UserBidModel()
    weak var delegate: OffersDetailVMDelegate?
    
    //MARK:- Functions
    
    func acceptUserBidData(params: JSONDictionary){
        WebServices.acceptUserBidData(parameters: params, success: { (json) in
            self.delegate?.acceptUserBidDataSuccess(message: json[ApiKey.message].stringValue)
        }) { (error) -> (Void) in
            self.delegate?.acceptUserBidDataFailed(error: error.localizedDescription)
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
                self.delegate?.getOfferDetailSuccess(message: "")
            } catch {
                self.delegate?.getOfferDetailFailed(error: "error occured")
                printDebug("error occured")
            }
        }
    }
}
