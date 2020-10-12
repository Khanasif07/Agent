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
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var viewModel = UserAllRequestVM()
    var filterArr : [FilterScreen] = [.byServiceType("",false), .byStatus("",false), .date(nil,nil,false)]
    
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
    @IBAction func searchBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func filterBtnAction(_ sender: UIButton) {
        AppRouter.goToMyServiceFilterVC(vc: self, filterArr: filterArr) {[weak self] (filterData) in
            self?.getFilterData(data: filterData)
            self?.filterArr = filterData
        }
    }
    
}

// MARK: - Extension For Functions
//===========================
extension UserAllRequestVC {
    
    private func initialSetup() {
        self.filterBtn.tintColor = .black
        self.tableViewSetUp()
        hitListingApi()
    }
    
    private func getFilterData(data: [FilterScreen]) {
        var dict : JSONDictionary = [ApiKey.page: "1",ApiKey.limit : "20"]
        data.forEach { (type) in
            switch type {
                
            case .byServiceType(let str, _):
                dict[ApiKey.type] = str
                
            case .byStatus(let str, _):
                dict[ApiKey.status] = str
                
            case .date(let fromDate, let toDate, _):
                
                if let fDate = fromDate ,let tDate = toDate {
                    dict[ApiKey.startdate] = fDate.toString(dateFormat: Date.DateFormat.yyyyMMddTHHmmsssssz.rawValue)
                    dict[ApiKey.endDate] =  tDate.toString(dateFormat: Date.DateFormat.yyyyMMddTHHmmsssssz.rawValue)
                    
                }
                
            default:
                break
            }
        }
        self.viewModel.getUserMyRequestData(params: dict,loader: true)
    }
    
    private func tableViewSetUp(){
        viewModel.delegate = self
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.emptyDataSetSource = self
        self.mainTableView.emptyDataSetDelegate = self
        self.mainTableView.enablePullToRefresh(tintColor: AppColors.appRedColor ,target: self, selector: #selector(refreshWhenPull(_:)))
        self.mainTableView.registerCell(with: LoaderCell.self)
        self.mainTableView.registerCell(with: MyServiceTableCell.self)
    }
    
    private func hitListingApi(){
        self.viewModel.getUserMyRequestData(params: [ApiKey.page: "1",ApiKey.limit : "20"],loader: true)
    }
    
    @objc func refreshWhenPull(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        hitListingApi()
    }
}

// MARK: - Extension For TableView
//===========================
extension UserAllRequestVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.userRequestListing.endIndex + (self.viewModel.showPaginationLoader ?  1: 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == (viewModel.userRequestListing.endIndex) {
            let cell = tableView.dequeueCell(with: LoaderCell.self)
            return cell
        } else {
            let cell = tableView.dequeueCell(with: MyServiceTableCell.self, indexPath: indexPath)
            cell.populateData(model: self.viewModel.userRequestListing[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppRouter.goToUserServiceRequestVC(vc: self,requestId:self.viewModel.userRequestListing[indexPath.row].id )
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell as? LoaderCell != nil {
            self.viewModel.getUserMyRequestData(params: [ApiKey.page: "1",ApiKey.limit : "20"],loader: false)
        }
    }
}


// MARK: - Extension For TableView
//===========================
extension UserAllRequestVC: UserAllRequestVMDelegate{
    func getUserMyRequestDataSuccess(message: String){
        self.mainTableView.reloadData()
    }
    func mgetUserMyRequestDataFailed(error:String){
        ToastView.shared.showLongToast(self.view, msg: error)
    }
}

// MARK: - Extension For TableView
//===========================
extension UserAllRequestVC : UserServiceRequestVCDelegate{
   
    func cancelUserMyRequestDetailSuccess(requestId: String){
        let index =  self.viewModel.userRequestListing.firstIndex(where: { (model) -> Bool in
            return model.id == requestId
        })
        guard let selectedIndex = index else {return}
        self.viewModel.userRequestListing.remove(at: selectedIndex)
        self.mainTableView.reloadData()
    }
}


//MARK: DZNEmptyDataSetSource and DZNEmptyDataSetDelegate
//================================
extension UserAllRequestVC : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return  nil
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No data found" , attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontTertiaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(18)])
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
        if let tableView = scrollView as? UITableView, tableView.numberOfSections == 0 {
            return true
        }
        return false
    }
}
