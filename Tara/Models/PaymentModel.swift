//
//  PaymentModel.swift
//  Tara
//
//  Created by Admin on 09/12/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
// MARK: - Result
struct PaymentModel: Codable {
    let id: String
    let amount: Int
    let paymentMode: String?
    let requestID, requestType, createdAt: String
    let transactionID: String
    let paymentStatus: PaymentStatus?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case amount, paymentMode, paymentStatus
        case requestID = "requestId"
        case requestType, createdAt
        case transactionID = "transactionId"
    }
    
    init(){
        id = ""
        amount = 0
        paymentMode = ""
        paymentStatus = .pending
        requestType = ""
        requestID = ""
        transactionID = ""
        createdAt = ""
    }
}
