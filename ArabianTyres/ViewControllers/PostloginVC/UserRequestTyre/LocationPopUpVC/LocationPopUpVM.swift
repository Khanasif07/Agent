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
    func postBatteryRequestSuccess(message: String)
    func postBatteryRequestFailed(error:String)
}

extension LocationPopUpVMDelegate {
    func postTyreRequestSuccess(message: String){}
    func postTyreRequestFailed(error:String){}
    func postBatteryRequestSuccess(message: String){}
    func postBatteryRequestFailed(error:String){}
}


class LocationPopUpVM{
    
    //MARK:- Variables
    //================
    
    weak var delegate: LocationPopUpVMDelegate?
    
    //MARK:- Functions
    func postTyreRequest(dict: JSONDictionary){
        WebServices.postTyreRequest(parameters: dict, success: { (json) in
            self.delegate?.postTyreRequestSuccess(message: "")
        }) { (error) -> (Void) in
            self.delegate?.postTyreRequestFailed(error: error.localizedDescription)
        }
    }
    
    //MARK:- Functions
    //Function for verify OTP
    func postBatteryRequest(dict: JSONDictionary){
        WebServices.postBatteryRequest(parameters: dict, success: { (json) in
            self.delegate?.postBatteryRequestSuccess(message: "")
        }) { (error) -> (Void) in
            self.delegate?.postBatteryRequestFailed(error: error.localizedDescription)
        }
    }
}
