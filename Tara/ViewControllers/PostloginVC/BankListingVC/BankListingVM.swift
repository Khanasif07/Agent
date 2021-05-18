//
//  BankListingVM.swift
//  ArabianTyres
//
//  Created by Admin on 17/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Foundation

protocol BankListingVMDelegate{
    func sendBankCode(code: String)
}


class BankListingVM{
    enum BankKeys: String{
       case name = "countryName"
        case code = "phoneCode"
    }
    
    var filteredBank:[[String:String]] = []
    var searchBank: String = ""
    var searchedBank:[[String:String]] {
        if searchBank.isEmpty{
            return filteredBank
        }
        return filteredBank.filter { ($0[BankListingVM.BankKeys.name.rawValue]?.localizedCaseInsensitiveContains(searchBank) ?? false)}
    }
    
    func getBankData() {
        
        if AppUserDefaults.value(forKey: .language) == 1 {
            filteredBank = bankDataArabic.sorted(by: { (bank1, bank2) -> Bool in
                if let name1 = bank1[BankKeys.name.rawValue],
                    let name2 = bank2[BankKeys.name.rawValue] {
                    return name1 < name2
                }else{
                    return true
                }
            })
        } else {
            filteredBank = bankDataEnglish.sorted(by: { (bank1, bank2) -> Bool in
                if let name1 = bank1[BankKeys.name.rawValue],
                    let name2 = bank2[BankKeys.name.rawValue] {
                    return name1 < name2
                }else{
                    return true
                }
            })
        }
    }
}
