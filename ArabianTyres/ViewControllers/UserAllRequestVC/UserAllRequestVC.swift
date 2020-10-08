//
//  UserAllRequestVC.swift
//  ArabianTyres
//
//  Created by Admin on 06/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class UserAllRequestVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var viewModel = UserAllRequestVM()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func searchBtnAction(_ sender: UIButton) {
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension UserAllRequestVC {
    
    private func initialSetup() {
        self.tableViewSetUp()
        hitListingApi()
    }
    
    private func tableViewSetUp(){
        viewModel.delegate = self
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
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
