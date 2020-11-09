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
    
    // MARK: - IBActions
    //===========================
    
    
}

// MARK: - Extension For Functions
//===========================
extension BookedRequestVC {
    
    private func initialSetup() {
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
            cell.startServiceBtnTapped = {[weak self] in
                guard let `self` = self else { return }
                AppRouter.openOtpPopUpVC(vc: self, requestByUser: self.viewModel.bookedRequestListing[indexPath.row].requestedBy ?? "",requestId: self.viewModel.bookedRequestListing[indexPath.row].id ?? "")
            }
            cell.chatBtnTapped = {[weak self] in
                self?.showAlert(msg: LocalizedString.underDevelopment.localized)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppRouter.goToServiceStatusVC(vc: self, requestId: viewModel.bookedRequestListing[indexPath.row].id ?? "",requestType: viewModel.bookedRequestListing[indexPath.row].requestType)
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
        var emptyData = "No data found"
        emptyData = viewModel.bookedRequestListing.endIndex == 0 ? "No data found" : ""
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
