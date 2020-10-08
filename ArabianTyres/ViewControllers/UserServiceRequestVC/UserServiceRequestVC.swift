//
//  UserServiceRequestVC.swift
//  ArabianTyres
//
//  Created by Admin on 07/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

class UserServiceRequestVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    
    
    @IBOutlet weak var viewAllBtn: AppButton!
    @IBOutlet weak var requestNoValueLbl: UILabel!
    @IBOutlet weak var requestNoLbl: UILabel!
    @IBOutlet weak var mainImgView: UIImageView!
    // MARK: - Variables
    //===========================
    var viewModel = UserServiceRequestVM()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewAllBtn.round(radius: 4.0)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func viewAllBtnAction(_ sender: AppButton) {
    }
    
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension UserServiceRequestVC {
    
    private func initialSetup() {
        viewModel.delegate = self
        viewAllBtn.isEnabled = true
        viewModel.getUserMyRequestDetailData(params: [ApiKey.requestId: self.viewModel.requestId])
    }
}

// MARK: - Extension For UserAllRequestVMDelegate
//===========================
extension UserServiceRequestVC: UserAllRequestVMDelegate{
    func getUserMyRequestDataSuccess(message: String) {
        ToastView.shared.showLongToast(self.view, msg: message)
    }
    
    func mgetUserMyRequestDataFailed(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
}
