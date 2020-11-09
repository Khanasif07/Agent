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
            case ApiCode.notGarageReg, ApiCode.pendingGarageReg, ApiCode.acceptedGarageReg, ApiCode.rejectedGarageReg, ApiCode.garageBlocked, ApiCode.userBlocked:
                success(json)
            case ApiCode.phoneNumberUpdated, ApiCode.emailUpdated, ApiCode.phoneEmailUpdated:
                success(json)
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
            AppUserDefaults.save(value: json[ApiKey.data][ApiKey.phoneVerified].boolValue, forKey: .phoneNoVerified)
            AppUserDefaults.save(value: json[ApiKey.data][ApiKey.isGarrage].boolValue, forKey: .isGarrage)
            AppUserDefaults.save(value: json[ApiKey.data][ApiKey._id].stringValue, forKey: .userId)
            let token = AppUserDefaults.value(forKey: .accesstoken)
            if token.isEmpty {
                let accessToken = json[ApiKey.data][ApiKey.authToken].stringValue
                AppUserDefaults.save(value: accessToken, forKey: .accesstoken)}
            let currentRole =  json[ApiKey.data][ApiKey.currentRole].stringValue
            if !currentRole.isEmpty{
                AppUserDefaults.save(value: currentRole, forKey: .currentUserType)
            }
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
    
    // MARK:- My Garage Home Api
    //=================
    static func getGarageHomeData(parameters: JSONDictionary,loader: Bool = false,
                                  success: @escaping SuccessResponse,
                                  failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters,endPoint: .garageHomeServices,loader: loader,success: { (json) in
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
    
    // MARK:- Garage Registration
    //=================
    static func garageRegistration(parameters: JSONDictionary,
                                   success: @escaping ResponseMessage,
                                   failure: @escaping FailureResponse) {
        self.commonPostAPI(parameters: parameters, endPoint: .garageProfile,loader: true, success: { (json) in
            AppUserDefaults.save(value: json[ApiKey.data][ApiKey.isGarrage].boolValue, forKey: .isGarrage)
            success(json[ApiKey.message].stringValue)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    // MARK:- Switch Profile
    //=========================
    static func switchProfile(parameters: JSONDictionary,
                              success: @escaping SuccessResponse,
                              failure: @escaping FailureResponse) {
        self.commonPutAPI(parameters: parameters, endPoint: .switchProfile, success: { (json) in
            success(json)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    // MARK:- Edit Profile
    //=========================
    static func postEditProfileData(parameters: JSONDictionary,
                              success: @escaping SuccessResponse,
                              failure: @escaping FailureResponse) {
        self.commonPutAPI(parameters: parameters, endPoint: .editProfile, success: { (json) in
            success(json)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    // MARK:- Change Password
    //=========================
    static func changePasswordData(parameters: JSONDictionary,
                              success: @escaping SuccessResponse,
                              failure: @escaping FailureResponse) {
        self.commonPutAPI(parameters: parameters, endPoint: .changePassword, success: { (json) in
            success(json)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    // MARK:- Post Tyre Request
    //=========================
    static func postTyreRequest(parameters: JSONDictionary,
                                success: @escaping ResponseMessage,
                                failure: @escaping FailureResponse) {
        self.commonPostAPI(parameters: parameters, endPoint: .userTyreRequest,loader: true, success: { (json) in
            success(json[ApiKey.message].stringValue)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    // MARK:- Post Battery Request
    //=========================
    static func postBatteryRequest(parameters: JSONDictionary,
                                   success: @escaping ResponseMessage,
                                   failure: @escaping FailureResponse) {
        self.commonPostAPI(parameters: parameters, endPoint: .userBatteryRequest,loader: true, success: { (json) in
            success(json[ApiKey.message].stringValue)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    static func postOilRequest(parameters: JSONDictionary,
                               success: @escaping ResponseMessage,
                               failure: @escaping FailureResponse) {
        self.commonPostAPI(parameters: parameters, endPoint: .userOilRequest,loader: true, success: { (json) in
            success(json[ApiKey.message].stringValue)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    // MARK:- Brand Listing Data
    //=================
    static func getBrandListingData(parameters: JSONDictionary,
                                    success: @escaping SuccessResponse,
                                    failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters,endPoint: .userServiceBrands, success: { (json) in
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
    
    // MARK:- Brand Listing Data
    //=================
    static func getWidthListingData(parameters: JSONDictionary,
                                    endPoint: EndPoint,
                                    success: @escaping SuccessResponse,
                                    failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters,endPoint: endPoint, success: { (json) in
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
    
    // MARK:- Country Listing Data
    //=================
    static func getCountryListingData(parameters: JSONDictionary,
                                      success: @escaping SuccessResponse,
                                      failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters,endPoint: .userServiceCountry, success: { (json) in
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
    
    // MARK:- Make Listing Data
    //=================
    static func getMakeListingData(parameters: JSONDictionary,
                                   success: @escaping SuccessResponse,
                                   failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters,endPoint: .userServiceMake, success: { (json) in
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
    
    // MARK:- Model Listing Data
    //=================
    static func getModelListingData(parameters: JSONDictionary,
                                    success: @escaping SuccessResponse,
                                    failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters,endPoint: .userServiceModel, success: { (json) in
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
    
    
    // MARK:- Complete Garage Profile
    //==============================
    static func completeGarageProfile(parameters: JSONDictionary,
                                      success: @escaping ResponseMessage,
                                      failure: @escaping FailureResponse) {
        self.commonPutAPI(parameters: parameters, endPoint: .completeGarageProfile, success: { (json) in
            let msg = json[ApiKey.message].stringValue
            let currentRole =  json[ApiKey.data][ApiKey.currentRole].stringValue
            if !currentRole.isEmpty{
                AppUserDefaults.save(value: currentRole, forKey: .currentUserType)
            }
            success(msg)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    static func userServiceList(parameters: JSONDictionary,
                                success: @escaping SuccessResponse,
                                failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters,endPoint: .servicesList, success: { (json) in
            success(json)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    // MARK:- Tyre Size Listing Data
    //=================
    static func getTyreSizeListingData(parameters: JSONDictionary,
                                       success: @escaping SuccessResponse,
                                       failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters,endPoint: .userServiceTyreSize, success: { (json) in
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
    
    // MARK:- UserMyRequest Listing Data
    //=================
    static func getGarageRequestListing(parameters: JSONDictionary,
                                        loader: Bool,
                                        success: @escaping SuccessResponse,
                                        failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters,endPoint: .garageRequest, loader: loader, success: { (json) in
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
    
    // MARK:- Tyre Size Listing Data
    //=================
    static func getGarageRequestDetail(parameters: JSONDictionary,
                                       success: @escaping SuccessResponse,
                                       failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters,endPoint: .garageRequestDetail, success: { (json) in
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
    
    
    // MARK:- Make Listing Data
    //=================
    static func getUserMyRequestData(parameters: JSONDictionary, loader: Bool,
                                     success: @escaping SuccessResponse,
                                     failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters,endPoint: .userMyServiceRequests, loader:loader, success: { (json) in
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
    
    // MARK:- UserMyRequestDetail Data
    //=================
    static func getUserMyRequestDetailData(parameters: JSONDictionary,
                                           success: @escaping SuccessResponse,
                                           failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters,endPoint: .userMyServiceRequestsDetail, success: { (json) in
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
    
    // MARK:- UserMyRequestDetail Data
    //=================
    static func cancelUserMyRequestDetailData(parameters: JSONDictionary,
                                           success: @escaping SuccessResponse,
                                           failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters,endPoint: .userMyServiceRequestsCancel, success: { (json) in
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
    
    static func cancelGarageRequest(parameters: JSONDictionary,
                                           success: @escaping SuccessResponse,
                                           failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters,endPoint: .garageRejectRequest, success: { (json) in
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
    
    static func postPlaceBidData(parameters: JSONDictionary,
                                 success: @escaping ResponseMessage,
                                 failure: @escaping FailureResponse) {
          self.commonPostAPI(parameters: parameters, endPoint: .userPlaceBid,loader: true, success: { (json) in
              success(json[ApiKey.message].stringValue)
          }) { (error) -> (Void) in
              failure(error)
          }
      }
    
    //MARK:- User Bids
    static func getUserBids(parameters: JSONDictionary,
                              loader: Bool = false,
                                           success: @escaping SuccessResponse,
                                           failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters,endPoint: .userBids, loader: loader, success: { (json) in
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
    
    //MARK:- User Bids Detail
       static func getOfferDetailData(parameters: JSONDictionary,
                                              success: @escaping SuccessResponse,
                                              failure: @escaping FailureResponse) {
           self.commonGetAPI(parameters: parameters,endPoint: .userBidDetail, success: { (json) in
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
    
    
    //MARK:- User Accept Bids Detail
    static func acceptUserBidData(parameters: JSONDictionary,
                                  success: @escaping SuccessResponse,
                                  failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters,endPoint: .userBidAccept, success: { (json) in
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
    
    //MARK:- User Accept Bids Detail
    static func rejectUserBidData(parameters: JSONDictionary,
                                  success: @escaping SuccessResponse,
                                  failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters,endPoint: .userBidReject, success: { (json) in
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
    
    
    //MARK:- User Accept Bids Detail
       static func bidCancelByUser(parameters: JSONDictionary,
                                     success: @escaping SuccessResponse,
                                     failure: @escaping FailureResponse) {
           self.commonGetAPI(parameters: parameters,endPoint: .userCancelBid, success: { (json) in
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

    // MARK:- Edit Placed Bid Data
    //=================
    static func editPlacedBidData(parameters: JSONDictionary,
                                        success: @escaping SuccessResponse,
                                        failure: @escaping FailureResponse) {
        self.commonPutAPI(parameters: parameters, endPoint: .garageEditPlacedBid, success: { (json) in
            success(json)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    // MARK:- Accept Edited  Bid Data
    //=================
    static func acceptEditedBid(parameters: JSONDictionary,
                                        success: @escaping SuccessResponse,
                                        failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters, endPoint: .acceptEditedBid, success: { (json) in
            success(json)
        }) { (error) -> (Void) in
            failure(error)
        }
    }

    
    static func userRequestResend(parameters: JSONDictionary,loader: Bool = false,
                                  success: @escaping SuccessResponse,
                                  failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters,endPoint: .resendRequest, success: { (json) in
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
    
    static func editUserProfileApi(parameters: JSONDictionary,loader: Bool = false,
                                        success: @escaping SuccessResponse,
                                        failure: @escaping FailureResponse) {
        self.commonPutAPI(parameters: parameters, endPoint: .editProfile, success: { (json) in
            success(json)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    static func editNumberWithOtpApi(parameters: JSONDictionary,loader: Bool = false,
                                        success: @escaping SuccessResponse,
                                        failure: @escaping FailureResponse) {
        self.commonPutAPI(parameters: parameters, endPoint: .verifyPhoneNumber, success: { (json) in
            success(json)
        }) { (error) -> (Void) in
            failure(error)
        }
    }

    //MARK:- Submit Rating Detail
    static func postRatingData(parameters: JSONDictionary,loader: Bool = false,
                                success: @escaping SuccessResponse,
                                failure: @escaping FailureResponse) {
          self.commonPostAPI(parameters: parameters, endPoint: .rating,loader: loader, success: { (json) in
              success(json)
          }) { (error) -> (Void) in
              failure(error)
          }
      }
    
    
    //MARK:- Get review Listing
       static func getReviewListingData(parameters: JSONDictionary,loader: Bool = false,
                                   success: @escaping SuccessResponse,
                                   failure: @escaping FailureResponse) {
             self.commonGetAPI(parameters: parameters, endPoint: .rating,loader: loader, success: { (json) in
                 success(json)
             }) { (error) -> (Void) in
                 failure(error)
             }
    }
    
    //MARK:- Submit Rating Detail
    static func getChatData(parameters: JSONDictionary,loader: Bool = false,
                                success: @escaping SuccessResponse,
                                failure: @escaping FailureResponse) {
          self.commonGetAPI(parameters: parameters, endPoint: .chatData,loader: loader, success: { (json) in
              success(json)
          }) { (error) -> (Void) in
              failure(error)
          }
      }
    
    //MARK:- Submit Rating Detail
    static func getBookedRequestData(parameters: JSONDictionary,loader: Bool = false,
                                success: @escaping SuccessResponse,
                                failure: @escaping FailureResponse) {
          self.commonGetAPI(parameters: parameters, endPoint: .bookedRequest,loader: loader, success: { (json) in
              success(json)
          }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    //MARK:- Submit Rating Detail
    static func getBookedRequestDetail(parameters: JSONDictionary,loader: Bool = false,
                                       success: @escaping SuccessResponse,
                                       failure: @escaping FailureResponse) {
        self.commonGetAPI(parameters: parameters, endPoint: .bookedRequestDetail,loader: loader, success: { (json) in
            success(json)
        }) { (error) -> (Void) in
            failure(error)
        }
    }
    
    //MARK:- Start Service Api
       static func getStartService(parameters: JSONDictionary,loader: Bool = false,
                                          success: @escaping SuccessResponse,
                                          failure: @escaping FailureResponse) {
           self.commonGetAPI(parameters: parameters, endPoint: .startService,loader: loader, success: { (json) in
               success(json)
           }) { (error) -> (Void) in
               failure(error)
           }
       }
}
