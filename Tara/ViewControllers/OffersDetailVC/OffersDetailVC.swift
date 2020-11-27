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
    @IBOutlet weak var thisBidProposedLbl: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var acceptBtn: AppButton!
    @IBOutlet weak var rejectBtn: AppButton!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var countryCollView: UICollectionView!
    @IBOutlet weak var unitPrizeView: UIView!

    // MARK: - Variables
    //===========================
    var viewModel = OffersDetailVM()
    var indexPath: IndexPath?
    var proposalBtnTapped :(()->())?
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func acceptBtnAction(_ sender: UIButton) {
        let index =  self.viewModel.bidData.firstIndex { (model) -> Bool in
            return model.isAccepted == true
        }
        guard let selectedIndex = index else { return }
        self.viewModel.acceptUserBidData(params: [ApiKey.bidId:self.viewModel.bidId,ApiKey.id: self.viewModel.bidData[selectedIndex].id] )
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
        NotificationCenter.default.addObserver(self, selector: #selector(newBidSocketSuccess), name: Notification.Name.NewBidSocketSuccess, object: nil)
        acceptBtn.isEnabled = true
        rejectBtn.isBorderSelected = true
        setupTextAndFont()
        setupTableView()
        setupCollView()
        
        
        var str: NSMutableAttributedString = NSMutableAttributedString()
        
        str = NSMutableAttributedString(string: "This bid is proposed by ", attributes: [
            .font: AppFonts.NunitoSansSemiBold.withSize(13.0),
            .foregroundColor: AppColors.fontSecondaryColor
        ])
        str.append(NSAttributedString(string: viewModel.garageName, attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontPrimaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(13.0)]))
        
        str.append(NSAttributedString(string: " as per your tyre\nservice request.", attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontSecondaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansSemiBold.withSize(13.0)]))
        
        thisBidProposedLbl.attributedText = str
        
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
        mainTableView.tableHeaderView?.isHidden = true
        hitApi()
    }
    
    private func setupCollView() {
        countryCollView.registerCell(with: FacilityCollectionViewCell.self)
        countryCollView.delegate = self
        countryCollView.dataSource = self
    }
    
    private func hitApi(){
        self.viewModel.getOfferDetailData(params: [ApiKey.bidId:self.viewModel.bidId ])
    }
    
    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        [totalPriceLbl,unitLbl,unitPriceLbl,brandsLbl].forEach({$0?.textColor = AppColors.fontTertiaryColor})
    }
    
    @objc func newBidSocketSuccess(){
        self.hitApi()
    }
}

// MARK: - Extension For TableView
//===========================
extension OffersDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.bidData.endIndex
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: OffersDetailTableCell.self, indexPath: indexPath)
        cell.populateData(isBrandSelected: self.viewModel.bidData[indexPath.row].isAccepted ?? false,model:  self.viewModel.bidData[indexPath.row])
        cell.dashBackgroundView.isHidden = !(self.viewModel.bidData.endIndex - 1 == indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (viewModel.userBidDetail.status != "accepted") {
            acceptBtn.isEnabled = true
            if self.viewModel.bidData.endIndex > 0 {
                let index =  self.viewModel.bidData.firstIndex { (model) -> Bool in
                    return model.isAccepted == true
                }
                guard let selectedIndex = index else {
                    self.viewModel.bidData[indexPath.row].isAccepted = true
                    self.viewModel.userBidDetail.bidData[indexPath.row].isAccepted = true
                    self.mainTableView.reloadData()
                    return }
                self.viewModel.userBidDetail.bidData[selectedIndex].isAccepted = false
                self.viewModel.userBidDetail.bidData[indexPath.row].isAccepted = true
                self.viewModel.bidData[selectedIndex].isAccepted = false
                self.viewModel.bidData[indexPath.row].isAccepted = true
                self.mainTableView.reloadData()
            }
        }
    }
}

// MARK: - Extension For getOfferDetailData
//========================================
extension OffersDetailVC : OffersDetailVMDelegate {
    func rejectUserBidDataSuccess(message: String) {
        NotificationCenter.default.post(name: Notification.Name.UserServiceAcceptRejectSuccess, object: nil)
        self.dismiss(animated: true,completion: {
          //  self.proposalBtnTapped?()
        })
    }
    
    func rejectUserBidDataFailed(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func acceptUserBidDataFailed(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func getOfferDetailSuccess(message: String) {
        mainTableView.tableHeaderView?.isHidden = false
        countryCollView.isHidden = viewModel.userBidDetail.countries?.isEmpty ?? true
        mainTableView.tableHeaderView?.height = viewModel.userBidDetail.countries?.isEmpty ?? true ? 180.0 : 226.0
        self.mainTableView.reloadData()
        self.acceptBtn.isEnabled = (viewModel.userBidDetail.status == "accepted")
        self.acceptBtn.isUserInteractionEnabled = !(viewModel.userBidDetail.status == "accepted")
        self.acceptBtn.setTitle( self.acceptBtn.isUserInteractionEnabled ? "Accept" : "Accepted", for: .normal)
        collectionView(countryCollView, didSelectItemAt: IndexPath(item: 0, section: 0))
    }
    
    func getOfferDetailFailed(error: String) {
        mainTableView.tableHeaderView?.isHidden = true
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func acceptUserBidDataSuccess(message: String) {
        NotificationCenter.default.post(name: Notification.Name.UserServiceAcceptRejectSuccess, object: nil)
        self.dismiss(animated: true,completion: {
            self.proposalBtnTapped?()
        })
    }
    
    func countryDataFilter(){
        self.mainTableView.reloadData()

    }
}

// MARK: - Extension For DZNEmptyDataSetSource
//========================================
extension OffersDetailVC: DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return  #imageLiteral(resourceName: "layerX00201")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var emptyData = ""
        emptyData =  self.viewModel.userBidDetail.bidData.endIndex  == 0 ? "" : ""
        return NSAttributedString(string:emptyData, attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontTertiaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(18)])
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
//        if let tableView = scrollView as? UITableView, tableView.numberOfSections == 0 {
//            return true
//        }
        return false
    }
}


// MARK: - Extension For UICollectionViewDelegate
//========================================
extension OffersDetailVC : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.userBidDetail.countries?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: FacilityCollectionViewCell.self, indexPath: indexPath)
        cell.cancelBtn.isHidden = true
        cell.cancelBtnHeightConstraint.constant = 0.0
        cell.skillLbl.contentMode = .center
        cell.skillLbl.text = viewModel.userBidDetail.countries?[indexPath.item]
        cell.containerView.backgroundColor = self.indexPath == indexPath ? AppColors.appRedColor : .white
        cell.skillLbl.textColor = self.indexPath == indexPath ? .white : AppColors.fontTertiaryColor
        cell.layoutSubviews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let text = viewModel.userBidDetail.countries?[indexPath.item] else {return CGSize.zero}
        let textSize = text.sizeCount(withFont: AppFonts.NunitoSansSemiBold.withSize(14.0), boundingSize: CGSize(width: 10000.0, height: 34.0))
        return CGSize(width: (textSize.width) + 20, height: 36.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexPath = indexPath
        if let countryArrays = viewModel.userBidDetail.countries {
            if countryArrays.endIndex > 0 {
             viewModel.getBidData(country: countryArrays[indexPath.item])
            }
        }
        collectionView.reloadData()
    }
}
