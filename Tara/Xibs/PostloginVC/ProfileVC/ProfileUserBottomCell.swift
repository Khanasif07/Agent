//
//  ProfileUserBottomCell.swift
//  ArabianTyres
//
//  Created by Admin on 09/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Foundation

class ProfileUserBottomCell: UITableViewCell {
    
    var settingBtnTapped: (()->())?
    var logoutBtnTapped: (()->())?
    var switchProfileToGarage: (()->())?
    var changePassword: (()->())?
    var changeLanguageTapped : (()->())?
    var aboutusTapped : (()->())?
    var contactUsTapped : (()->())?
    var termConditionTapped : (()->())?
    var privacyPolicyTapped : (()->())?
    var serviceCompletedTapped : (()->())?
    var helpBtnTapped : (()->())?
    var paymentsBtnTapped : (()->())?
    var serviceHistroyTapped : (()->())?
    var bankAccTapped : (()->())?

    var isComeFromProfile: Bool = false
    var selectItemArray = [LocalizedString.my_vehicle.localized,LocalizedString.service_history.localized,LocalizedString.payments.localized,LocalizedString.saved_cards.localized,LocalizedString.added_location.localized,LocalizedString.change_password.localized, LocalizedString.setting.localized]
    var selectImageArray: [UIImage] = [#imageLiteral(resourceName: "vehicle"),#imageLiteral(resourceName: "serviceHistory"),#imageLiteral(resourceName: "payment"),#imageLiteral(resourceName: "savedCard"),#imageLiteral(resourceName: "addedLocation"),#imageLiteral(resourceName: "group"),#imageLiteral(resourceName: "profileSettting")]
    
    @IBOutlet weak var internalTableView: AGTableView!
    @IBOutlet weak var dataContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableViewSetUp()
    }
    
    private func tableViewSetUp(){
        self.internalTableView.isScrollEnabled = false
        self.internalTableView.registerCell(with: ProfileUserInternalCell.self)
        self.internalTableView.estimatedRowHeight(60.0)
        self.internalTableView.delegate = self
        self.internalTableView.dataSource = self
    }
       
    override func layoutSubviews() {
        super.layoutSubviews()
        self.internalTableView.layoutSubviews()
        self.superTableView?.beginUpdates()
        self.superTableView?.endUpdates()
        self.dataContainerView.addShadow(cornerRadius: 4, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 4)
    }
}


//MARK:- Table View Delegate and Data Source
//=========================================

extension ProfileUserBottomCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectItemArray.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: ProfileUserInternalCell.self, indexPath: indexPath)
        cell.populateCell(title: self.selectItemArray[indexPath.row],img:self.selectImageArray[indexPath.row] )
        if isComeFromProfile {
            cell.profileImgView.setBorder(width: 1.0, color: UIColor.init(r: 201, g: 6, b: 3, alpha: 0.1))
            cell.profileImgView.backgroundColor = UIColor(r: 255, g: 249, b: 249, alpha: 1.0)
            cell.titleLbl.textColor = UIColor(r: 201, g: 6, b: 3, alpha: 1.0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.selectItemArray[indexPath.row] {
        case  LocalizedString.logout.localized :
            if let handle = logoutBtnTapped{
                handle()
            }
        case LocalizedString.contactUs.localized:
            if let handle = contactUsTapped{
                handle()
            }
        case LocalizedString.payments.localized:
            if let handle = paymentsBtnTapped{
                handle()
            }
        case LocalizedString.settings.localized:
            if let handle = settingBtnTapped{
                handle()
            }
        case LocalizedString.bank_Account.localized:
            if let handle = bankAccTapped{
                handle()
            }
        case LocalizedString.switchProfileTogarage.localized,LocalizedString.switchProfileToUser.localized ,LocalizedString.createGarageProfile.localized:
            if let handle = switchProfileToGarage{
                handle()
            }
        case LocalizedString.change_password.localized:
            if let handle = changePassword{
                handle()
            }
        case LocalizedString.changeLanguage.localized:
            changeLanguageTapped?()
        case LocalizedString.aboutUs.localized:
            aboutusTapped?()
        case LocalizedString.terms_Condition.localized:
            termConditionTapped?()
        case LocalizedString.privacy_policy.localized:
            privacyPolicyTapped?()
        case LocalizedString.service_Completed.localized:
            serviceCompletedTapped?()
        case LocalizedString.help.localized:
            helpBtnTapped?()
        case LocalizedString.change_password.localized:
            changePassword?()
        case LocalizedString.service_history.localized:
            serviceHistroyTapped?()
        default:
            printDebug("Do Nothing")
        }
    }
}
