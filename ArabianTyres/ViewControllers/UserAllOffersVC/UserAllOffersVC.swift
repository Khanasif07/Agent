//
//  UserAllOffersVC.swift
//  ArabianTyres
//
//  Created by Admin on 09/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class UserAllOffersVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
 
    // MARK: - Variables
    //===========================
    var requestId: String = ""
    let viewModel = UserAllOfferVM()
    var filterArr : [FilterScreen] = [.distance("","", false), .bidReceived("",false)]

    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func filterBtnAction(_ sender: UIButton) {
        AppRouter.goOfferFilterVC(vc: self, filterArr: filterArr) {[weak self] (filterData, isReset) in
            if isReset {
                self?.getFilterData(data: filterData)
            }else {
                self?.hitApi()
            }
            self?.filterArr = filterData
        }
    }
}

// MARK: - Extension For Functions
//===========================
extension UserAllOffersVC {
    
    private func initialSetup() {
        setupTextAndFont()
        setupTableView()
        viewModel.delegate = self
        hitApi()
    }
    
    private func setupTableView() {
        mainTableView.contentInset = UIEdgeInsets(top: 0.0, left: 0, bottom: 0, right: 0)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        self.mainTableView.emptyDataSetSource = self
        self.mainTableView.emptyDataSetDelegate = self
        self.mainTableView.enablePullToRefresh(tintColor: AppColors.appRedColor ,target: self, selector: #selector(refreshWhenPull(_:)))
        mainTableView.registerCell(with: UserOffersTableCell.self)
    }
    
    @objc func refreshWhenPull(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        hitApi()
    }
    
    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
    }
    
    private func hitApi(params: JSONDictionary = [:]) {
        if params.isEmpty {
            let dict : JSONDictionary = [ApiKey.page: "1",ApiKey.limit : "20", ApiKey.requestId : self.requestId]
            viewModel.getUserBidData(params: dict)
        }else {
            viewModel.getUserBidData(params: params)

        }
    }
    
    private func getFilterData(data: [FilterScreen]) {
        var dict : JSONDictionary = [ApiKey.page: "1",ApiKey.limit : "20",ApiKey.requestId : self.requestId]
        data.forEach { (type) in
            switch type {
                
            case .bidReceived(let txt, _):
                dict[ApiKey.bidSort] = txt
                
            case .distance(let min, let max, _):
                dict[ApiKey.maxDistance] = max
                dict[ApiKey.minDistance] = min

            default:
                break
            }
        }
        hitApi(params: dict)
    }
}

// MARK: - Extension For TableView
//===========================
extension UserAllOffersVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userBidListingArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: UserOffersTableCell.self, indexPath: indexPath)
        cell.bindData(viewModel.userBidListingArr[indexPath.row])
        cell.viewProposalAction = { [weak self] (sender) in
            guard let `self` = self else { return }
            AppRouter.presentOfferDetailVC(vc: self,bidId: self.viewModel.userBidListingArr[indexPath.row].id, garageName: self.viewModel.userBidListingArr[indexPath.row].garageName ?? "", completion: {
                self.hitApi()
            })
        }
        cell.rejectAction = { [weak self] (sender) in
            guard let `self` = self else { return }
            self.viewModel.rejectUserBidData(params: [ApiKey.bidId: self.viewModel.userBidListingArr[indexPath.row].id])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK: UserAllOfferVMDelegate
//================================
extension UserAllOffersVC : UserAllOfferVMDelegate {
    func rejectUserBidDataSuccess(message: String) {
         hitApi()
         mainTableView.reloadData()
    }
    
    func rejectUserBidDataFailed(error: String) {
         ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func getUserBidDataSuccess(message: String){
        mainTableView.reloadData()
    }
    
    func getUserBidDataFailed(error:String){
        ToastView.shared.showLongToast(self.view, msg: error)
    }
}

//MARK: DZNEmptyDataSetSource and DZNEmptyDataSetDelegate
//================================
extension UserAllOffersVC : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return  nil
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var emptyData = ""
        emptyData =  self.viewModel.userBidListingArr.endIndex  == 0 ? "No data found" : ""
        return NSAttributedString(string: emptyData , attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontTertiaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(18)])
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
