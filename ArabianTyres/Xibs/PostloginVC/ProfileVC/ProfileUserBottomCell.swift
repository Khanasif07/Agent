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
    
    var selectItemArray = [LocalizedString.my_vehicle.localized,LocalizedString.service_history.localized,LocalizedString.payments.localized,LocalizedString.saved_cards.localized,LocalizedString.added_location.localized,LocalizedString.change_password.localized,LocalizedString.setting.localized]
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 6:
            if let handle = settingBtnTapped{
                handle()
            }
        default:
            printDebug("Do nothing")
        }
    }
}
