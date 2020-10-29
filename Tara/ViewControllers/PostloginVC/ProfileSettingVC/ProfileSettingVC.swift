//
//  ProfileVC.swift
//  ArabianTyres
//
//  Created by Admin on 08/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ProfileSettingVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var switchProfileString = isCurrentUserType == .user ? LocalizedString.switchProfileTogarage.localized : LocalizedString.switchProfileToUser.localized
    var selectItemArray = [LocalizedString.aboutUs.localized,LocalizedString.terms_Condition.localized,LocalizedString.privacy_policy.localized,LocalizedString.contactUs.localized,LocalizedString.changeLanguage.localized,LocalizedString.switchProfileTogarage.localized,LocalizedString.reportAnIssue.localized,LocalizedString.faq.localized,LocalizedString.referFriend.localized]
    var selectImageArray: [UIImage] = [#imageLiteral(resourceName: "favicon2"),#imageLiteral(resourceName: "terms"),#imageLiteral(resourceName: "privacyPolicy"),#imageLiteral(resourceName: "contactUs"),#imageLiteral(resourceName: "changeLang"),#imageLiteral(resourceName: "switchProfile"),#imageLiteral(resourceName: "report"),#imageLiteral(resourceName: "faq"),#imageLiteral(resourceName: "refer")]
    var selectItemArray1 = [LocalizedString.logout.localized]
    var selectImageArray1: [UIImage] = [#imageLiteral(resourceName: "logout")]
    var viewModel = GarageRegistrationVM()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switchProfileTitle()
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    func hitGarageSwitchApi(){
        viewModel.switchGarageProfile()
    }
}

// MARK: - Extension For Functions
//===========================
extension ProfileSettingVC {
    
    private func initialSetup() {
        switchProfileTitle()
        self.tableViewSetUp()
        viewModel.delegate = self
    }
    
    private func tableViewSetUp(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.isScrollEnabled = true
        self.mainTableView.registerCell(with: ProfileUserBottomCell.self)
        let footerView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.width, height:72.0)))
        footerView.backgroundColor = .clear
        self.mainTableView.tableFooterView = footerView
    }
    
    private func getcellForTableView(_ tableView: UITableView,_ indexPath : IndexPath)-> UITableViewCell {
        if isUserLoggedin {
            switch isCurrentUserType {
            case .user:
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueCell(with: ProfileUserBottomCell.self, indexPath: indexPath)
                    cell.selectItemArray = self.selectItemArray
                    cell.selectImageArray = self.selectImageArray
                    
                    cell.switchProfileToGarage = {  [weak self]  in
                        guard let `self` = self else { return }
                        self.hitGarageSwitchApi()
                    }
                    return cell
                default:
                    let cell = tableView.dequeueCell(with: ProfileUserBottomCell.self, indexPath: indexPath)
                    cell.isComeFromProfile = true
                    cell.selectItemArray = self.selectItemArray1
                    cell.selectImageArray = self.selectImageArray1
                    cell.logoutBtnTapped = {  [weak self]  in
                        guard let `self` = self else { return }
                        self.showLogoutPopUp()
                    }
                    
                    return cell
                }
            case .garage:
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueCell(with: ProfileUserBottomCell.self, indexPath: indexPath)
                    cell.selectItemArray = self.selectItemArray
                    cell.selectImageArray = self.selectImageArray
                    
                    cell.switchProfileToGarage = {  [weak self]  in
                        guard let `self` = self else { return }
                        self.hitGarageSwitchApi()
                    }
                    return cell
                default:
                    let cell = tableView.dequeueCell(with: ProfileUserBottomCell.self, indexPath: indexPath)
                    cell.isComeFromProfile = true
                    cell.selectItemArray = self.selectItemArray1
                    cell.selectImageArray = self.selectImageArray1
                    cell.logoutBtnTapped = {  [weak self]  in
                        guard let `self` = self else { return }
                        self.showLogoutPopUp()
                    }
                    
                    return cell
                }
            default:
                return UITableViewCell()
            }
        } else {
            return UITableViewCell()
        }
    }
    
    private func returnCellCount()->  Int{
        if isUserLoggedin {
            switch isCurrentUserType {
            case .user:
                return 2
            case .garage:
                return 2
            default:
                return 1
            }
        } else {
            return 1
        }
    }
    
    private func performCleanUp() {
        let lang  = AppUserDefaults.value(forKey: .currentLanguage).stringValue
        AppUserDefaults.removeAllValues()
        AppUserDefaults.save(value: lang, forKey: .currentLanguage)
        AppUserDefaults.save(value: true, forKey: .isLanguageSelect)
        UserModel.main = UserModel()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        SocketIOManager.shared.closeConnection()
    }
    
    private func showLogoutPopUp(){
        self.showAlertWithAction(title: "Logout", msg: "Are you sure you want to logout?", cancelTitle: "Cancel", actionTitle: LocalizedString.ok.localized, actioncompletion: {
            WebServices.logout(parameters: [:], success: { (message) in
                self.performCleanUp()
                AppUserDefaults.save(value: "guest", forKey: .currentUserType)
                AppRouter.goToUserHome()
            }) {_ in printDebug("Dismiss")}
        })
    }
    
    private func switchProfileTitle(){
        if AppUserDefaults.value(forKey: .isGarrage).boolValue && isCurrentUserType == .user {
            self.switchProfileString = LocalizedString.switchProfileTogarage.localized
        } else if !AppUserDefaults.value(forKey: .isGarrage).boolValue  && isCurrentUserType == .user {
            self.switchProfileString = LocalizedString.createGarageProfile.localized
        } else {
            self.switchProfileString = LocalizedString.switchProfileToUser.localized
        }
        self.selectItemArray = [LocalizedString.aboutUs.localized,LocalizedString.terms_Condition.localized,LocalizedString.privacy_policy.localized,LocalizedString.contactUs.localized,LocalizedString.changeLanguage.localized,switchProfileString,LocalizedString.reportAnIssue.localized,LocalizedString.faq.localized,LocalizedString.referFriend.localized]
    }
}
// MARK: - Extension For TableView
//===========================
extension ProfileSettingVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.returnCellCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.getcellForTableView(tableView,indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension ProfileSettingVC : GarageRegistrationVMDelegate {
    func switchGarageRegistrationSuccess(code: Int, msg : String, reason: [String],time: String){
        switch code {
        case 600:
            AppRouter.goToGarageRegistrationVC(vc: self)
        case 601:
            AppRouter.goToRegistraionPendingVC(vc: self, screenType: .pending, msg: msg, reason: reason,time: time)
        case 605:
            GarageProfileModel.shared = GarageProfileModel()
            AppRouter.goToRegistraionPendingVC(vc: self, screenType: .rejected, msg: msg, reason: reason,time: time)
        case 604:
            AppRouter.goToRegistraionPendingVC(vc: self, screenType: .accept, msg: msg, reason: reason,time: time)
        case 602:
            CommonFunctions.showToastWithMessage(msg)
        case 603:
            CommonFunctions.showToastWithMessage(msg)
        default:
            if isCurrentUserType == .user{
                AppRouter.goToUserHome()
            } else {
                AppRouter.goToGarageHome()
            }
        }
    }
    
    func switchGarageRegistrationFailure(msg: String){
        CommonFunctions.showToastWithMessage(msg)
    }
}