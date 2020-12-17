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
    var notificationId: String?
    var selectedNotificationId: String?
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(hitNotificationApi), name: Notification.Name.NotificationUpdate, object: nil)
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
        hitApi()
    }
    
    public func hitApi(){
        if isUserLoggedin {
        let params = [ApiKey.page: "1",ApiKey.limit : "20"]
        viewModel.fetchNotificationListing(params: params, loader: false)
        }
    }
    
    
    @objc func refreshWhenPull(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        hitApi()
    }
    
    private func getNoOfRowsInSection() -> Int {
        if isUserLoggedin {
            self.mainTableView.isScrollEnabled = true
            return viewModel.notificationListingArr.endIndex + (self.viewModel.showPaginationLoader ?  1: 0)
        } else {
            self.mainTableView.isScrollEnabled = false
            return 1
        }
    }
    
    @objc func hitNotificationApi(){
       hitApi()
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
            if indexPath.row == (viewModel.notificationListingArr.endIndex) {
                let cell = tableView.dequeueCell(with: LoaderCell.self)
                return cell
            } else {
                return getNotificationCell(tableView, indexPath: indexPath)
                
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell as? LoaderCell != nil {
            self.viewModel.fetchNotificationListing(params: [ApiKey.page: self.viewModel.currentPage, ApiKey.limit : "20"],loader: false,pagination: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.viewModel.notificationListingArr[indexPath.row].isRead {
            self.notificationId = self.viewModel.notificationListingArr[indexPath.row].id
            viewModel.setNotificationMarkRead(params : [ApiKey.notificationId: self.viewModel.notificationListingArr[indexPath.row].id], loader: false)
        }
        
        switch self.viewModel.notificationListingArr[indexPath.row].type {
      
        case .newBid, .bidEdit :
            AppRouter.goToUserAllOffersVC(vc: self, requestId: self.viewModel.notificationListingArr[indexPath.row].requestID ?? "")
            
        case .newRequest, .bidAccepted, .bidRejected :
            AppRouter.goToGarageServiceRequestVC(vc: self,requestId : self.viewModel.notificationListingArr[indexPath.row].requestID ?? "",  requestType: "",bidStatus: .openForBidding)
            
        case .bid_cancelled, .requestRejected:
            AppRouter.goToUserServiceRequestVC(vc: self,requestId: self.viewModel.notificationListingArr[indexPath.row].requestID ?? "", serviceType: "Tyres")
        
        case .serviceStatusUpdated, .serviceStarted:
            AppRouter.goToUserServiceStatusVC(vc: self, requestId: self.viewModel.notificationListingArr[indexPath.row].requestID ?? "")
            
        case .payment_recieved_by_garage:
            AppRouter.goToServiceStatusVC(vc: self, requestId: self.viewModel.notificationListingArr[indexPath.row].requestID ?? "")
            
        case .payment_refunded:
            switch isCurrentUserType{
            case .user:
                 AppRouter.goToUserServiceStatusVC(vc: self, requestId: self.viewModel.notificationListingArr[indexPath.row].requestID ?? "")
            case .garage:
                 AppRouter.goToServiceStatusVC(vc: self, requestId: self.viewModel.notificationListingArr[indexPath.row].requestID ?? "")
            default:
                break
            }
        case .rating_received,.rating_updated:
            if isCurrentUserType == .garage {
             AppRouter.goToServiceCompletedVC(vc: self,screenType: .serviceComplete)
            }
        case .garageRequestRejected:
            AppRouter.goToRegistraionPendingVC(vc: self, screenType: .rejected, msg: "", reason: self.viewModel.notificationListingArr[indexPath.row].reason ?? [],time: self.viewModel.notificationListingArr[indexPath.row].time ?? "")
       
        case .garageRequestApproved:
            AppRouter.goToCompleteProfileStep1VC(vc: self)
            
        default: break
        }
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
        emptyData =  self.viewModel.notificationListingArr.endIndex  == 0 ? LocalizedString.noNotificationAvailable.localized : ""
        
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
    
    func markNotificationSuccess(msg: String) {
        let index =  self.viewModel.notificationListingArr.firstIndex(where: { (model) -> Bool in
            return model.id == notificationId
        })
        guard let selectedIndex = index else {return}
        self.viewModel.notificationListingArr[selectedIndex].isRead = true
        self.mainTableView.reloadData()
    }
    
    func markNotificationFailure(msg: String) {
        CommonFunctions.showToastWithMessage(msg)
    }
    
    func deleteNotificationSuccess(msg: String) {
        let index =  self.viewModel.notificationListingArr.firstIndex(where: { (model) -> Bool in
            return model.id == selectedNotificationId
        })
        guard let selectedIndex = index else {return}
        self.viewModel.notificationListingArr.remove(at: selectedIndex)
        self.mainTableView.reloadData()
    }
    
    func deleteNotificationFailure(msg: String) {
        CommonFunctions.showToastWithMessage(msg)
    }
    
    func notificationListingSuccess(msg: String) {
        mainTableView.reloadData()
    }
    
    func notificationListingFailure(msg: String) {
        CommonFunctions.showToastWithMessage(msg)
    }
}

extension UserNotificationVC {
    
    private func getNotificationCell(_ tableView: UITableView,indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueCell(with: UserNotificationTableViewCell.self, indexPath: indexPath)
        cell.bindData(viewModel.notificationListingArr[indexPath.row])
        
        cell.cancelBtnTapped = {[weak self] in
            guard let `self` = self else { return }
            self.selectedNotificationId = self.viewModel.notificationListingArr[indexPath.row].id
            self.viewModel.deleteNotification(params: [ApiKey.notificationId: self.viewModel.notificationListingArr[indexPath.row].id], loader: false)
        }
        return cell
    }
}


