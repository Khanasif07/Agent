//
//  ServiceCompletedVC.swift
//  Tara
//
//  Created by Arvind on 06/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ServiceCompletedVC: BaseVC {
 
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    let viewModel = ServiceCompletedVM()
    var garageId : String = ""
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func cancelBtnAction(_ sender: Any) {
        pop()
    }
}

// MARK: - Extension For Functions
//===========================
extension ServiceCompletedVC {
    
    private func initialSetup() {
        viewModel.delegate = self
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.contentInset = UIEdgeInsets(top: 8.0, left: 0, bottom: 0, right: 0)
        self.mainTableView.enablePullToRefresh(tintColor: AppColors.appRedColor ,target: self, selector: #selector(refreshWhenPull(_:)))
        self.mainTableView.registerCell(with: LoaderCell.self)
        mainTableView.registerCell(with: ServiceCompletedTableViewCell.self)
        hitApi(loader: true)
    }

    private func setupTextAndFont(){
        titleLbl.text = LocalizedString.rateService.localized
    }
    
    private func hitApi(loader: Bool = false) {
        let dict = [ApiKey.page:"1", ApiKey.limit: "20"]
        viewModel.fetchServiceCompleteListing(params: dict, loader: loader)
    }
    
    @objc func refreshWhenPull(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        hitApi(loader: false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell as? LoaderCell != nil {
//            self.viewModel.fetchReviewListing(params: [ApiKey.page: self.viewModel.currentPage,ApiKey.limit : "20"],loader: false)
        }
    }
}

extension ServiceCompletedVC :UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: ServiceCompletedTableViewCell.self, indexPath: indexPath)
//        cell.bindData(viewModel.reviewListingArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension ServiceCompletedVC: ServiceCompletedVMDelegate{

    func serviceCompleteApiSuccess(msg: String) {
        mainTableView.reloadData()
    }
    
    func serviceCompleteApiFailure(msg: String) {
        
    }
}
