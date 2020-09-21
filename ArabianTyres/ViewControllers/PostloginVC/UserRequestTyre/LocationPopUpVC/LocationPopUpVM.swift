//
//  LocationPopUpVM.swift
//  ArabianTyres
//
//  Created by Admin on 21/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol LocationPopUpVMDelegate: class {
    func postTyreRequestSuccess(message: String)
    func postTyreRequestFailed(error:String)
}


class LocationPopUpVM{
    
    //MARK:- Variables
    //================
   
    weak var delegate: LocationPopUpVMDelegate?
    
    //MARK:- Functions
    //Function for verify OTP
    func postTyreRequest(dict: JSONDictionary){
        WebServices.postTyreRequest(parameters: dict, success: { (json) in
            self.delegate?.postTyreRequestSuccess(message: "")
            }) { (error) -> (Void) in
                self.delegate?.postTyreRequestFailed(error: error.localizedDescription)
            }
    }
}
