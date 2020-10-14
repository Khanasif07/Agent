//
//  OffersDetailVC.swift
//  ArabianTyres
//
//  Created by Admin on 12/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class OffersDetailVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var unitLbl: UILabel!
    @IBOutlet weak var unitPriceLbl: UILabel!
    @IBOutlet weak var brandsLbl: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var acceptBtn: AppButton!
    @IBOutlet weak var rejectBtn: AppButton!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var viewModel = OffersDetailVM()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func acceptBtnAction(_ sender: UIButton) {
        let index =  self.viewModel.userBidDetail.bidData.firstIndex { (model) -> Bool in
            return model.isSelected == true
        }
        guard let selectedIndex = index else { return }
        self.viewModel.acceptUserBidData(params: [ApiKey.bidId:self.viewModel.bidId,ApiKey.id: self.viewModel.userBidDetail.bidData[selectedIndex].id] )
    }
    
    @IBAction func rejectBtnAction(_ sender: UIButton) {
        self.viewModel.rejectUserBidData(params: [ApiKey.bidId:self.viewModel.bidId] )
    }
    
    @IBAction func crossBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Extension For Functions
//===========================
extension OffersDetailVC {
    
    private func initialSetup() {
        acceptBtn.isEnabled = false
        rejectBtn.isBorderSelected = true
        setupTextAndFont()
        setupTableView()
    }
    
    private func setupTableView() {
        self.viewModel.delegate = self
        mainTableView.contentInset = UIEdgeInsets(top: 0.0, left: 0, bottom: 0, right: 0)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.emptyDataSetSource = self
        mainTableView.emptyDataSetDelegate = self
        mainTableView.registerCell(with: OffersDetailTableCell.self)
        mainTableView.tableHeaderView = headerView
        hitApi()
    }
    
    private func hitApi(){
        self.viewModel.getOfferDetailData(params: [ApiKey.bidId:self.viewModel.bidId ])
    }
    
    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        [totalPriceLbl,unitLbl,unitPriceLbl,brandsLbl].forEach({$0?.textColor = AppColors.fontTertiaryColor})
        //           titleLbl.text = LocalizedString.tyreServiceRequest.localized
    }
}

// MARK: - Extension For TableView
//===========================
extension OffersDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.userBidDetail.bidData.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: OffersDetailTableCell.self, indexPath: indexPath)
        cell.populateData(isBrandSelected: self.viewModel.userBidDetail.bidData[indexPath.row].isSelected ?? false,model:  self.viewModel.userBidDetail.bidData[indexPath.row])
        cell.dashBackgroundView.isHidden = !(self.viewModel.userBidDetail.bidData.endIndex - 1 == indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       acceptBtn.isEnabled = true
       let index =  self.viewModel.userBidDetail.bidData.firstIndex { (model) -> Bool in
            return model.isSelected == true
        }
        guard let selectedIndex = index else {
            self.viewModel.userBidDetail.bidData[indexPath.row].isSelected = true
            self.mainTableView.reloadData()
            return }
        self.viewModel.userBidDetail.bidData[selectedIndex].isSelected = false
        self.viewModel.userBidDetail.bidData[indexPath.row].isSelected = true
        self.mainTableView.reloadData()
    }
}

// MARK: - Extension For getOfferDetailData
//========================================
extension OffersDetailVC : OffersDetailVMDelegate {
    func rejectUserBidDataSuccess(message: String) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func rejectUserBidDataFailed(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func acceptUserBidDataFailed(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func getOfferDetailSuccess(message: String) {
         self.mainTableView.reloadData()
    }
    
    func getOfferDetailFailed(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func acceptUserBidDataSuccess(message: String) {
         self.mainTableView.reloadData()
    }
}

// MARK: - Extension For DZNEmptyDataSetSource
//========================================
extension OffersDetailVC: DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    
       func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
           return  nil
       }
       
       func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
           return NSAttributedString(string:"No data found" , attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontTertiaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(18)])
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
