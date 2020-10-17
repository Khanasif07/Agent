//
//  SocketIOManager+ApiData.swift
//  ArabianTyres
//
//  Created by Arvind on 16/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON

enum QuantumValue: Decodable,Encodable {
    func encode(to encoder: Encoder) throws {
        
    }
    case double(Double), string(String)
    
    init(from decoder: Decoder) throws {
        if let double = try? decoder.singleValueContainer().decode(Double.self) {
            self = .double(double)
            return
        }
        
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        throw QuantumError.missingValue
    }
    
    enum QuantumError:Error {
        case missingValue
    }
}


struct RequestModel: Codable {
    let eventName: String
    let distance: QuantumValue
    let userImage: String
    let requestId: String
    let time: String
    let message: String
    let amount: Double?
    let bidId : String?
    let garageName : String?
}

enum CodingKeys: String, CodingKey {
    case eventName, time, message, userImage, distance, requestId,bidId,garageName, amount
}

extension SocketIOManager {
    
    func parseToMakeListingData(result: JSON) {
        if let jsonString = result.arrayValue.first?.rawString(), let data = jsonString.data(using: .utf8) {
            do {
                if result.arrayValue.isEmpty {
                    return
                }
                let modelList = try! JSONDecoder().decode(RequestModel.self, from: data)
                printDebug(modelList)
                HandleRequest.shared.dataArr.append(modelList)
                
            } catch {
                printDebug("error occured")
            }
        }
    }
    
    func showPopup(_ data : RequestModel) {
        if let key = UIWindow.key {
            DispatchQueue.main.async {

                if var topController = key.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                    }
                    if let navC = topController as? UINavigationController {
                        //for bid
                        if data.eventName == "NEW_BID" {
                            let vc = GarageRequestPopupVC.instantiate(fromAppStoryboard: .UserHomeScreen)
                            vc.modalPresentationStyle = .overFullScreen
                            vc.requestData = data
                            vc.onDismiss = {
                                HandleRequest.shared.dataProcess = false
                                HandleRequest.shared.dataArr.remove(at: 0)
                            }
                            vc.viewBtnTapped = { (requestId, requestType) in
                                AppRouter.goToUserAllOffersVC(vc: navC.visibleViewController ?? navC, requestId: requestId)
                            }
                            if CommonFunctions.presentOnTabBar() {
                                navC.present(vc, animated: true, completion: nil)
                                
                            }else {
                                HandleRequest.shared.dataProcess = false
                                HandleRequest.shared.dataArr.remove(at: 0)
                            }
                            
                        }else {
                            //for request
                            let vc = SRPopupVC.instantiate(fromAppStoryboard: .UserHomeScreen)
                            vc.modalPresentationStyle = .overFullScreen
                            vc.requestData = data
                            vc.onDismiss = {
                                HandleRequest.shared.dataProcess = false
                                HandleRequest.shared.dataArr.remove(at: 0)
                            }
                            vc.viewBtnTapped = { (requestId, requestType) in
                                AppRouter.goToGarageServiceRequestVC(vc: navC.visibleViewController ?? navC,requestId : requestId, requestType: requestType)
                            }
                            if CommonFunctions.presentOnTabBar() {
                                navC.present(vc, animated: true, completion: nil)
                                
                            }else {
                                HandleRequest.shared.dataProcess = false
                                HandleRequest.shared.dataArr.remove(at: 0)
                            }
                        }
                        
                    }
                }
            }
        }
    }
}
