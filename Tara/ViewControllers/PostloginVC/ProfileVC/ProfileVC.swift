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
    @IBOutlet weak var headerImgView: UIImageView!
    
    // MARK: - Variables
    //===========================
    var viewModel = ProfileVM()
    var selectItemArray = [LocalizedString.service_history.localized,LocalizedString.payments.localized,LocalizedString.saved_cards.localized,LocalizedString.change_password.localized,LocalizedString.settings.localized]
    var selectImageArray: [UIImage] = [#imageLiteral(resourceName: "serviceHistory"),#imageLiteral(resourceName: "payment"),#imageLiteral(resourceName: "savedCard"),#imageLiteral(resourceName: "group"),#imageLiteral(resourceName: "profileSettting")]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        self.mainTableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        self.hitProfileApi()
        self.tableViewSetUp()
    }
    
    private func tableViewSetUp(){
        self.headerImgView.backgroundColor = UIColor.init(r: 28, g: 29, b: 36, alpha: 1.0)
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerCell(with: ProfileGuestTableCell.self)
        self.mainTableView.registerCell(with: ProfileUserHeaderCell.self)
        self.mainTableView.registerCell(with: ProfileUserBottomCell.self)
        let footerView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.width, height:72.0)))
        footerView.backgroundColor = .clear
        self.mainTableView.tableFooterView = footerView
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
                    cell.populateData(model: UserModel.main)
                    cell.phoneVerifyBtnTapped = { [weak self] (sender) in
                        guard let `self` = self else { return }
                        self.showPhoneVerificationPopUp()
                    }
                    cell.emailVerifyBtnTapped = { [weak self] (sender) in
                        guard let `self` = self else { return }
                        self.showEmailVerificationPopUp()
                    }
                    cell.editProfileBtnTapped = { [weak self] (sender) in
                        guard let `self` = self else { return }
                        AppRouter.goToEditProfileVC(vc: self,model: self.viewModel.userModel, isEditProfileFrom: .profile)
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
                    cell.changePassword = { [weak self]  in
                        guard let `self` = self else { return }
                        AppRouter.goToChangePasswordVC(vc: self)
                    }
                    cell.serviceHistroyTapped = { [weak self]  in
                        guard let `self` = self else { return }
                        AppRouter.goToServiceCompletedVC(vc: self, screenType: .serviceHistory)
                        
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
    
    public func hitProfileApi(){
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

// MARK: - UICollectionViewFlowLayout
//===========================
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
}
//
extension UINavigationController {
       open override var preferredStatusBarStyle: UIStatusBarStyle {
           return .default
       }
   }


// MARK: - EditProfileVCDelegate
//===========================
extension ProfileVC: EditProfileVCDelegate {
    func editProfileSuccess() {
        self.hitProfileApi()
    }
}
