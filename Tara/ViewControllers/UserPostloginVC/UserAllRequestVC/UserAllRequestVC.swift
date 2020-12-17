//
//  UserAllRequestVC.swift
//  ArabianTyres
//
//  Created by Admin on 06/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class UserAllRequestVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var viewModel = UserAllRequestVM()
    var filterArr : [FilterScreen] = [.byServiceType([],false), .byStatus([],false), .date(nil,nil,false)]
    var filterApplied: Bool = false
    var clearFilterOnTabChange: Bool = false
    var pdfURL : URL?
    
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
        if filterApplied {
            if !clearFilterOnTabChange {
                clearFilterOnTabChange = !clearFilterOnTabChange
            } else {
                filterApplied = false
                filterArr = [.byServiceType([],false), .byStatus([],false), .date(nil,nil,false)]
                hitListingApi()
            }
        }
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func filterBtnAction(_ sender: UIButton) {
        clearFilterOnTabChange = false
        AppRouter.goToMyServiceFilterVC(vc: self, filterArr: filterArr) {[weak self] (filterData, isReset) in
            if isReset {
                self?.viewModel.currentPage = 1
                self?.filterApplied = true
                self?.getFilterData(data: filterData)
            }else {
                self?.filterApplied = false
                self?.viewModel.getUserMyRequestData(params: [ApiKey.page: "1",ApiKey.limit : "10"],loader: true)
            }
            self?.filterArr = filterData
        }
    }
}

// MARK: - Extension For Functions
//===========================
extension UserAllRequestVC {
    
    private func initialSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(paymentSucessfullyDone), name: Notification.Name.PaymentSucessfullyDone, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newBidSocketSuccess), name: Notification.Name.NewBidSocketSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userServiceAcceptRejectSuccess), name: Notification.Name.UserServiceAcceptRejectSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ServiceRequestSuccess), name: Notification.Name.ServiceRequestSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestRejected), name: Notification.Name.RequestRejected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BidCancelled), name: Notification.Name.BidCancelled, object: nil)
        
        
        self.filterBtn.tintColor = .black
        self.filterBtn.isHidden = !isUserLoggedin
        self.titleLbl.text = LocalizedString.my_Services.localized
        self.tableViewSetUp()
        hitListingApi()
    }
    
    private func getFilterData(data: [FilterScreen],loader: Bool = true,isPullToRefersh :Bool = false) {
        
        var dict : JSONDictionary = [ApiKey.page: isPullToRefersh ? "1" : viewModel.currentPage, ApiKey.limit : "20"]
        data.forEach { (type) in
            switch type {
                
            case .byServiceType(let arr, _):
                dict[ApiKey.type] = arr.joined(separator: ",")
                
            case .byStatus(let arr, _):
                dict[ApiKey.status] = arr.joined(separator: ",")
                
            case .date(let fromDate, let toDate, _):
                
                if let fDate = fromDate {
                    dict[ApiKey.startdate] = fDate.toString(dateFormat: Date.DateFormat.yyyyMMddTHHmmsssssz.rawValue)
                }
                
                if let tDate = toDate {
                    dict[ApiKey.endDate] =  tDate.toString(dateFormat: Date.DateFormat.yyyyMMddTHHmmsssssz.rawValue)
                }
    
            default:
                break
            }
        }
        
        self.viewModel.getUserMyRequestData(params: dict,loader: loader)
    }
    
    private func tableViewSetUp(){
        viewModel.delegate = self
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.emptyDataSetSource = self
        self.mainTableView.emptyDataSetDelegate = self
        self.mainTableView.enablePullToRefresh(tintColor: AppColors.appRedColor ,target: self, selector: #selector(refreshWhenPull(_:)))
        self.mainTableView.registerCell(with: LoaderCell.self)
        self.mainTableView.registerCell(with: ProfileGuestTableCell.self)
        self.mainTableView.registerCell(with: MyServiceTableCell.self)
    }
    
    private func hitListingApi(){
        if isUserLoggedin {
            if filterApplied {
                getFilterData(data: filterArr,loader: false)
            }else {
                self.viewModel.getUserMyRequestData(params: [ApiKey.page: "1",ApiKey.limit : "20"],loader: false,pagination: false)
            }
        }
    }
    
    @objc func refreshWhenPull(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        if filterApplied {
            getFilterData(data: filterArr,loader: false,isPullToRefersh: true)
        }else {
            self.hitListingApi()
        }
    }
    
    @objc func ServiceRequestSuccess(){
        if filterApplied {
            getFilterData(data: filterArr,loader: false)
        }else {
            self.hitListingApi()
        }
    }
    
    @objc func paymentSucessfullyDone(){
        if filterApplied {
            getFilterData(data: filterArr,loader: false)
        }else {
            self.hitListingApi()
        }
    }
    
    @objc func userServiceAcceptRejectSuccess(){
        if filterApplied {
            getFilterData(data: filterArr,loader: false)
        }else {
            self.hitListingApi()
        }
    }
    
    @objc func newBidSocketSuccess(){
        if filterApplied {
            getFilterData(data: filterArr,loader: false)
        }else {
            self.hitListingApi()
        }
    }
    
    @objc func requestRejected(){
        if filterApplied {
            getFilterData(data: filterArr,loader: false)
        }else {
            self.hitListingApi()
        }
    }
    
    private func returnCellCount()->  Int{
        if isUserLoggedin {
           return self.viewModel.userRequestListing.endIndex + (self.viewModel.showPaginationLoader ?  1: 0)
        } else {
            self.mainTableView.isScrollEnabled = false
            return 1
        }
    }
    
    @objc func BidCancelled() {
        if filterApplied {
            getFilterData(data: filterArr,loader: false)
        }else {
            self.hitListingApi()
        }
    }
    
}

// MARK: - Extension For TableView
//===========================
extension UserAllRequestVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.returnCellCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isUserLoggedin {
            if indexPath.row == (viewModel.userRequestListing.endIndex) {
                let cell = tableView.dequeueCell(with: LoaderCell.self)
                return cell
            } else {
                let cell = tableView.dequeueCell(with: MyServiceTableCell.self, indexPath: indexPath)
                cell.populateData(model: self.viewModel.userRequestListing[indexPath.row])
                cell.downloadInvoiceBtnTapped = {[weak self] in
                   guard let `self` = self else { return }
                    self.viewModel.fetchPaymentInvoiceData(params: [ApiKey.requestId: self.viewModel.userRequestListing[indexPath.row].id])
                }
                cell.needHelpBtnTapped = { [weak self] in
                    guard let `self` = self else { return }
                    AppRouter.goToOneToOneChatVC(self, userId: AppConstants.adminId, requestId: "", name: LocalizedString.supportChat.localized, image: "", unreadMsgs: 0, isSupportChat: true,garageUserId: isCurrentUserType == .garage ? UserModel.main.id : AppConstants.adminId )
                    
                }
                return cell
            }
        }else{
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clearFilterOnTabChange = false
        if isUserLoggedin {
        AppRouter.goToUserServiceRequestVC(vc: self,requestId:self.viewModel.userRequestListing[indexPath.row].id,serviceType:self.viewModel.userRequestListing[indexPath.row].requestType )
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell as? LoaderCell != nil {
            if isUserLoggedin {
                if filterApplied {
                    getFilterData(data: filterArr,loader: false)
                }else {
                    self.viewModel.getUserMyRequestData(params: [ApiKey.page: self.viewModel.currentPage, ApiKey.limit : "20"],loader: false,pagination: true)
                }
            }
        }
    }
}


// MARK: - Extension For TableView
//===========================
extension UserAllRequestVC: UserAllRequestVMDelegate{
    func fetchPaymentInvoiceSuccess(message: String,pdfUrl: String) {
        self.downloadPdfFromUrl(urlString: pdfUrl)
    }
    
    func fetchPaymentInvoiceFailed(error: String) {
        CommonFunctions.showToastWithMessage(error)
    }
    
    func getUserMyRequestDataSuccess(message: String){
        self.mainTableView.reloadData()
    }
    func mgetUserMyRequestDataFailed(error:String){
         CommonFunctions.showToastWithMessage(error)
    }
    
    func resendRequsetSuccess(message: String) {
        
    }
    
    func resendRequsetFailure(error: String) {
         CommonFunctions.showToastWithMessage(error)
    }
}

// MARK: - Extension For TableView
//===========================
extension UserAllRequestVC : UserServiceRequestVCDelegate{
    func resendUserMyRequestDetailSuccess(requestId: String) {
        self.hitListingApi()
    }
    
    func rejectUserMyRequestDetailSuccess(requestId: String) {
        let index =  self.viewModel.userRequestListing.firstIndex(where: { (model) -> Bool in
            return model.id == requestId
        })
        guard let selectedIndex = index else {return}
        self.viewModel.userRequestListing.remove(at: selectedIndex)
        self.mainTableView.reloadData()
    }
    
    func cancelUserMyRequestDetailSuccess(requestId: String){
        let index =  self.viewModel.userRequestListing.firstIndex(where: { (model) -> Bool in
            return model.id == requestId
        })
        guard let selectedIndex = index else {return}
        self.viewModel.userRequestListing[selectedIndex].status = .cancelled
        self.mainTableView.reloadData()
    }
}


//MARK: DZNEmptyDataSetSource and DZNEmptyDataSetDelegate
//================================
extension UserAllRequestVC : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return  #imageLiteral(resourceName: "layerX00201")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var emptyData = ""
        emptyData =  self.viewModel.userRequestListing.endIndex  == 0 ? LocalizedString.no_service_request_available.localized : ""
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

// MARK: - Extension For Downloading Pdf
//===========================
extension UserAllRequestVC : URLSessionDownloadDelegate {
    
    func downloadPdfFromUrl(urlString: String){
        guard let url = URL(string: urlString) else { return }
        
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

//        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            self.pdfURL = destinationURL
            printDebug(self.pdfURL)
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}
