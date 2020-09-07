//
//  OtpVerificationVM.swift
//  ArabianTyres
//
//  Created by Admin on 05/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol OtpVerificationVMDelegate: class {
    func resendSuccess(message: String)
    func resendFailed(error:String)
    func otpVerificationFailed(error:String)
    func otpVerifiedSuccessfully(message : String)
}

extension OtpVerificationVMDelegate {
    func resendSuccess(message: String) {}
    func resendFailed(error:String) {}
    func otpVerificationFailed(error:String) {}
    func otpVerifiedSuccessfully(message: String) {}
}

class OtpVerificationVM{
    
    //MARK:- Variables
    //================
    var countryCode: String = "+91"
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
    
    func resendOTP(){
            let dict = [ApiKey.phoneNo : phoneNo]
            WebServices.resetOtp(parameters: dict, success: { (message) in
                self.delegate?.resendSuccess(message: message)
            }) { (error) -> (Void) in
                self.delegate?.resendFailed(error: error.localizedDescription)
            }
    }

    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}
