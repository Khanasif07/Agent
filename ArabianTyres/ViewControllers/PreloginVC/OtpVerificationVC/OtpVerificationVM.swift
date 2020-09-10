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
            self.delegate?.otpVerifiedSuccessfully(message: "Otp Verified Successfully")
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
    
}
