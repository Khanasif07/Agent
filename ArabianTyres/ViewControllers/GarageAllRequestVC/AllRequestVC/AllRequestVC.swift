//
//  AllRequestVC.swift
//  ArabianTyres
//
//  Created by Admin on 05/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import UIKit
import DZNEmptyDataSet

class AllRequestVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var viewModel = AllRequestVM()
    var requestId : String = ""
    
    
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
        self.mainTableView.reloadData()
    }
    
    // MARK: - IBActions
    //===========================
    
    
}

// MARK: - Extension For Functions
//===========================
extension AllRequestVC {
    
    private func initialSetup() {
        viewModel.delegate = self
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        mainTableView.emptyDataSetSource = self
        mainTableView.emptyDataSetDelegate = self
        self.mainTableView.enablePullToRefresh(tintColor: AppColors.appRedColor ,target: self, selector: #selector(refreshWhenPull(_:)))
        self.mainTableView.registerCell(with: LoaderCell.self)
        self.mainTableView.registerCell(with: ServiceRequestTableCell.self)
        hitApi()
    }
    
    public func hitApi(params: JSONDictionary = [:]){
        if params.isEmpty {
            viewModel.getGarageRequestData(params: [ApiKey.page:"1", ApiKey.limit: "10"], pagination: false)
        }else {
            viewModel.getGarageRequestData(params: params,loader: true)
        }
    }
   
    @objc func refreshWhenPull(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        hitApi()
    }
}

// MARK: - Extension For TableView
//===========================
extension AllRequestVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.garageRequestListing.endIndex + (self.viewModel.showPaginationLoader ?  1: 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == (viewModel.garageRequestListing.endIndex) {
            let cell = tableView.dequeueCell(with: LoaderCell.self)
            return cell
        } else {
            let cell = tableView.dequeueCell(with: ServiceRequestTableCell.self, indexPath: indexPath)
            cell.bindData(viewModel.garageRequestListing[indexPath.row])
      
            cell.rejectRequestBtnTapped = {[weak self] in
                guard let `self` = self else {return}
                self.requestId = self.viewModel.garageRequestListing[indexPath.row].id ?? ""
                self.viewModel.rejectGarageRequest(params:[ApiKey.requestId : self.requestId])
            }
       
            cell.placeBidBtnTapped = {[weak self] (sender) in
                guard let `self` = self else {return}
                if sender.titleLabel?.text == "Cancel Bid" {
                self.requestId = self.viewModel.garageRequestListing[indexPath.row].id ?? ""
                self.viewModel.cancelBid(params:[ApiKey.garageRequestId : self.requestId])

                }else {
                    if let selectedIndex = tableView.indexPath(for: cell) {
                        AppRouter.goToGarageServiceRequestVC(vc: self,requestId : self.viewModel.garageRequestListing[selectedIndex.row].id ?? "", requestType: self.viewModel.garageRequestListing[selectedIndex.row].requestType.rawValue)
                    }
                    
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell as? LoaderCell != nil {
            self.viewModel.getGarageRequestData(params: [ApiKey.page: self.viewModel.currentPage,ApiKey.limit : "10"],loader: false,pagination: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        AppRouter.goToGarageServiceRequestVC(vc: self,requestId : viewModel.garageRequestListing[indexPath.row].id ?? "")
    }
}

extension AllRequestVC : AllRequestVMDelegate ,UserServiceRequestVCDelegate{
    func getGarageListingDataSuccess(message: String) {
        mainTableView.reloadData()
    }
    
    func getGarageListingDataFailed(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func cancelGarageRequestSuccess(message: String) {
        cancelUserMyRequestDetailSuccess(requestId: self.requestId)
        
    }
    func cancelGarageRequestFailure(error:String) {
        ToastView.shared.showLongToast(self.view, msg: error)

    }
   
    func cancelUserMyRequestDetailSuccess(requestId: String){
           let index =  self.viewModel.garageRequestListing.firstIndex(where: { (model) -> Bool in
               return model.id == requestId
           })
           guard let selectedIndex = index else {return}
           self.viewModel.garageRequestListing.remove(at: selectedIndex)
           self.mainTableView.reloadData()
    }
    
    func cancelBidSuccess(message: String){
        cancelUserMyRequestDetailSuccess(requestId: self.requestId)
    }
    
    func cancelBidFailure(error:String){
        ToastView.shared.showLongToast(self.view, msg: error)
    }
}

//MARK: DZNEmptyDataSetSource and DZNEmptyDataSetDelegate
//================================
extension AllRequestVC : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return  nil
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var emptyData = ""
        emptyData = viewModel.garageRequestListing.endIndex == 0 ? "No data found" : ""
    
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
