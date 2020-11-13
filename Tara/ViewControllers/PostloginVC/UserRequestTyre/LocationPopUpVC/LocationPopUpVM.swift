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
    func postOilRequestSuccess(message: String)
    func postOilRequestFailed(error:String)
    func getAdminIdSuccess(id: String, name: String, image: String)
    func getAdminIdFailed(error:String)
    
}

extension LocationPopUpVMDelegate {
    func postTyreRequestSuccess(message: String){}
    func postTyreRequestFailed(error:String){}
    func postBatteryRequestSuccess(message: String){}
    func postBatteryRequestFailed(error:String){}
    func postOilRequestSuccess(message: String){}
    func postOilRequestFailed(error:String){}
    func getAdminIdSuccess(id: String, name: String, image: String){}
    func getAdminIdFailed(error:String){}

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
    
    func postBatteryRequest(dict: JSONDictionary){
        WebServices.postBatteryRequest(parameters: dict, success: { (json) in
            self.delegate?.postBatteryRequestSuccess(message: "")
        }) { (error) -> (Void) in
            self.delegate?.postBatteryRequestFailed(error: error.localizedDescription)
        }
    }
    
    func postOilRequest(dict: JSONDictionary){
        WebServices.postOilRequest(parameters: dict, success: { (json) in
            self.delegate?.postOilRequestSuccess(message: "")
        }) { (error) -> (Void) in
            self.delegate?.postOilRequestFailed(error: error.localizedDescription)
        }
    }
    
    
    func getAdminId(dict: JSONDictionary,loader: Bool){
        WebServices.getAdminId(parameters: dict,loader: loader, success: { (json) in
     
            let addminId = json[ApiKey.data][ApiKey.id].stringValue
            let name = json[ApiKey.data][ApiKey.name].stringValue
            let image = json[ApiKey.data][ApiKey.image].stringValue
            
            self.delegate?.getAdminIdSuccess(id: addminId, name: name,image: image)
        }) { (error) -> (Void) in
            self.delegate?.getAdminIdFailed(error: error.localizedDescription)
        }
    }
}
