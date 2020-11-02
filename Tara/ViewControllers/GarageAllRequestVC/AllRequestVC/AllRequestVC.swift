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
    var filterApplied : Bool = false
    var filterArr : [FilterScreen] = []
    var clearFilterOnTabChange: Bool = false
    var clearFilter: (()->())?
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(bidAcceptedRejected), name: Notification.Name.BidAcceptedRejected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(placeBidRejectBidSuccess), name: Notification.Name.PlaceBidRejectBidSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(serviceRequestReceived), name: Notification.Name.ServiceRequestReceived, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestAccepted), name: Notification.Name.RequestAccepted, object: nil)
        
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
    
    public func hitApi(params: JSONDictionary = [:],loader: Bool = false){
        if isUserLoggedin {
            if filterApplied {
                viewModel.getGarageRequestData(params: params,loader: loader)
            }else {
                viewModel.getGarageRequestData(params: [ApiKey.page:"1", ApiKey.limit: "20"])
            }
        }
    }
    
    public func getFilterData(data: [FilterScreen],isPullToRefersh :Bool = false, loader: Bool = true) {
        var dict : JSONDictionary = [ApiKey.page: isPullToRefersh ? "1" : viewModel.currentPage ,ApiKey.limit : "20"]
        data.forEach { (type) in
            switch type {

            case .allRequestServiceType(let str, _):
                dict[ApiKey.requestType] = str.joined(separator: ",")

            case .allRequestByStatus(let str, _):
                dict[ApiKey.status] = str.joined(separator: ",")
            default:
                break
            }
        }
        hitApi(params: dict,loader: loader)
    }
    
    @objc func refreshWhenPull(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        if filterApplied {
            getFilterData(data: filterArr,isPullToRefersh: true,loader: false)
        }else {
            hitApi()
        }
    }
    
    @objc func serviceRequestReceived() {
        hitApi(params: [ApiKey.page:"1", ApiKey.limit: "20"])
    }
    
    @objc func placeBidRejectBidSuccess(){
        filterApplied = false
        clearFilter?()
        hitApi(params: [ApiKey.page:"1", ApiKey.limit: "20"])
    }
    
    @objc func bidAcceptedRejected(){
        hitApi(params: [ApiKey.page:"1", ApiKey.limit: "20"])
    }
    
    @objc func requestAccepted(){
        hitApi(params: [ApiKey.page:"1", ApiKey.limit: "20"])
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
                switch sender.titleLabel?.text {
                case "Cancel Bid":
                    self.requestId = self.viewModel.garageRequestListing[indexPath.row].id ?? ""
                    self.viewModel.cancelBid(params:[ApiKey.garageRequestId : self.requestId])
                case "Chat":
                    self.clearFilterOnTabChange = false
                    AppRouter.goToOneToOneChatVC(self, userId: self.viewModel.garageRequestListing[indexPath.row].userId ?? "" ,requestId: self.viewModel.garageRequestListing[indexPath.row].requestID ?? "", name: self.viewModel.garageRequestListing[indexPath.row].userName ?? "", image: self.viewModel.garageRequestListing[indexPath.row].userImage ?? "", unreadMsgs: 0)
                default:
                    self.clearFilterOnTabChange = false
                    AppRouter.goToGarageServiceRequestVC(vc: self,requestId : self.viewModel.garageRequestListing[indexPath.row].id ?? "", requestType: self.viewModel.garageRequestListing[indexPath.row].requestType.rawValue,bidStatus: self.viewModel.garageRequestListing[indexPath.row].bidStatus ?? .bidFinalsed)
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
            if filterApplied {
                getFilterData(data: filterArr,loader: false)

            }else {
             self.viewModel.getGarageRequestData(params: [ApiKey.page: self.viewModel.currentPage,ApiKey.limit : "20"],loader: false,pagination: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.clearFilterOnTabChange = false
        AppRouter.goToGarageServiceRequestVC(vc: self,requestId : self.viewModel.garageRequestListing[indexPath.row].id ?? "", requestType: self.viewModel.garageRequestListing[indexPath.row].requestType.rawValue, bidStatus: self.viewModel.garageRequestListing[indexPath.row].bidStatus ?? .bidFinalsed)
    }
}

extension AllRequestVC : AllRequestVMDelegate ,UserServiceRequestVCDelegate{
    func resendUserMyRequestDetailSuccess(requestId: String) {
        self.hitApi()
    }
    
    func rejectUserMyRequestDetailSuccess(requestId: String) {
        let index =  self.viewModel.garageRequestListing.firstIndex(where: { (model) -> Bool in
            return model.id == requestId
        })
        guard let selectedIndex = index else {return}
        self.viewModel.garageRequestListing.remove(at: selectedIndex)
        self.mainTableView.reloadData()
    }
    
    func rejectGarageRequestSuccess(message: String) {
        let index =  self.viewModel.garageRequestListing.firstIndex(where: { (model) -> Bool in
            return model.id == requestId
        })
        guard let selectedIndex = index else {return}
        self.viewModel.garageRequestListing.remove(at: selectedIndex)
        self.mainTableView.reloadData()
    }
    
    func rejectGarageRequestFailure(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func getGarageListingDataSuccess(message: String) {
        mainTableView.reloadData()
    }
    
    func getGarageListingDataFailed(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func cancelUserMyRequestDetailSuccess(requestId: String){
           let index =  self.viewModel.garageRequestListing.firstIndex(where: { (model) -> Bool in
               return model.id == requestId
           })
           guard let selectedIndex = index else {return}
           self.viewModel.garageRequestListing[selectedIndex].bidStatus = BidStatus(rawValue: "Open For Biding")
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
        return  #imageLiteral(resourceName: "layerX00201")
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
