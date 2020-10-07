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
