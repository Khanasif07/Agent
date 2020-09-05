//
//  OtpVerificationVM.swift
//  ArabianTyres
//
//  Created by Admin on 05/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol VerificationVMDelegate: class {
    func resendSuccess(message: String)
    func resendFailed(error:String)
    func otpVerificationFailed(error:String)
    func otpVerifiedSuccessfully(message : String)
}

extension VerificationVMDelegate {
    func resendSuccess(message: String) {}
    func resendFailed(error:String) {}
    func otpVerificationFailed(error:String) {}
    func otpVerifiedSuccessfully(message: String) {}
}

class OtpVerificationVM{
    
    //MARK:- Variables
    //================
    weak var delegate:VerificationVMDelegate?
    var totalTime = 60
    var countdownTimer:Timer!
    var email = String()

    //MARK:- Functions
    //Function for verify OTP
    func verifyOTP(dict: JSONDictionary){

        WebServices.verifyOtp(parameters: dict, success: { (model) in
            self.delegate?.otpVerifiedSuccessfully(message: "")
            }) { (error) -> (Void) in
                self.delegate?.otpVerificationFailed(error: error.localizedDescription)
            }
    }
    
    func resendOTP(){
            let dict = [ApiKey.email : email]
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
