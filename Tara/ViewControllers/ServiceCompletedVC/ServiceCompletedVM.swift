//
//  ServiceCompletedVM.swift
//  Tara
//
//  Created by Arvind on 06/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol ServiceCompletedVMDelegate: class {
    func ServiceCompleteApiSuccess(msg : String)
    func ServiceCompleteApiFailure(msg : String)

}
class ServiceCompletedVM {
    
    weak var delegate: ServiceCompletedVMDelegate?
    
    
}
