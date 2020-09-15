//
//  AppNetworking.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON


typealias JSONDictionary = [String : Any]
typealias JSONDictionaryArray = [JSONDictionary]
typealias HTTPHeaders = [String:String]
typealias SuccessResponse = (_ json : JSON) -> ()
typealias SuccessResponseWithStatus = (_ json : JSON,_ statusCode:Int,_ message:String) -> ()
typealias FailureResponse = (Error) -> (Void)
typealias ResponseMessage = (_ message : String) -> ()
typealias LogoutSuccess = (_ message: String) -> ()

enum AppNetworking {
    
    static var timeOutInterval = TimeInterval(30)
    
    private static func executeRequest(_ request: NSMutableURLRequest, _ success: @escaping (JSON) -> Void, _ failure: @escaping (Error) -> Void) {
        let session = URLSession.shared
        
        session.configuration.timeoutIntervalForRequest = timeOutInterval
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            if (error == nil) {
                
                do {
                    if let jsonData = data {
                        
                        if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] {
                            
                            DispatchQueue.main.async(execute: { () -> Void in
                                printDebug("Response : ========================>\n\(jsonDataDict)")
                                if let code = jsonDataDict[ApiKey.statusCode] as? Int,code == 498 || code == 440 || code == 403{
                                    AppRouter.showAlert(alertMessage: "Alert!",isHitLogOutApi: true)
                                }else{
                                    success(JSON(jsonDataDict))
                                }
                            })
                        }
                        
                    }else{
                        let error = NSError.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"No data found"])
                        failure(error)
                    }
                } catch let err as NSError {
                    
                    let responseString = String(data: data!, encoding: .utf8)
                    printDebug("responseString = \(responseString ?? "")")
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        failure(err)
                    })
                }
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    printDebug(httpResponse)
                }
                if let err = error {
                    DispatchQueue.main.async(execute: { () -> Void in
                        failure(err)
                    })
                }else{
                    let error = NSError.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Something went wrong"])
                    failure(error)
                }
            }
        })
        
        dataTask.resume()
    }
    
    fileprivate static func checkRefereshTokenAndExecute(_ request: NSMutableURLRequest, _ loader: Bool, _ success: @escaping (JSON) -> Void, _ failure: @escaping (Error) -> Void) {
        executeRequest(request, { (json) in
            
            if loader { CommonFunctions.hideActivityLoader() }
            //            let code = json[ApiKey.code].intValue
            //            if code == ApiCode.tokenExpired {
            //                WebServices.refreshToken(success: { (json) in
            //                    executeRequest(request, success, failure)
            //                }, failure: failure)
            //            }else{
            success(json)
            //            }
        }) { (err) in
            if loader { CommonFunctions.hideActivityLoader() }
            let code = (err as NSError).code
            switch code {
            case ApiCode.logoutSuccess,ApiCode.tokenExpired,ApiCode.sessionExpired :
                AppRouter.showAlert(alertMessage: err.localizedDescription)
                return
            default:
                break
            }
            failure(err)
        }
    }
    
    private static func REQUEST(withUrl url : URL?,method : String,postData : Data?,header : [String:String],loader : Bool, success : @escaping (JSON) -> Void, failure : @escaping (Error) -> Void) {
        
        guard let url = url else {
            let error = NSError.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Url or parameters not valid"])
            failure(error)
            return
        }
        printDebug("URL =======================>\n\(url)\n")
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: timeOutInterval)
        request.httpMethod = method
        var updatedHeaders = header
        //        updatedHeaders[ApiKey.Authorization] =  "Basic YWRtaW46MTIzNA=="
        
        if isUserLoggedin {
            let strToken: String = AppUserDefaults.value(forKey: .accesstoken).stringValue
            if !strToken.isEmpty {
                updatedHeaders[ApiKey.authorization] =  "Bearer \(strToken)"
            }
        }
        request.allHTTPHeaderFields = updatedHeaders
        
        request.httpBody = postData
        if loader { CommonFunctions.showActivityLoader() }
        
        checkRefereshTokenAndExecute(request, loader, success, failure)
        
    }
    
    static func GET(endPoint : String,
                    parameters : [String : Any] = [:],
                    headers : HTTPHeaders = [:],
                    loader : Bool = true,
                    success : @escaping (JSON) -> Void,
                    failure : @escaping (Error) -> Void) {
        
        guard let urlString = (endPoint + "?" + encodeParamaters(params: parameters)).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else{
            return
        }
        printDebug("============ \n Parameters are =======> \n\n \(parameters) \n")
        let uri = URL(string: urlString)
        
        REQUEST(withUrl: uri,
                method: "GET",
                postData : nil,
                header: headers,
                loader: loader,
                success: success,
                failure: failure)
    }
    
    static func PUTWithQuery(endPoint : String,
                             parameters : [String : Any] = [:],
                             headers : HTTPHeaders = [:],
                             loader : Bool = true,
                             success : @escaping (JSON) -> Void,
                             failure : @escaping (Error) -> Void) {
        
        guard let urlString = (endPoint + "?" + encodeParamaters(params: parameters)).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else{
            return
        }
        printDebug("============ \n Parameters are =======> \n\n \(parameters) \n")
        let uri = URL(string: urlString)
        
        REQUEST(withUrl: uri,
                method: "PUT",
                postData : nil,
                header: headers,
                loader: loader,
                success: success,
                failure: failure)
        
    }
    
    static func DELETEWithQuery(endPoint : String,
                                parameters : [String : Any] = [:],
                                headers : HTTPHeaders = [:],
                                loader : Bool = true,
                                success : @escaping (JSON) -> Void,
                                failure : @escaping (Error) -> Void) {
        
        guard let urlString = (endPoint + "?" + encodeParamaters(params: parameters)).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else{
            return
        }
        printDebug("============ \n Parameters are =======> \n\n \(parameters) \n")
        let uri = URL(string: urlString)
        
        REQUEST(withUrl: uri,
                method: "DELETE",
                postData : nil,
                header: headers,
                loader: loader,
                success: success,
                failure: failure)
        
    }
    static func POST(endPoint : String,
                     parameters : [String : Any] = [:],
                     headers : HTTPHeaders = [:],
                     loader : Bool = true,
                     success : @escaping (JSON) -> Void,
                     failure : @escaping (Error) -> Void) {
        
        let uri = URL(string: endPoint)
        let postData = try? JSONSerialization.data(withJSONObject: parameters)
        
        //        let postData = encodeParamaters(params: parameters).data(using: String.Encoding.utf8)
        var updatedHeaders = headers
        updatedHeaders["Content-Type"] =  "application/json"
        updatedHeaders["accept"] =  "application/json"
        printDebug("============ \n Parameters are =======> \n\n \(parameters) \n")
        
        REQUEST(withUrl: uri,
                method: "POST",
                postData : postData,
                header: updatedHeaders,
                loader: loader,
                success: success,
                failure: failure)
        
    }
    
    static func POSTWithImage(endPoint : String,
                              parameters : [String : Any] = [:],
                              image : [String : UIImage] = [:],
                              headers : HTTPHeaders = [:],
                              loader : Bool = true,
                              success : @escaping (JSON) -> Void,
                              failure : @escaping (Error) -> Void) {
        
        printDebug("============ \n Parameters are =======> \n\n \(parameters) \n")
        
        let uri = URL(string: endPoint)
        
        let boundary = generateBoundary()
        let postData = createDataBody(withParameters: parameters, media: image, boundary: boundary)
        var updatedHeader = headers
        
        updatedHeader["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        
        REQUEST(withUrl: uri,
                method: "POST",
                postData : postData,
                header: updatedHeader,
                loader: loader,
                success: success,
                failure: failure)
        
    }
    static func PUT(endPoint : String,
                    parameters : [String : Any] = [:],
                    headers : HTTPHeaders = [:],
                    loader : Bool = true,
                    success : @escaping (JSON) -> Void,
                    failure : @escaping (Error) -> Void) {
        
        
        let uri = URL(string: endPoint)
        
        //       let postData = encodeParamaters(params: parameters).data(using: String.Encoding.utf8)
        //        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
        //            return
        //        }
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters)
        var updatedHeaders = headers
        updatedHeaders["Content-Type"] =  "application/json"
        updatedHeaders["accept"] =  "application/json"
        printDebug("============ \n Parameters are =======> \n\n \(parameters) \n ")
        
        REQUEST(withUrl: uri,
                method: "PUT",
                postData : postData,
                header: updatedHeaders,
                loader: loader,
                success: success,
                failure: failure)
        
    }
    
    static func PATCH(endPoint : String,
                    parameters : [String : Any] = [:],
                    headers : HTTPHeaders = [:],
                    loader : Bool = true,
                    success : @escaping (JSON) -> Void,
                    failure : @escaping (Error) -> Void) {
        
        
        let uri = URL(string: endPoint)
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters)
        var updatedHeaders = headers
        updatedHeaders["Content-Type"] =  "application/json"
        updatedHeaders["accept"] =  "application/json"
        printDebug("============ \n Parameters are =======> \n\n \(parameters) \n ")
        
        REQUEST(withUrl: uri,
                method: "PATCH",
                postData : postData,
                header: updatedHeaders,
                loader: loader,
                success: success,
                failure: failure)
    }
    
    static func DELETE(endPoint : String,
                       parameters : [String : Any] = [:],
                       headers : HTTPHeaders = [:],
                       loader : Bool = true,
                       success : @escaping (JSON) -> Void,
                       failure : @escaping (Error) -> Void) {
        
        printDebug("============ \n Parameters are =======> \n\n \(parameters) \n ")
        
        let uri = URL(string: endPoint)
        
        let postData = encodeParamaters(params: parameters).data(using: String.Encoding.utf8)
        
        REQUEST(withUrl: uri,
                method: "DELETE",
                postData : postData,
                header: headers,
                loader: loader,
                success: success,
                failure: failure)
        
    }
    
    static private func encodeParamaters(params : [String : Any]) -> String {
        
        var result = ""
        
        for key in params.keys {
            
            result.append(key+"=\(params[key] ?? "")&")
            
        }
        
        if !result.isEmpty {
            result.remove(at: result.index(before: result.endIndex))
        }
        
        return result
    }
    
    static func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    static func createDataBody(withParameters params: [String:Any]?, media: [String:UIImage]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value)\(lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media.keys {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo)\"; filename=\" image.jpg\"\(lineBreak)")
                body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)")
                
                let data = media[photo]!.jpegData(compressionQuality:0.4) ?? Data()
                body.append(data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
}


extension Data {
    
    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.
    
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
