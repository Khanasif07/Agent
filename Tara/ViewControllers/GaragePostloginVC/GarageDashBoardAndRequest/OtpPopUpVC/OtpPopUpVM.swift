//
//  OtpPopUpVM.swift
//  Tara
//
//  Created by Arvind on 09/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import Foundation
import SwiftyJSON


protocol OtpPopUpVMDelegate: class {
    func getStartServiceSuccess(msg: String)
    func getStartServiceFailed(msg: String)
}

class OtpPopUpVM {
    
    // MARK: Variables
    //================
    weak var delegate: OtpPopUpVMDelegate?

    // MARK: Functions
    //================
    func startService(params: JSONDictionary,loader: Bool = false) {
        WebServices.getStartService(parameters: params, success: { [weak self] (json) in
            guard let `self` = self else { return }
            let msg = json[ApiKey.message].stringValue
            self.delegate?.getStartServiceSuccess(msg:msg)
            printDebug(json)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            self.delegate?.getStartServiceFailed(msg: error.localizedDescription)
        }
    }
}
