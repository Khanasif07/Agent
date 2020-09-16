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
    var mediaType : String = ""
    var image = UIImage()
    
    init(url: String, mediaType: String,image: UIImage = UIImage()) {
        self.url = url
        self.mediaType = mediaType
        self.image = image
    }
    
    init(){
        self.url = ""
        self.mediaType = ""
        self.image = UIImage()
    }
    
    init(withJSON json : JSON){
        self.url = json[ApiKey.url].stringValue.isEmpty ? json.stringValue : json[ApiKey.url].stringValue
        self.mediaType = json[ApiKey.mediaType].stringValue
        
    }
    
    func dictionary() -> [String:Any]{
        
        var details = [String:Any]()
        details[ApiKey.url] = self.url
        details[ApiKey.mediaType] = self.mediaType
        return details
        
    }
}
