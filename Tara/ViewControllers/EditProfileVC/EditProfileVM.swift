//
//  EditProfileVM.swift
//  Tara
//
//  Created by Arvind on 01/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol EditProfileVMDelegate: class {
    func editProfileSuccess(message: String)
    func editProfileFailed(error:String)
}

class EditProfileVM{
    
    //MARK:- Variables
    //================
   
    weak var delegate: EditProfileVMDelegate?
    
    //MARK:- Functions
    
    func setProfile(params: JSONDictionary){
        WebServices.editUserProfileApi(parameters: params, success: { (json) in
            self.delegate?.editProfileSuccess(message: json[ApiKey.message].stringValue)
        }) { (error) -> (Void) in
            self.delegate?.editProfileFailed(error: error.localizedDescription)
        }
    }
}
