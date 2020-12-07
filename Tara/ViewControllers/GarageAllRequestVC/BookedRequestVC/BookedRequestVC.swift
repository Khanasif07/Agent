//
//  BookedRequestVC.swift
//  ArabianTyres
//
//  Created by Admin on 05/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit
import DZNEmptyDataSet

class BookedRequestVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var mainTableView: UITableView!
  
    // MARK: - Variables
    //===========================
    var viewModel = BookedRequestVM()

    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
    }
    // MARK: - IBActions
    //===========================
    
    
}

// MARK: - Extension For Functions
//===========================
extension BookedRequestVC {
    
    private func initialSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(paymentSucessfullyDone), name: Notification.Name.PaymentSucessfullyDone, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateServiceStatus), name: Notification.Name.UpdateServiceStatus, object: nil)
        viewModel.delegate = self
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.emptyDataSetSource = self
        self.mainTableView.emptyDataSetDelegate = self
        self.mainTableView.enablePullToRefresh(tintColor: AppColors.appRedColor ,target: self, selector: #selector(refreshWhenPull(_:)))
        self.mainTableView.registerCell(with: LoaderCell.self)
        self.mainTableView.registerCell(with: BookedRequestTableCell.self)
        hitApi(params: [ApiKey.page:"1", ApiKey.limit: "20"],loader: false)
    }
    
    public func hitApi(params: JSONDictionary = [:],loader: Bool = false){
        viewModel.getBookedRequests(params: params,loader: loader)
        
    }
    
    @objc func updateServiceStatus() {
        hitApi(params: [ApiKey.page:"1", ApiKey.limit: "20"])
    }
    
    @objc func paymentSucessfullyDone(){
          hitApi(params: [ApiKey.page:"1", ApiKey.limit: "20"])
    }
    
    @objc func refreshWhenPull(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        hitApi(params: [ApiKey.page:"1", ApiKey.limit: "20"])
    }
}

// MARK: - Extension For TableView
//===========================
extension BookedRequestVC : UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bookedRequestListing.endIndex + (self.viewModel.showPaginationLoader ?  1: 0)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == (viewModel.bookedRequestListing.endIndex) {
            let cell = tableView.dequeueCell(with: LoaderCell.self)
            return cell
        }else {
            let cell = tableView.dequeueCell(with: BookedRequestTableCell.self, indexPath: indexPath)
            cell.bindData(viewModel.bookedRequestListing[indexPath.row])
         
            cell.chatBtnTapped = { [weak self] in
                guard let `self` = self else { return }
                AppRouter.goToOneToOneChatVC(self, userId: self.viewModel.bookedRequestListing[indexPath.row].userId ?? "" ,requestDetailId:self.viewModel.bookedRequestListing[indexPath.row].id ?? "",requestId: self.viewModel.bookedRequestListing[indexPath.row].requestDocId ?? "", name: self.viewModel.bookedRequestListing[indexPath.row].userName ?? "", image: self.viewModel.bookedRequestListing[indexPath.row].userImage ?? "",unreadMsgs: 0, garageUserId: isCurrentUserType == .garage ? UserModel.main.id : self.viewModel.bookedRequestListing[indexPath.row].userId ?? "")
            }
            
            cell.startServiceBtnTapped = { [weak self] in
                guard let `self` = self else { return }
                self.viewModel.sendOtpToStartService(params: [ApiKey.requestId: self.viewModel.bookedRequestListing[indexPath.row].id ?? ""])
                
                AppRouter.openOtpPopUpVC(vc: self, requestByUser: self.viewModel.bookedRequestListing[indexPath.row].requestedBy ?? "",requestId: self.viewModel.bookedRequestListing[indexPath.row].id ?? "") {
                    self.hitApi(params: [ApiKey.page:"1", ApiKey.limit: "20"])
                    AppRouter.goToServiceStatusVC(vc: self, requestId: self.viewModel.bookedRequestListing[indexPath.row].id ?? "",requestType: self.viewModel.bookedRequestListing[indexPath.row].requestType ?? .battery ,serviceNo: self.viewModel.bookedRequestListing[indexPath.row].requestID ?? "")
                }
            }
          
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  let paymentStatus = viewModel.bookedRequestListing[indexPath.row].paymentStatus{
            if paymentStatus == .paid{
                AppRouter.goToServiceStatusVC(vc: self, requestId: viewModel.bookedRequestListing[indexPath.row].id ?? "",requestType: viewModel.bookedRequestListing[indexPath.row].requestType ?? .battery ,serviceNo: viewModel.bookedRequestListing[indexPath.row].requestID ?? "")
            } else {
                printDebug("Do Nothing")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell as? LoaderCell != nil {
            self.viewModel.getBookedRequests(params: [ApiKey.page: self.viewModel.currentPage,ApiKey.limit : "20"],loader: false,pagination: true)
        }
    }
}


//MARK: DZNEmptyDataSetSource and DZNEmptyDataSetDelegate
//================================
extension BookedRequestVC : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return  #imageLiteral(resourceName: "layerX00201")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var emptyData = LocalizedString.noDataFound.localized
        emptyData = viewModel.bookedRequestListing.endIndex == 0 ? LocalizedString.no_service_request_available.localized : ""
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

extension BookedRequestVC : BookedRequestVMDelegate{
    func getBookedListingDataSuccess(message: String) {
        mainTableView.reloadData()
    }
    
    func getBookedListingDataFailed(error: String) {
        CommonFunctions.showToastWithMessage(error)
    }
    
  
}
