//
//  ProfileVC.swift
//  ArabianTyres
//
//  Created by Admin on 08/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ProfileVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var viewModel = ProfileVM()
    var selectItemArray = [LocalizedString.my_vehicle.localized,LocalizedString.service_history.localized,LocalizedString.payments.localized,LocalizedString.saved_cards.localized,LocalizedString.added_location.localized,LocalizedString.change_password.localized,LocalizedString.setting.localized,LocalizedString.setting.localized,LocalizedString.setting.localized]
    var selectImageArray: [UIImage] = [#imageLiteral(resourceName: "vehicle"),#imageLiteral(resourceName: "serviceHistory"),#imageLiteral(resourceName: "payment"),#imageLiteral(resourceName: "savedCard"),#imageLiteral(resourceName: "addedLocation"),#imageLiteral(resourceName: "group"),#imageLiteral(resourceName: "profileSettting")]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    
    // MARK: - IBActions
    //===========================
    
    
}

// MARK: - Extension For Functions
//===========================
extension ProfileVC {
    
    private func initialSetup() {
        self.tableViewSetUp()
        self.hitProfileApi()
    }
    
    private func tableViewSetUp(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerCell(with: ProfileGuestTableCell.self)
        self.mainTableView.registerCell(with: ProfileUserHeaderCell.self)
        self.mainTableView.registerCell(with: ProfileUserBottomCell.self)
        self.mainTableView.enablePullToRefresh(tintColor: AppColors.errorRedColor ,target: self, selector: #selector(refreshWhenPull(_:)))
        self.viewModel.delegate = self
    }
    
    private func getCellForTableView(_ tableView: UITableView,_ indexPath : IndexPath)-> UITableViewCell {
        if isUserLoggedin {
            switch isCurrentUserType {
            case .user:
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueCell(with: ProfileUserHeaderCell.self, indexPath: indexPath)
                    cell.populateData(model: self.viewModel.userModel)
                    cell.phoneVerifyBtnTapped = { [weak self] (sender) in
                        guard let `self` = self else { return }
                        self.showPhoneVerificationPopUp()
                    }
                    cell.emailVerifyBtnTapped = { [weak self] (sender) in
                        guard let `self` = self else { return }
                        self.showEmailVerificationPopUp()
                    }
                    return cell
                default:
                    let cell = tableView.dequeueCell(with: ProfileUserBottomCell.self, indexPath: indexPath)
                    cell.selectItemArray = self.selectItemArray
                    cell.selectImageArray = self.selectImageArray
                    cell.settingBtnTapped = { [weak self]  in
                        guard let `self` = self else { return }
                        AppRouter.goToProfileSettingVC(vc: self)
                    }
                    return cell
                }
            default:
                let cell = tableView.dequeueCell(with: ProfileGuestTableCell.self, indexPath: indexPath)
                cell.loginBtnTapped = { [weak self] (sender) in
                    guard let `self` = self else { return }
                    AppRouter.goToLoginVC(vc: self)
                }
                cell.createAccountBtnTapped = { [weak self] (sender) in
                    guard let `self` = self else { return }
                    AppRouter.goToSignUpVC(vc: self)
                }
                return cell
            }
        } else {
            let cell = tableView.dequeueCell(with: ProfileGuestTableCell.self, indexPath: indexPath)
            cell.loginBtnTapped = { [weak self] (sender) in
                guard let `self` = self else { return }
                AppRouter.goToLoginVC(vc: self)
            }
            cell.createAccountBtnTapped = { [weak self] (sender) in
                guard let `self` = self else { return }
                AppRouter.goToSignUpVC(vc: self)
            }
            return cell
        }
    }
    
    private func returnCellCount()->  Int{
        if isUserLoggedin {
            switch isCurrentUserType {
            case .user:
                self.mainTableView.isScrollEnabled = true
                return 2
            default:
                self.mainTableView.isScrollEnabled = false
                return 1
            }
        } else {
            self.mainTableView.isScrollEnabled = false
            return 1
        }
    }
    
    private func hitProfileApi(){
        if isUserLoggedin {
            self.viewModel.getMyProfileData(params: [:])
        }
    }
    
    @objc func refreshWhenPull(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        if isUserLoggedin {
            self.viewModel.getMyProfileData(params: [:])
        }
    }
    
    private func showEmailVerificationPopUp(){
        self.showAlertWithAction(title: "Verify Email", msg: "A verification link will be send to your email address", cancelTitle: "Cancel", actionTitle: "Send", actioncompletion: {
            self.viewModel.sendVerificationLink(dict: [:])
        }){self.dismiss(animated: true, completion: nil)}
    }
    
    private func showPhoneVerificationPopUp(){
        self.showAlertWithAction(title: "Verify Phone", msg: "An OTP will be send to your phone number", cancelTitle: "Cancel", actionTitle: "Send", actioncompletion: {
             self.sendOtp()
        }) {self.dismiss(animated: true, completion: nil)}
    }
    
    private func sendOtp(){
        self.view.endEditing(true)
        self.viewModel.resendOTP(dict: getSendOtpDict())
    }
    
    private func getSendOtpDict() -> JSONDictionary{
        let dict : JSONDictionary = [ApiKey.phoneNo:  viewModel.userModel.phoneNo,ApiKey.countryCode: viewModel.userModel.countryCode, ApiKey.device : [ApiKey.platform : "ios", ApiKey.token : DeviceDetail.deviceToken].toJSONString() ?? ""]
        return dict
    }
    
}

// MARK: - Extension For TableView
//===========================
extension ProfileVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.returnCellCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.getCellForTableView(tableView,indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - ProfileVMDelegate
//===========================
extension ProfileVC: ProfileVMDelegate {
    func sendVerificationLinkSuccess(msg: String) {
         ToastView.shared.showLongToast(self.view, msg: msg)
    }
    
    func sendVerificationLinkFailed(msg: String, error: Error) {
        ToastView.shared.showLongToast(self.view, msg: msg)
    }
    
    func getProfileDataSuccess(msg: String) {
        self.mainTableView.reloadData()
    }
    
    func getProfileDataFailed(msg: String, error: Error) {
        ToastView.shared.showLongToast(self.view, msg: msg)
    }
    
    func resendOtpSuccess(msg: String){
        AppRouter.goToOtpVerificationVC(vc: self, phoneNo: self.viewModel.userModel.phoneNo, countryCode: self.viewModel.userModel.countryCode)
    }
    
    func resendOtpFailed(msg: String, error: Error){
        ToastView.shared.showLongToast(self.view, msg: msg)
    }
}
