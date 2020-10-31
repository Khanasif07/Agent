//
//  OtpVerificationVM.swift
//  ArabianTyres
//
//  Created by Admin on 05/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol OtpVerificationVMDelegate: class {
    func resendOtpSuccess(message: String)
    func resendOtpFailed(error:String)
    func otpVerificationFailed(error:String)
    func otpVerifiedSuccessfully(message : String)
    func verifyForgotPasswordOTPSuccess(message: String)
    func verifyForgotPasswordOTPFailed(error:String)
}

extension OtpVerificationVMDelegate {
    func resendSuccess(message: String) {}
    func resendFailed(error:String) {}
    func otpVerificationFailed(error:String) {}
    func otpVerifiedSuccessfully(message: String) {}
    func verifyForgotPasswordOTPSuccess(message: String) {}
    func verifyForgotPasswordOTPFailed(error:String) {}
}

class OtpVerificationVM{
    
    //MARK:- Variables
    //================
    var isComeForVerifyPassword: Bool = false
    var isComeFromSignupScreen: Bool = false
    var countryCode: String = "+91"
    var resetToken: String = ""
    var phoneNo: String = ""
    weak var delegate: OtpVerificationVMDelegate?
    var totalTime = 60
    var countdownTimer:Timer!
    
    //MARK:- Functions
    //Function for verify OTP
    func verifyOTP(dict: JSONDictionary){
        WebServices.verifyOtp(parameters: dict, success: { (userModel) in
            self.addUser(user: userModel, message: "")
//            self.delegate?.otpVerifiedSuccessfully(message: "Otp Verified Successfully")
        }) { (error) -> (Void) in
            self.delegate?.otpVerificationFailed(error: error.localizedDescription)
        }
    }
    
    func verifyForgotPasswordOTP(dict: JSONDictionary){
        WebServices.verifyForgotPasswordOTP(parameters: dict, success: { (json) in
            self.resetToken = json[ApiKey.data][ApiKey.resetToken].stringValue
            self.delegate?.verifyForgotPasswordOTPSuccess(message: "Password Verified Successfully")
        }) { (error) -> (Void) in
            self.delegate?.verifyForgotPasswordOTPFailed(error: error.localizedDescription)
        }
    }
    
    func resendOTP(dict: JSONDictionary){
        WebServices.sendOtpThroughPhone(parameters: dict, success: { (message) in
            self.delegate?.resendOtpSuccess(message: message)
        }) { (error) -> (Void) in
            self.delegate?.resendOtpFailed(error: error.localizedDescription)
        }
    }
    
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    //Add user to Firestore
    private func addUser(user: UserModel, message: String) {
        var emailId  = user.email
        if emailId.isEmpty{
            emailId = "\(user.id)" + "@tara.com"
               }
        FirestoreController.login(userId: user.id, withEmail: emailId, with: "Tara@123", success: {
            FirestoreController.setFirebaseData(userId: user.id, email: user.email, password: "Tara@123", name: user.name, imageURL: user.image, phoneNo: user.countryCode + "" + user.phoneNo, status: "", completion: {
                self.delegate?.otpVerifiedSuccessfully(message: "Otp Verified Successfully")
            }) { (error) -> (Void) in
                self.delegate?.otpVerificationFailed(error: "Please try again")
            }
        }) { (message, code) in
            if code == 17011 {
//        var emailId  = user.email
//        if emailId.isEmpty{
//            emailId = "\(user.id)" + "@tara.com"
//        }
//        FirestoreController.createUserNode(userId: user.id, email: emailId, password: "Tara@123", name: user.name, imageURL: user.image, phoneNo: user.countryCode + "" + user.phoneNo, status: "", completion: {
//            self.delegate?.otpVerifiedSuccessfully(message: "Otp Verified Successfully")
//        }) { (error) -> (Void) in
//            self.delegate?.otpVerificationFailed(error: error.localizedDescription)
//                }
//            } else {
//                self.delegate?.otpVerificationFailed(error: "Please try again")
            }
            
        }
    }
    
}
