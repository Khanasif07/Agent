//
//  HandleRequest.swift
//  ArabianTyres
//
//  Created by Arvind on 16/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit


class HandleRequest {
    
    //MARK:-Variables
    var dataArr : [RequestModel] = [] {
        didSet {
            if dataArr.isEmpty {
                dataProcess = false
                return
            }else {
                if dataProcess {
                    return
                }
                SocketIOManager.shared.showPopup(dataArr[0])
                dataProcess = true
            }
        }
    }
    
    var dataProcess: Bool = false
    static let shared : HandleRequest = HandleRequest()

    init() {
        
    }
}

