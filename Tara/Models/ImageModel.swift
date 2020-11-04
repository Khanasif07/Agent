//
//  ImageModel.swift
//  ArabianTyres
//
//  Created by Admin on 16/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import SwiftyJSON
import Foundation

struct ImageModel {
    
    var url : String
    var type : String = ""
    var image = UIImage()
    
    init(url: String, type: String,image: UIImage = UIImage()) {
        self.url = url
        self.type = type
        self.image = image
    }
    
    init(){
        self.url = ""
        self.type = ""
        self.image = UIImage()
    }
    
    init(withJSON json : JSON){
        self.url = json[ApiKey.url].stringValue.isEmpty ? json.stringValue : json[ApiKey.url].stringValue
        self.type = json[ApiKey.mediaType].stringValue
        
    }
    
    func dictionary() -> [String:Any]{
        
        var details = [String:Any]()
        details[ApiKey.url] = self.url
        details[ApiKey.type] = self.type
        return details
        
    }
}
