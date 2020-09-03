//
//  ApiKeys.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

//MARK:- Api Keys
//=======================
enum ApiKey {
    
    static var status: String { return "status" }
    static var statusCode: String { return "statusCode" }
    static var code: String { return "CODE" }
    static var result: String { return "result" }
    static var message: String { return "message" }
    static var Authorization: String { return "Authorization" }
    static var contentType: String { return "Content-Type" }
    static var data: String { return "data" }
    static var accessToken: String { return "access_token"}

    static var name : String {return "name"}
    static var nickName : String {return "nick_name"}
    static var email : String {return "email"}
    static var password : String {return "password"}
    static var countryCode : String {return "countryCode"}
    static var phoneNo : String {return "phoneNo"}
    static var image : String {return "image"}

    static var _id : String {return "_id"}
    static var otp : String {return "otp"}
    static var platform : String {return "platform"}
    static var device : String {return "device"}
    static var token : String {return "token"}
    static var resetToken : String {return "resetToken"}

    static var authToken : String {return "authToken"}
    static var createdAt : String {return "createdAt"}
    static var emailVerified : String {return "emailVerified"}
    static var isDelete : String {return "isDelete"}
    static var language : String {return "language"}
    static var otpExpiry : String {return "otpExpiry"}
    static var phoneVerified : String {return "phoneVerified"}
    static var updatedAt : String {return "updatedAt"}

    static var next : String {return "next"}
    static var page : String {return "page"}
    static var limit : String {return "limit"}
    static var description : String {return "description"}
    static var subCategory : String {return "subCategory"}
    static var category : String {return "category"}
    static var onlyMyExpertise :  String {return "onlyMyExpertise"}
    
    static var search : String {return "search"}
    static var isTeacher : String {return "isTeacher"}
    static var isStudent : String {return "isStudent"}
    static var dob : String {return "dob"}
    static var education : String {return "education"}
    static var bio : String {return "bio"}
    static var role : String {return "role"}
    static var totalExperience : String {return "totalExperience"}
    static var categoryId : String {return "categoryId"}
    static var parentId : String {return "parentId"}
    static var years : String {return "years"}
    static var expertise : String {return "expertise"}
    static var socialType : String {return "socialType"}
    static var socialId : String {return "socialId"}
    static var title : String { return "title"}
    static var subCategoryId : String { return "subCategoryId"}
    static var level : String { return "level"}
    static var url : String { return "url"}
    static var duration : String { return "duration"}
    static var previewUrl : String { return "previewUrl"}
    static var previewDuration : String { return "previewDuration"}
    static var thumbnail : String { return "thumbnail"}
    static var creditId : String { return "creditId"}
    static var oneDayAcessCredits : String { return "oneDayAcessCredits"}
    static var weeklyAcessCredits : String { return "weeklyAcessCredits"}
    static var biweeklyAcessCredits : String { return "biweeklyAcessCredits"}
    static var monthlyAcessCredits : String { return "monthlyAcessCredits"}
    static var currentRole : String { return "currentRole" }
    static var oldPassword : String { return "oldPassword" }
    static var newPassword : String { return "newPassword" }
    static var sweatLevel: String{ return "sweatLevel"}
    static var playlistId: String{ return "playlistId"}
    static var videoId: String{ return "videoId"}
    static var type: String{ return "type"}
    static var teacherProfile: String { return "teacherProfile"}
    static var studentProfile: String { return "studentProfile"}
    static var videoHostingCreditId: String { return "videoHostingCreditId"}
    static var credits: String{ return "credits"}
     static var previewType: String{ return "previewType"}
    static var isLogin: String{ return "isLogin"}
    static var minvideoCount: String{ return "minvideoCount"}
    
    static var isAlreadyRated: String { return " isAlreadyRated "}
    static var isvideoPurchased: String { return " isvideoPurchased"}
    static var videosPurchased: String { return "videosPurchased"}
    static var creditPoints: String { return "creditPoints"}
    static var interests: String { return "interests"}
    static var reportedCount: String { return "reportedCount"}
    static var videosOnPlatform: String { return "videosOnPlatform"}
    static var reviewCount: String { return "reviewCount"}
    static var rating: String { return "rating"}
    static var categoryID: String { return "categoryId"}
    static var review: String { return "review"}
    static var length: String{ return "length"}
    static var notificationId: String{ return "notificationId"}
    static var membershipCredits: String{ return "membershipCredits"}
    static var isSubscribed: String{ return "isSubscribed"}
    static var accountVerified: String{ return "accountVerified"}
    
    static var subcategoryID: String { return "subcategoryId"}
    static var totalvideoCount: String { return "totalvideoCount"}
    static var totalcategoryCount: String { return "totalcategoryCount"}
    static var totalteacherCount: String { return "totalteacherCount"}
    static var categoryData: String { return "categoryData"}
    static var teacherData: String { return "teacherData"}
    static var videoData: String { return "videoData"}
    static var creatorType: String{ return "creatorType"}
    static var videoDatumDescription: String{ return "description"}
    static var views: String{ return "views"}
    static var previewURL: String{ return "previewUrl"}
    static var creditDetails: String{ return "creditDetails"}
    static var categoryName: String{ return "categoryName"}
    static var subcategoryName: String{ return "subcategoryName"}
    static var isOwner: String{ return "isOwner"}
    static var id: String{ return "id"}
    static var availabilityEndDate: String{ return "availabilityEndDate"}
    static var subscriptionEndDate: String{ return "subscriptionEndDate"}
    
    static var progress : String { return "progress" }
    static var error : String { return "error" }
    static var teacherId : String {return "teacherId"}
    static var startDate : String {return "startDate"}
    static var endDate : String {return "endDate"}
    static var reason : String{ return "reason"}
    static var comments : String{ return "comments"}
    
    static var searchType : String{ return "searchType"}
    static var referenceId : String{ return "referenceId"}
    static var searched : String{ return "searched"}
    
    static var frontDocument : String{ return "frontDocument"}
    static var backDocument : String{ return "backDocument"}
    
    static var subcategoryFilter : String{ return "subcategoryFilter"}
    static var creditPointFilter : String{ return "creditPointFilter"}
    static var ratingFilter : String{ return "ratingFilter"}
    static var dateFilter : String{ return "dateFilter"}
    static var videosBought : String{ return "videosBought"}
    static var creditSort : String{ return "creditSort"}
    static var creditFilter : String{ return "creditFilter"}
    static var sortBy : String{ return "sortBy"}
    static var filterBy: String{ return "filterBy"}
    static var allCategoryId: String{ return "all12345"}
    static var sortType: String { return "sortType"}
    
    static var aps: String{ return "aps"}
    static var alert: String{ return "alert"}
    static var body: String{ return "body"}
    static var notificationType: String{ return "notificationType"}
    static var action: String{ return "action"}
    static var calendarDate: String{ return "calendarDate"}
    
    static var isSubscribtionCancelled: String{ return "isSubscribtionCancelled"}
    
    static var calendarId: String{ return "calendarId"}
    static var ids: String{ return "ids"}
}

//MARK:- Api Code
//=======================
enum ApiCode {
    
    static var success: Int { return 200 } // Success
    static var switchProfileInComplete: Int { return 400 }
    static var unauthorizedRequest: Int { return 206 } // Unauthorized request
    static var headerMissing: Int { return 207 } // Header is missing
    static var requiredParametersMissing: Int { return 418 } // Required Parameter Missing or Invalid
    static var tokenExpired: Int { return 401 } // Token expired refresh token needed to be generated
    static var logoutSuccess: Int { return 403 }
    static var emailNotVerify: Int {return 402}
    static var emailRequired: Int {return 406} //email not found in socialLogin case

}
