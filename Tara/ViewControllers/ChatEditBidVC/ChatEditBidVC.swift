//
//  ChatEditBidVC.swift
//  Tara
//
//  Created by Admin on 09/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

protocol ChatEditBidVCDelegate : class{
    func bidEditSuccess(price: Int)
}

class ChatEditBidVC: BaseVC {
    
    enum Section {
        case countryDetail
        case brandListing
    }
    
    enum BrandsType{
        case countryBrands
        case onlyBrands
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    
    
    // MARK: - IBOutlets
    //===========================
    
    // MARK: - Variables
    //===========================
    var quantity : Int = 0
    var amount : Int = 0
    var bidStatus : BidStatus = .bidFinalsed
    var selectedCountry: String  = ""
    var acceptedProposalId : String  = ""
    var sectionType : [Section] = [.brandListing]
    var brandsType : BrandsType = .onlyBrands
    let viewModel = GarageServiceRequestVM()
    weak var delegate : ChatEditBidVCDelegate?
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func acceptBtnAction(_ sender: UIButton) {
        let selectedCountryBrandsArray =  self.viewModel.countryBrandsDict.map { (dict) -> [PreferredBrand] in
            return   Array(dict.values)[0]
        }.map { (modelArray) -> [PreferredBrand] in
            return modelArray.filter { (model) -> Bool in
                return model.isSelected == true
            }
        }.flatMap { $0 }
        printDebug(selectedCountryBrandsArray)
        var bidAmountValid : Bool = true
        var selectedDict  = JSONDictionaryArray()
        selectedCountryBrandsArray.forEach { (model) in
            var dict  = JSONDictionary()
            dict[ApiKey.brandName] = model.name
            dict[ApiKey.brandId] = model.id
            self.acceptedProposalId = model.bidId ?? ""
            self.amount = Int(model.amount ?? 0)
            if brandsType == .countryBrands {
                dict[ApiKey.countryId] = model.countryId
                dict[ApiKey.countryName] = model.countryName
            }
            guard let amt = model.amount, amt != 0  else {
                bidAmountValid = false
                return
            }
            dict[ApiKey.amount] = model.amount ?? 0
            dict[ApiKey.quantity] = quantity
            selectedDict.append(dict)
        }
        if bidAmountValid {
            //            self.viewModel.editPlacedBidData(params: [ApiKey.requestId: viewModel.requestId,ApiKey.bidData: selectedDict,ApiKey.acceptedProposalId: self.acceptedProposalId ])
            
            self.viewModel.editPlacedBidData(params: [ApiKey.requestId: viewModel.requestId,ApiKey.bidData: selectedDict,ApiKey.isacceptedProposalEdited: true ])
            //            self.viewModel.acceptEditedBid(params: [ApiKey.bidId: selectedDict.first?[ApiKey.bidId] ?? ""])
        }else {
            CommonFunctions.showToastWithMessage("Unit Price should not be 0 or empty")
        }
    }

    
    @IBAction func dismissBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension ChatEditBidVC {
    
    private func initialSetup() {
        viewModel.delegate = self
        self.tableViewSetUp()
        hitApi()
    }
    
    private func tableViewSetUp(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.emptyDataSetSource = self
        self.mainTableView.emptyDataSetDelegate = self
        self.mainTableView.registerCell(with: GarageServiceCountryCell.self)
        self.mainTableView.registerCell(with: GarageServiceBrandsCell.self)
        self.mainTableView.tableHeaderView = headerView
        self.mainTableView.tableHeaderView?.height = 102.5
    }
    
    private func hitApi(){
        viewModel.getGarageRequestDetailData(params: [ApiKey.requestId: self.viewModel.requestId])
    }
    
    private func getPlacedBidData(){
        if let  bidPlacedByGarage = self.viewModel.garageRequestDetailArr?.bidPlacedByGarage{
            //used for bid finalised case
            if self.viewModel.countryBrandsDict.endIndex > 0 {
                if  brandsType == .onlyBrands && bidStatus == .bidFinalsed   {
                    if let brandsListing = self.viewModel.countryBrandsDict[0][self.selectedCountry] {
                        for (off,_) in brandsListing.enumerated(){
                            self.viewModel.countryBrandsDict[0][self.selectedCountry]?[off].isSelected = false
                            self.viewModel.countryBrandsDict[0][self.selectedCountry]?[off].amount = 0.0
                        }
                    }
                }
                if   brandsType == .countryBrands && bidStatus == .bidFinalsed {
                    for (off,_) in self.viewModel.countryBrandsDict.enumerated(){
                        self.viewModel.garageRequestDetailArr?.preferredCountries?.forEach({ (preferredBrand) in
                            if let listingss = self.viewModel.countryBrandsDict[off][preferredBrand.name]{
                                for (offf,_) in listingss.enumerated(){
                                    self.viewModel.countryBrandsDict[off][self.selectedCountry]?[offf].isSelected = false
                                    self.viewModel.countryBrandsDict[off][self.selectedCountry]?[offf].amount = 0.0
                                }
                            }
                        })
                    }
                }
                
            }
            //
            bidPlacedByGarage.forEach { (placedBid) in
                if bidStatus == .bidFinalsed {
                    if placedBid.isAccepted == false{
                        return
                    }
                }
                if brandsType == .onlyBrands  {
                    if self.viewModel.countryBrandsDict.endIndex > 0 {
                        let indexx = self.viewModel.countryBrandsDict[0][self.selectedCountry]?.firstIndex(where: { (preferredBrand) -> Bool in
                            preferredBrand.id == placedBid.brandID
                        })
                        guard let selectedIndexx  = indexx else { return }
                        self.viewModel.countryBrandsDict[0][self.selectedCountry]?[selectedIndexx].isSelected = true
                        self.viewModel.countryBrandsDict[0][self.selectedCountry]?[selectedIndexx].bidId = placedBid.id
                        self.viewModel.countryBrandsDict[0][self.selectedCountry]?[selectedIndexx].amount = placedBid.amount
                    }
                } else {
                    for (off,_) in self.viewModel.countryBrandsDict.enumerated(){
                        self.viewModel.garageRequestDetailArr?.preferredCountries?.forEach({ (preferredBrand) in
                            if let listingss = self.viewModel.countryBrandsDict[off][preferredBrand.name]{
                                for (offf,model) in listingss.enumerated(){
                                    if model.countryId == placedBid.countryId && placedBid.brandID == model.id{
                                        if !(self.viewModel.countryBrandsDict[off][self.selectedCountry]?[offf].isSelected ?? false) { self.viewModel.countryBrandsDict[off][self.selectedCountry]?[offf].isSelected = true
                                            self.viewModel.countryBrandsDict[off][self.selectedCountry]?[offf].bidId = placedBid.id
                                            self.viewModel.countryBrandsDict[off][self.selectedCountry]?[offf].amount = placedBid.amount
                                            return
                                        }
                                    }
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
}

// MARK: - Extension For TableView
//===========================
extension ChatEditBidVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionType.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionType[section]{
        case .countryDetail:
            return 1
        case .brandListing:
            let indexx = self.viewModel.countryBrandsDict.firstIndex { (model) -> Bool in
                Array(model.keys)[0] == self.selectedCountry
            }
            guard let selectedIndexx  = indexx else { return 0}
            return self.viewModel.countryBrandsDict[selectedIndexx][self.selectedCountry]?.endIndex ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionType[indexPath.section] {
        case .countryDetail:
            let cell = tableView.dequeueCell(with: GarageServiceCountryCell.self, indexPath: indexPath)
            cell.brandsStackView.isHidden =   !(brandsType == .onlyBrands)
            cell.brandsStackView.isHidden = self.selectedCountry.isEmpty && (brandsType == .countryBrands)
            cell.countryCollView.isHidden =   brandsType == .onlyBrands
            cell.countryNameArr = viewModel.garageRequestDetailArr?.preferredCountries ?? []
            cell.countryBtnTapped = {[weak self] (countryName) in
                guard let `self` = self else {return}
                self.selectedCountry = countryName
                if self.viewModel.countryBrandsDict.contains(where: { (model) -> Bool in
                    Array(model.keys)[0] == self.selectedCountry
                }){
                    let indexx = self.viewModel.countryBrandsDict.firstIndex { (model) -> Bool in
                        Array(model.keys)[0] == self.selectedCountry
                    }
                    guard let selectedIndexx  = indexx else { return }
                    if let  countryBrandListing = self.viewModel.countryBrandsDict[selectedIndexx][self.selectedCountry] {
                        if !countryBrandListing.isEmpty {
                            self.sectionType.contains(.brandListing) ? () : self.sectionType.append(.brandListing)
                        }else {
                            self.sectionType.contains(.brandListing) ? self.sectionType.removeAll{($0 == .brandListing)} : ()
                        }
                    }
                    self.mainTableView.reloadData()
                } else {
                    self.hitBrandListingApi(country: countryName)
                }
            }
            cell.countryCollView.reloadData()
            return cell
            
        case .brandListing:
            let cell = tableView.dequeueCell(with: GarageServiceBrandsCell.self, indexPath: indexPath)
            cell.rightIcon.isHidden = true
            let indexx = self.viewModel.countryBrandsDict.firstIndex { (model) -> Bool in
                Array(model.keys)[0] == self.selectedCountry
            }
            guard let selectedIndexx  = indexx else { return UITableViewCell()}
            let brandDataArr = self.viewModel.countryBrandsDict[selectedIndexx][self.selectedCountry] ?? [PreferredBrand]()
            cell.bindData(brandDataArr[indexPath.row], bidStatus: self.bidStatus,placeBidBtnStatus:  "")
            cell.unitPrizeTextFiled.isUserInteractionEnabled = brandDataArr[indexPath.row].isSelected ?? false
            cell.unitPriceChanged = { [weak self] (unitPrice,sender) in
                guard let `self` = self else { return }
                if  let SelectedIndexPath = tableView.indexPath(for: cell) {
                    if self.brandsType == .onlyBrands {
                        self.viewModel.countryBrandsDict[0][self.selectedCountry]?[SelectedIndexPath.row].amount = Double(unitPrice) ?? 0
                    }
                    if self.brandsType == .countryBrands {
                        let indexx = self.viewModel.countryBrandsDict.firstIndex { (model) -> Bool in
                            Array(model.keys)[0] == self.selectedCountry
                        }
                        guard let selectedIndexx  = indexx else { return}
                        self.viewModel.countryBrandsDict[selectedIndexx][self.selectedCountry]?[SelectedIndexPath.row].amount = Double(unitPrice) ?? 0
                    }
                }
            }
            cell.unitLbl.text = quantity.description
            cell.dashBackgroundView.isHidden = !(indexPath.row == brandDataArr.endIndex - 1)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}

// MARK: - Extension For GarageServiceRequestVMDelegate
//===========================
extension ChatEditBidVC :GarageServiceRequestVMDelegate {
    func acceptEditedBidSuccess(message: String) {
         pop()
    }
    
    func acceptEditedBidFailure(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func editPlacedBidDataSuccess(message: String) {
        self.delegate?.bidEditSuccess(price: self.amount)
        NotificationCenter.default.post(name: Notification.Name.PlaceBidRejectBidSuccess, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func editPlacedBidDataFailure(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func cancelBidSuccess(message: String) {
        pop()
    }
    
    func cancelBidFailure(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func rejectGarageRequestSuccess(message: String) {
        pop()
    }
    
    func rejectGarageRequestFailure(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func placeBidSuccess(message: String) {
        NotificationCenter.default.post(name: Notification.Name.PlaceBidRejectBidSuccess, object: nil)
        pop()
    }
    
    func placeBidFailure(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func getGarageDetailSuccess(message: String) {
        self.bidStatus = viewModel.garageRequestDetailArr?.bidStatus ?? bidStatus
        self.quantity = viewModel.garageRequestDetailArr?.quantity ?? 0
        updateDataSource()
        self.getPlacedBidData()
        self.mainTableView.reloadData()
        // make first country selected
        if let countries = viewModel.garageRequestDetailArr?.preferredCountries{
            if countries.endIndex > 0 {
                self.selectedCountry = countries.first?.name ?? ""
                let section = sectionType.firstIndex { (sectionArray) -> Bool in
                    return sectionArray == .countryDetail
                }
                let cell = mainTableView.cellForRow(at: IndexPath(item: 0, section: section ?? 1)) as? GarageServiceCountryCell
                cell?.indexPath = IndexPath(item: 0, section: 0)
                cell?.countryCollView.reloadData()
                self.hitBrandListingApi(country: self.selectedCountry)
                return
            }
        }
        //
    }
    
    func getGarageDetailFailed(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func brandListingSuccess(message: String) {
        if !viewModel.brandsListings.isEmpty {
            sectionType.contains(.brandListing) ? () : sectionType.append(.brandListing)
        }else {
            sectionType.contains(.brandListing) ? sectionType.removeAll{($0 == .brandListing)} : ()
        }
        self.viewModel.countryBrandsDict.append([self.selectedCountry : viewModel.brandsListings])
        self.getPlacedBidData()
        self.mainTableView.reloadData()
    }
    
    func brandListingFailed(error:String) {
        ToastView.shared.showLongToast(self.view, msg: error)
        
    }
    
    func updateDataSource() {
        var apiHit : Bool = true
        let serviceType = viewModel.garageRequestDetailArr?.requestType
        titleLbl.text = serviceType == .tyres ? LocalizedString.tyreServiceRequest.localized : serviceType == .battery ? LocalizedString.batteryServiceRequest.localized :  LocalizedString.oilServiceRequest.localized
        if !(viewModel.garageRequestDetailArr?.preferredCountries?.isEmpty ?? true) {
            apiHit = false
            brandsType = .countryBrands
            if !sectionType.contains(.countryDetail){
                self.mainTableView.tableHeaderView = nil
                self.mainTableView.tableHeaderView?.height = 0.0
                sectionType.insert(.countryDetail, at: 0)
            }
        }
        
        if !(viewModel.garageRequestDetailArr?.preferredBrands?.isEmpty ?? false) {
            apiHit = false
            brandsType = .onlyBrands
            self.viewModel.countryBrandsDict.append([self.selectedCountry : viewModel.garageRequestDetailArr?.preferredBrands ?? [PreferredBrand]()])
            if !sectionType.contains(.brandListing){
                sectionType.append(.brandListing)
            }
        }
        if apiHit{
            hitBrandListingApi()
        }
    }
    
    func hitBrandListingApi(country: String = "") {
        var params = [ApiKey.page: "1",ApiKey.limit : "100",ApiKey.type: viewModel.garageRequestDetailArr?.requestType.rawValue ?? ""]
        if !country.isEmpty {
            params[ApiKey.country] = country
        }
        viewModel.getBrandListingData(params : params,loader: false)
    }
}


// MARK: - Extension For DZNEmptyDataSetSource
//========================================
extension ChatEditBidVC: DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return  nil
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var emptyData = ""
        let indexx = self.viewModel.countryBrandsDict.firstIndex { (model) -> Bool in
            Array(model.keys)[0] == self.selectedCountry
        }
        guard let selectedIndexx  = indexx else { return NSAttributedString(string:emptyData, attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontTertiaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(18)])}
        emptyData =  self.viewModel.countryBrandsDict[selectedIndexx][self.selectedCountry]?.endIndex ?? 0  == 0 ? "No data found" : ""
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
