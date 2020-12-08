//
//  PaymentListingVC.swift
//  Tara
//
//  Created by Arvind on 21/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class PaymentListingVC : BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    let viewModel = PaymentListingVM()
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
    @IBAction func backBtnAction(_ sender: Any) {
        pop()
    }
}

// MARK: - Extension For Functions
//===========================
extension PaymentListingVC {
    
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
        mainTableView.registerCell(with: PaymentListingCell.self)
//        hitApi(loader: true)
    }
    
    private func setupTextAndFont(){
        titleLbl.text = LocalizedString.payments.localized
        
    }
    
    private func hitApi(loader: Bool = false) {
        let dict = [ApiKey.page:"1", ApiKey.limit: "20"]
        viewModel.fetchPaymentListing(params: dict, loader: loader)
        
    }
    
    @objc func refreshWhenPull(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        hitApi(loader: false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell as? LoaderCell != nil {
                self.viewModel.fetchPaymentListing(params: [ApiKey.page: self.viewModel.currentPage,ApiKey.limit : "20"],loader: false)
           
        }
    }
}

extension PaymentListingVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4//viewModel.paymentListing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: PaymentListingCell.self, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension PaymentListingVC: PaymentListingVMDelegate{
   
    func paymentListingApiSuccess(msg: String) {
        mainTableView.reloadData()
    }
    
    func paymentListingApiFailure(msg: String) {
    
    }
}


//MARK: DZNEmptyDataSetSource and DZNEmptyDataSetDelegate
//================================
extension PaymentListingVC : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return  #imageLiteral(resourceName: "layerX00201")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var emptyData = ""
        emptyData = viewModel.paymentListing.endIndex == 0 ? LocalizedString.noDataFound.localized : ""
    
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
