//
//  UserNotificationVC.swift
//  ArabianTyres
//
//  Created by Arvind on 27/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit
import DZNEmptyDataSet

class UserNotificationVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: - Variables
    //===========================
    let viewModel = UserNotificationVM()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
    // MARK: - IBActions
    //===========================
    
    
}

// MARK: - Extension For Functions
//===========================
extension UserNotificationVC {
    
    private func initialSetup() {
        titleLbl.text = LocalizedString.notifications.localized
        mainTableView.delegate = self
        mainTableView.dataSource = self
        viewModel.delegate = self
        mainTableView.emptyDataSetSource = self
        mainTableView.emptyDataSetDelegate = self
        mainTableView.enablePullToRefresh(tintColor: AppColors.appRedColor ,target: self, selector: #selector(refreshWhenPull(_:)))
        mainTableView.registerCell(with: LoaderCell.self)
        mainTableView.registerCell(with: UserNotificationTableViewCell.self)
        mainTableView.registerCell(with: ProfileGuestTableCell.self)
        mainTableView.contentInset = UIEdgeInsets(top: 8.0, left: 0, bottom: 0, right: 0)
        
    }
    
    public func hitApi(params: JSONDictionary = [:],loader: Bool = false){
     
    }
  
    
    @objc func refreshWhenPull(_ sender: UIRefreshControl) {
        sender.endRefreshing()
       
    }
    
    @objc func serviceRequestReceived() {
        hitApi(params: [ApiKey.page:"1", ApiKey.limit: "10"])
    }
    
    @objc func placeBidRejectBidSuccess(){
        hitApi(params: [ApiKey.page:"1", ApiKey.limit: "10"])
    }
    
    private func getNoOfRowsInSection() -> Int {
        if isUserLoggedin {
            return 3
        } else {
            return 1
        }
    }
    
}

// MARK: - Extension For TableView
//===========================
extension UserNotificationVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getNoOfRowsInSection()
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isUserLoggedin {
            let cell = tableView.dequeueCell(with: UserNotificationTableViewCell.self, indexPath: indexPath)
            cell.cancelBtnTapped = {[weak self] in
                
            }
            return cell
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK: DZNEmptyDataSetSource and DZNEmptyDataSetDelegate
//================================
extension UserNotificationVC : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return  #imageLiteral(resourceName: "layerX00201")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var emptyData = ""
    
        return NSAttributedString(string: emptyData, attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontTertiaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(18)])
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldBeForced(toDisplay scrollView: UIScrollView!) -> Bool {
        return false
    }
}

extension UserNotificationVC : UserNotificationVMDelegate{
    func notificationListingSuccess(msg: String) {
        mainTableView.reloadData()
    }
    
    func notificationListingFailure(msg: String) {
        CommonFunctions.showToastWithMessage(msg)
    }
}
