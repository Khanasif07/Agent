//
//  Webservice+EndPoints.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

//API path: http://arabiantyersdevapi.appskeeper.com/api/v1/
//Swagger Url: http://arabiantyersdevapi.appskeeper.com/api-docs/swagger

var firebase_push_Url = "https://fcm.googleapis.com/fcm/send"
var baseUrl: String {
    #if ENV_DEV
    return "https://arabiantyersdevapi.appskeeper.com/api/v1/"
    #elseif ENV_STAG
    return "https://arabiantyersstgapi.appskeeper.com/api/v1/"
    #elseif ENV_QA
    return "https://arabiantyersqaapi.appskeeper.com/api/v1/"
    #elseif ENV_PROD
    return "https://arabiantyersstgapi.appskeeper.com/api/v1/"
    #else
    return ""
    #endif
}

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
        case editProfile = "user/profile"
        case changePassword = "user/changePassword"
        case verifyPhoneNumber = "user/verifyPhoneNumber"
        case rating = "user/rating"
        case chatData = "user/chatData"
        case bookedRequest = "user/services/bookedRequests"
        case bookedRequestDetail =  "user/services/bookedRequestDetails"
        case startService = "user/services/startService"
        case acceptEditedBid =  "user/bids/acceptEditedBid"
        case serviceStatus = "user/services/serviceStatus"
        case garageCompletedServices = "user/services/garageCompletedServices"
        
        case garageCompletedServiceDetail = "user/services/garageCompletedServiceDetail"
        case reportReview = "user/services/reportReview"
        case userServiceDetails = "user/services/userServiceDetails"
        case markCarReceived = "user/services/markCarReceived"
        case sendOtpToStartService = "user/services/sendOtpToStartService"
        case acceptRejectEditedBid = "user/bids/acceptRejectEditedBid"
        case userQuery = "user/query"
        case adminId = "user/adminId"
        case userServiceHistory = "user/services/userServiceHistory"
        case userServiceHistoryDetail = "user/services/userServiceHistoryDetails"
        case pushNotification = ""
        
        //MARK:-Notifications
        case userNotifications = "user/notifications"
        case userNotificationMarkRead = "user/notifications/markRead"

        var path : String {
            let url = baseUrl
            return url + self.rawValue
        }
        
        var settingsPath: String {
            let url = settingsUrl
            return url + self.rawValue
        }
        
        var pushPath: String {
            let url = firebase_push_Url
            return url + self.rawValue
        }
    }
}
