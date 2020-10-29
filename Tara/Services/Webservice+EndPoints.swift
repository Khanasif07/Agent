//
//  Webservice+EndPoints.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

//let baseUrl = "http://arabiantyersdevapi.appskeeper.com/api/v1/"//dev url
//let baseUrl = "http://arabiantyersastgapi.appskeeper.com/api/v1/"//stag url
let baseUrl = "http://arabiantyersqaapi.appskeeper.com/api/v1/" //qa url

//API path: http://arabiantyersdevapi.appskeeper.com/api/v1/
//Swagger Url: http://arabiantyersdevapi.appskeeper.com/api-docs/swagger

let settingsUrl = ""

extension WebServices {
    
    enum EndPoint : String {
        case login = "user/login"
        case signUp = "user/signup"
        case verifyOtp = "user/verifyOtp"
        case sendOtp = "user/sendOtp"
        case resendOtp = "user/resendOtp"
        case forgetPassword = "user/forgotPassword"
        case resetPassword =  "user/resetpassword"
        case verifyforgetPasswordOtp = "user/verifyforgetPasswordOtp"
        case logout = "user/logout"
        case socialLogin = "user/socialLogin"
        case socialSignup = "user/socialSignup"
        case myProfile = "user/myProfile"
        case emailVerificationLink = "user/emailVerificationLink"
        case addPhoneNo = "user/addPhoneNo"
        case garageProfile = "user/garrageProfile"
        case switchProfile = "user/switchProfile"
        case userTyreRequest = "user/services/tyre-request"
        case userBatteryRequest = "user/services/battery-request"
        case userOilRequest = "user/services/oil-request"
        case userServiceBrands = "user/services/brands"
        case completeGarageProfile = "user/completeGarrageProfile"
        case servicesList = "user/services/list"
        case userServiceCountry = "user/services/countryList"
        case userServiceMake = "user/services/makeList"
        case userServiceModel = "user/services/modelList"
        case userServiceTyreSize = "user/services/tyreList"
        case userServiceWidth = "user/services/width"
        case userServiceProfile = "user/services/Profile"
        case userServicerimSize = "user/services/rimSize"
        case garageRequest = "user/services/garageRequests"
        case userMyServiceRequests = "user/services/myServiceRequests"
        case garageRequestDetail = "user/services/garageRequestDetail"
        case userMyServiceRequestsDetail = "user/services/requestDetail"
        case userMyServiceRequestsCancel = "user/services/userCancelRequest"
        case garageRejectRequest = "user/services/garageRejectRequest"
        case userPlaceBid = "user/bids/placeBid"
        case userBids = "user/bids"
        case userBidDetail = "user/bids/details"
        case userBidAccept = "user/bids/accept"
        case userBidReject = "user/bids/reject"
        case userCancelBid = "user/bids/cancel"
        case garageEditPlacedBid = "user/bids/edit"
        case resendRequest = "user/services/resendRequest"
        case garageHomeServices  = "user/services/dashboard"
        
        
        var path : String {
            let url = baseUrl
            return url + self.rawValue
        }
        
        var settingsPath: String {
            let url = settingsUrl
            return url + self.rawValue
        }
    }
}
