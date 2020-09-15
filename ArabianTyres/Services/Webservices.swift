//
//  Webservices.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import Foundation
import SwiftyJSON

enum WebServices { }

extension NSError {
    
    convenience init(localizedDescription : String) {
        self.init(domain: "AppNetworkingError", code: 0, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
    
    convenience init(code : Int, localizedDescription : String) {
        self.init(domain: "AppNetworkingError", code: code, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
}

extension WebServices {
    
    // MARK:- Common POST API
    //=======================
    static func commonPostAPI(parameters: JSONDictionary,
                              endPoint: EndPoint,
                              headers: HTTPHeaders = [:],
                              loader: Bool = true,
                              success : @escaping SuccessResponse,
                              failure : @escaping FailureResponse) {
        
        AppNetworking.POST(endPoint: endPoint.path, parameters: parameters, headers: headers, loader: loader, success: { (json) in
            let code = json[ApiKey.statusCode].intValue
            let msg = json[ApiKey.message].stringValue
            
            switch code {
            case ApiCode.success: success(json)
            case ApiCode.emailNotVerify : success(json)
            default: failure(NSError(code: code, localizedDescription: msg))
            }
        }) { (error) in
            failure(error)
        }
    }
    
    // MARK:- Common PUT API
    //=======================
    static func commonPutAPI(parameters: JSONDictionary,
                             endPoint: EndPoint,
                             headers: HTTPHeaders = [:],
                             loader: Bool = true,
                             success : @escaping SuccessResponse,
                             failure : @escaping FailureResponse) {
        AppNetworking.PUT(endPoint: endPoint.path, parameters: parameters, headers: headers, loader: loader, success: { (json) in
            let code = json[ApiKey.statusCode].intValue
            let msg = json[ApiKey.message].stringValue
            switch code {
            case ApiCode.success: success(json)
            case ApiCode.tokenExpired :
                showTokenExpiredAlert()
            default: failure(NSError(code: code, localizedDescription: msg))
            }
        }) { (error) in
            failure(error)
        }
    }
    
    // MARK:- Common PUT API
       //=======================
       static func commonPatchAPI(parameters: JSONDictionary,
                                endPoint: EndPoint,
                                headers: HTTPHeaders = [:],
                                loader: Bool = false,
                                success : @escaping SuccessResponse,
                                failure : @escaping FailureResponse) {
           AppNetworking.PATCH(endPoint: endPoint.path, parameters: parameters, headers: headers, loader: loader, success: { (json) in
               let code = json[ApiKey.statusCode].intValue
               let msg = json[ApiKey.message].stringValue
               switch code {
               case ApiCode.success: success(json)
               case ApiCode.tokenExpired :
                   showTokenExpiredAlert()
               default: failure(NSError(code: code, localizedDescription: msg))
               }
           }) { (error) in
               failure(error)
           }
       }
    // MARK:- Common DELETE API
    //=======================================
    static func commonDeleteAPI(parameters: JSONDictionary,
                                endPoint: EndPoint,
                                headers: HTTPHeaders = [:],
                                loader: Bool = false,
                                success : @escaping SuccessResponse,
                                failure : @escaping FailureResponse){
        AppNetworking.DELETE(endPoint: endPoint.path, parameters: parameters, headers: headers, loader: loader, success: { (json) in
            let code = json[ApiKey.statusCode].intValue
            let msg = json[ApiKey.message].stringValue
            switch code {
            case ApiCode.success: success(json)
            case ApiCode.tokenExpired :
                showTokenExpiredAlert()
            default: failure(NSError(code: code, localizedDescription: msg))
            }
        }, failure: { (error) in
            failure(error)
            
        })
    }
    
    
    
    // MARK:- Common DELETE API With Query
    //=======================================
    static func commonDeleteAPIWithQuery(parameters: JSONDictionary,
                                         endPoint: EndPoint,
                                         headers: HTTPHeaders = [:],
                                         loader: Bool = false,
                                         success : @escaping SuccessResponse,
                                         failure : @escaping FailureResponse){
        AppNetworking.DELETEWithQuery(endPoint: endPoint.path, parameters: parameters, headers: headers, loader: loader, success: { (json) in
            let code = json[ApiKey.statusCode].intValue
            let msg = json[ApiKey.message].stringValue
            switch code {
            case ApiCode.success: success(json)
            case ApiCode.tokenExpired :
                showTokenExpiredAlert()
            default: failure(NSError(code: code, localizedDescription: msg))
            }
        }, failure: { (error) in
            failure(error)
        })
    }
    
    // MARK:- Common PUT API With Status Code
    //=======================================
    static func commonPutAPIwithStatusCode(parameters: JSONDictionary,
                                           endPoint: EndPoint,
                                           headers: HTTPHeaders = [:],
                                           loader: Bool = false,
                                           success : @escaping SuccessResponseWithStatus,
                                           failure : @escaping FailureResponse) {
        AppNetworking.PUT(endPoint: endPoint.path, parameters: parameters, headers: headers, loader: loader, success: { (json) in
            let code = json[ApiKey.statusCode].intValue
            let msg = json[ApiKey.message].stringValue
            switch code {
            case ApiCode.success: success(json, code , msg)
            case ApiCode.switchProfileInComplete : success(json, code, msg)
            case ApiCode.tokenExpired :
                showTokenExpiredAlert()
            default: failure(NSError(code: code, localizedDescription: msg))
            }
        }) { (error) in
            failure(error)
        }
    }
    
    
    // MARK:- Common GET API
    //=======================
    static func commonGetAPI(parameters: JSONDictionary = [:],
                             headers: HTTPHeaders = [:],
                             endPoint: EndPoint,
                             loader: Bool = true,
                             success : @escaping SuccessResponse,
                             failure : @escaping FailureResponse){
        
        AppNetworking.GET(endPoint: endPoint.path, parameters: parameters, headers: headers, loader: loader, success: { (json) in
            let code = json[ApiKey.statusCode].intValue
            let msg = json[ApiKey.message].stringValue
            switch code {
            case ApiCode.success: success(json)
            default: failure(NSError(code: code, localizedDescription: msg))
            }
        }) { (error) in
            failure(error)
        }
    }
    
    // MARK:- Common PUT API With Query
    //=======================================
    static func commomPutWithQuery(parameters: JSONDictionary = [:],
                                   headers: HTTPHeaders = [:],
                                   endPoint: EndPoint,
                                   loader: Bool = false,
                                   success : @escaping SuccessResponse,
                                   failure : @escaping FailureResponse){
        AppNetworking.PUTWithQuery(endPoint: endPoint.path, parameters: parameters, headers: headers, loader: loader, success: { (json) in
            let code = json[ApiKey.statusCode].intValue
            let msg = json[ApiKey.message].stringValue
            switch code {
            case ApiCode.success: success(json)
//            case ApiCode.tokenExpired :
//                showTokenExpiredAlert()
            default: failure(NSError(code: code, localizedDescription: msg))
            }
        }) { (error) in
            failure(error)
        }
    }
}


//MARK: COMMON ALERT FUNCTION
//===========================
extension WebServices {
    
    private static func showTokenExpiredAlert() {
    }
}

//MARK: WebServices
//===========================
extension WebServices{
    // MARK:- Sign Up
    //===============
    static func signUp(parameters: JSONDictionary,
                       success: @escaping SuccessResponse,
                       failure: @escaping FailureResponse) {
        
        self.commonPostAPI(parameters: parameters, endPoint: .signUp, success: { (json) in
            AppUserDefaults.save(value: json[ApiKey.data][ApiKey._id].stringValue, forKey: .userId)
            success(json)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    // MARK:- Sign In
    //===============
    static func login(parameters: JSONDictionary,
                      success: @escaping SuccessResponse,
                      failure: @escaping FailureResponse) {
        self.commonPostAPI(parameters: parameters, endPoint: .login,loader: true, success: { (json) in
            success(json)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    // MARK:- verifyForgotPasswordOTP Otp
    //=================
    static func verifyForgotPasswordOTP(parameters: JSONDictionary,
                          success: @escaping SuccessResponse,
                          failure: @escaping FailureResponse) {
        self.commonPutAPI(parameters: parameters, endPoint: .verifyforgetPasswordOtp, success: { (json) in
             success(json)
        }) { (error) -> (Void) in
             failure(error)
        }
    }
    
    
    static func socialLoginAPI(parameters: JSONDictionary,
                               success: @escaping SuccessResponse,
                               failure: @escaping FailureResponse) {
        self.commonPostAPI(parameters: parameters, endPoint: .socialLogin, loader: true, success: { (json) in
            let user = UserModel.init(json[ApiKey.data])
            UserModel.main = user
            success(json)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    // MARK:- Verify Otp
    //=================
    static func verifyOtp(parameters: JSONDictionary,
                          success: @escaping (_ model : UserModel) -> (),
                          failure: @escaping FailureResponse) {
        self.commonPostAPI(parameters: parameters, endPoint: .verifyOtp, loader: true, success: { (json) in
            let user = UserModel(json[ApiKey.data])
            UserModel.main = user
            let token = AppUserDefaults.value(forKey: .accesstoken)
            if token.isEmpty {
                let accessToken = json[ApiKey.data][ApiKey.authToken].stringValue
                AppUserDefaults.save(value: accessToken, forKey: .accesstoken)}
            AppUserDefaults.save(value: "basic", forKey: .currentUserType)
            success(user)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    // MARK:- Reset Password APi
    //=================
    static func resetPassword(parameters: JSONDictionary,
                              success: @escaping SuccessResponse,
                              failure: @escaping FailureResponse) {
        self.commonPutAPI(parameters: parameters, endPoint: .resetPassword, success: { (json) in
            success(json)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    // MARK:- Resent  Otp
    //=================
    static func resendOtp(parameters: JSONDictionary,
                         success: @escaping ResponseMessage,
                         failure: @escaping FailureResponse) {
        self.commonPostAPI(parameters: parameters, endPoint: .resendOtp,loader: true, success: { (json) in
            success(json[ApiKey.message].stringValue)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    // MARK:- SendOtp  Otp
    //=================
    static func sendOtpThroughPhone(parameters: JSONDictionary,
                         success: @escaping ResponseMessage,
                         failure: @escaping FailureResponse) {
        self.commonPostAPI(parameters: parameters, endPoint: .sendOtp,loader: true, success: { (json) in
            success(json[ApiKey.message].stringValue)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    // MARK:- ForGot password
    //=================
    static func forgotPassword(parameters: JSONDictionary,
                         success: @escaping ResponseMessage,
                         failure: @escaping FailureResponse) {
        self.commonPostAPI(parameters: parameters, endPoint: .forgetPassword,loader: true, success: { (json) in
            success(json[ApiKey.message].stringValue)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    // MARK:- ForGot password
    //=================
    static func addPhoneNumber(parameters: JSONDictionary,
                         success: @escaping ResponseMessage,
                         failure: @escaping FailureResponse) {
        self.commonPutAPI(parameters: parameters, endPoint: .addPhoneNo,loader: true, success: { (json) in
            success(json[ApiKey.message].stringValue)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    // MARK:- Logout User
    //===================
    static func logout(parameters: JSONDictionary,
                       success: @escaping ResponseMessage,
                       failure: @escaping FailureResponse) {
        self.commonPutAPI(parameters: parameters, endPoint: .logout, loader: true, success: { (json) in
            let code = json[ApiKey.statusCode].intValue
            let msg = json[ApiKey.message].stringValue
            switch code {
            case ApiCode.success:
                success(msg)
            default:
                failure(NSError(code: code, localizedDescription: msg))
            }
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    // MARK:- My Profile Api
    //=================
    static func getMyProfileData(parameters: JSONDictionary,
                                 success: @escaping SuccessResponse,
                                 failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters,endPoint: .myProfile, success: { (json) in
            let code = json[ApiKey.statusCode].intValue
            let msg = json[ApiKey.message].stringValue
            switch code {
            case ApiCode.success:
                success(json)
            default:
                failure(NSError(code: code, localizedDescription: msg))
            }
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    // MARK:- My Profile Api
    //=================
    static func sendVerificationLink(parameters: JSONDictionary,
                                 success: @escaping SuccessResponse,
                                 failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters,endPoint: .emailVerificationLink, success: { (json) in
            let code = json[ApiKey.statusCode].intValue
            let msg = json[ApiKey.message].stringValue
            switch code {
            case ApiCode.success:
                success(json)
            default:
                failure(NSError(code: code, localizedDescription: msg))
            }
        }) { (error) -> (Void) in
            failure(error)
        }
    }
}

