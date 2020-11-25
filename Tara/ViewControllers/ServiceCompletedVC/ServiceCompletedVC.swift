//
//  ServiceCompletedVC.swift
//  Tara
//
//  Created by Arvind on 06/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ServiceCompletedVC : BaseVC {
    
    enum ScreenType {
        case serviceComplete
        case serviceHistory
        
        var titleText : String{
            switch self {
                
            case .serviceComplete:
                return LocalizedString.serviceCompleted.localized
            case .serviceHistory:
                return LocalizedString.service_history.localized
            }
        }
    }
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    let viewModel = ServiceCompletedVM()
    var garageId : String = ""
    var screenType : ScreenType = .serviceComplete
    
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
        setupTextAndFont()
        viewModel.delegate = self
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.contentInset = UIEdgeInsets(top: 8.0, left: 0, bottom: 0, right: 0)
        mainTableView.emptyDataSetSource = self
        mainTableView.emptyDataSetDelegate = self
        self.mainTableView.enablePullToRefresh(tintColor: AppColors.appRedColor ,target: self, selector: #selector(refreshWhenPull(_:)))
        self.mainTableView.registerCell(with: LoaderCell.self)
        mainTableView.registerCell(with: ServiceCompletedTableViewCell.self)
        hitApi(loader: true)
    }

    private func setupTextAndFont(){
        titleLbl.text = screenType == .serviceComplete ? LocalizedString.serviceCompleted.localized : LocalizedString.service_history.localized
       
    }
    
    private func hitApi(loader: Bool = false) {
        let dict = [ApiKey.page:"1", ApiKey.limit: "20"]
        screenType == .serviceComplete ? viewModel.fetchServiceCompleteListing(params: dict, loader: loader) :
            viewModel.fetchUserServiceHistory(params: dict, loader: loader)
        
    }
    
    @objc func refreshWhenPull(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        hitApi(loader: false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell as? LoaderCell != nil {
            if screenType == .serviceComplete {
                self.viewModel.fetchServiceCompleteListing(params: [ApiKey.page: self.viewModel.currentPage,ApiKey.limit : "20"],loader: false)
            }else {
                self.viewModel.fetchUserServiceHistory(params: [ApiKey.page: self.viewModel.currentPage,ApiKey.limit : "20"],loader: false)
            }
        }
    }
}

extension ServiceCompletedVC :UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.serviceCompletedListing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: ServiceCompletedTableViewCell.self, indexPath: indexPath)
        cell.bindData(viewModel.serviceCompletedListing[indexPath.row],screenType: self.screenType)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if screenType == .serviceComplete {
            AppRouter.goToGarageCustomerRatingVC(vc: self, requestId: viewModel.serviceCompletedListing[indexPath.row].id ?? "",name : viewModel.serviceCompletedListing[indexPath.row].userName ?? "")
            
        }else {
            
        }
    }
}

extension ServiceCompletedVC: ServiceCompletedVMDelegate{

    func serviceCompleteApiSuccess(msg: String) {
        mainTableView.reloadData()
    }
    
    func serviceCompleteApiFailure(msg: String) {
        
    }
}


//MARK: DZNEmptyDataSetSource and DZNEmptyDataSetDelegate
//================================
extension ServiceCompletedVC : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return  #imageLiteral(resourceName: "layerX00201")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var emptyData = ""
        emptyData = viewModel.serviceCompletedListing.endIndex == 0 ? "No data found" : ""
    
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
