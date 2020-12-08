//
//  RatingVM.swift
//  Tara
//
//  Created by Arvind on 04/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON


protocol RatingVMDelegate: class {
    func updateRatingSuccess(msg: String)
    func ratingSuccess(msg: String)
    func ratingFailed(msg: String)
}

class RatingVM {
    
    // MARK: Variables
    //=================================
    weak var delegate: RatingVMDelegate?
    var ratingModel : RatingModel?

    // MARK: Functions
    //=================================
    func postRatingData(params: JSONDictionary,loader: Bool = false) {
        WebServices.postRatingData(parameters: params,loader: loader, success: { [weak self] (json) in
            guard let `self` = self else { return }
            let msg = json[ApiKey.message].stringValue
            self.delegate?.ratingSuccess(msg:msg)
            printDebug(json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.ratingFailed(msg: error.localizedDescription)
        }
    }
    
    func updateRatingData(params: JSONDictionary,loader: Bool = false) {
           WebServices.updateRatingData(parameters: params,loader: loader, success: { [weak self] (json) in
               guard let `self` = self else { return }
               let msg = json[ApiKey.message].stringValue
               self.delegate?.updateRatingSuccess(msg:msg)
               printDebug(json)
           }) { [weak self] (error) in
               guard let `self` = self else { return }
               self.delegate?.ratingFailed(msg: error.localizedDescription)
           }
       }
}
