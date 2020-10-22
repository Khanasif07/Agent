//
//  GarageServiceRequestVC.swift
//  ArabianTyres
//
//  Created by Admin on 06/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class GarageServiceRequestVC: BaseVC {
    
    enum Section {
        case userDetail
        case countryDetail
        case brandListing
    }
    
    enum BrandsType{
        case countryBrands
        case onlyBrands
    }
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var placeBidBtn: AppButton!
    @IBOutlet weak var requestBtn: AppButton!
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: - Variables
    //=====================
    var quantity : Int = 0
    var requestId : String = ""
    var selectedCountry: String  = ""
    var sectionType : [Section] = [.userDetail]
    var brandsType : BrandsType = .onlyBrands
    let viewModel = GarageServiceRequestVM()
    weak var delegate: UserServiceRequestVCDelegate?
    var isLocationUpdate: Bool = false
    var bidStatus : BidStatus = .bidFinalsed
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        placeBidBtn.round(radius: 4.0)
        requestBtn.round(radius: 4.0)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func placeBidAction(_ sender: AppButton) {
        
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
        if selectedCountryBrandsArray.isEmpty {
            CommonFunctions.showToastWithMessage("Please select one bid")
            return
        }
        if bidAmountValid {
            self.viewModel.postPlaceBidData(params: [ApiKey.requestId:requestId,ApiKey.bidData: selectedDict])
        }else {
            CommonFunctions.showToastWithMessage("Unit Price should not be 0 or empty")
        }
    }
    
    @IBAction func rejectRequestAction(_ sender: AppButton) {
        viewModel.rejectGarageRequest(params: [ApiKey.requestId : viewModel.garageRequestDetailArr?.id ?? ""] )
    }
    
    @IBAction func crossBtnAction(_ sender: UIButton) {
        pop()
        //self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Extension For Functions
//===========================
extension GarageServiceRequestVC {
    
    private func initialSetup() {
        viewModel.delegate = self
        tableViewSetUp()
        textSetUp()
        hitApi()
        placeBidBtn.isHidden = bidStatus == .bidFinalsed
        titleLbl.text =  self.viewModel.requestType == "Tyres" ? "Tyre Service Request" : self.viewModel.requestType == "Battery" ? "Battery Service Request" : "Oil Service Request"
    }
    
    private func tableViewSetUp(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerCell(with: GarageServiceTopCell.self)
        self.mainTableView.registerCell(with: GarageServiceCountryCell.self)
        self.mainTableView.registerCell(with: GarageServiceBrandsCell.self)
        self.mainTableView.tableFooterView = footerView
    }
    
    private func textSetUp(){
        requestBtn.isBorderSelected = true
        placeBidBtn.isEnabled = true
    }
    
    private func hitApi(){
        viewModel.getGarageRequestDetailData(params: [ApiKey.requestId: requestId])
    }
}

// MARK: - Extension For TableView
//===========================
extension GarageServiceRequestVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionType[section]{
        case .userDetail:
            return 1
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
            
        case .userDetail:
            let cell = tableView.dequeueCell(with: GarageServiceTopCell.self, indexPath: indexPath)
            cell.popluateData(viewModel.garageRequestDetailArr ?? GarageRequestModel())
            cell.locationUpdated = {[weak self] in
                guard let `self` = self else {return}
                if !(self.isLocationUpdate) {
                    self.mainTableView.reloadData()
                    self.isLocationUpdate = true
                }
            }
            return cell
            
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
            let indexx = self.viewModel.countryBrandsDict.firstIndex { (model) -> Bool in
                Array(model.keys)[0] == self.selectedCountry
            }
            guard let selectedIndexx  = indexx else { return UITableViewCell()}
            let brandDataArr = self.viewModel.countryBrandsDict[selectedIndexx][self.selectedCountry] ?? [PreferredBrand]()
            cell.bindData(brandDataArr[indexPath.row])
            cell.unitPriceChanged = { [weak self] (unitPrice,sender) in
                guard let `self` = self else { return }
                if  let SelectedIndexPath = tableView.indexPath(for: cell) {
                    if self.brandsType == .onlyBrands {
                        self.viewModel.countryBrandsDict[0][self.selectedCountry]?[SelectedIndexPath.row].amount = Double(unitPrice) ?? 0.0
                    }
                    if self.brandsType == .countryBrands {
                        let indexx = self.viewModel.countryBrandsDict.firstIndex { (model) -> Bool in
                            Array(model.keys)[0] == self.selectedCountry
                        }
                        guard let selectedIndexx  = indexx else { return}
                        self.viewModel.countryBrandsDict[selectedIndexx][self.selectedCountry]?[SelectedIndexPath.row].amount = Double(unitPrice) ?? 0.0
                    }
                }
            }
            cell.unitLbl.text = quantity.description
            cell.dashBackgroundView.isHidden = !(indexPath.row == brandDataArr.endIndex - 1)
            return cell
        }
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
        if sectionType[indexPath.section] == .brandListing {
            let index = self.viewModel.countryBrandsDict.firstIndex { (model) -> Bool in
                Array(model.keys)[0] == self.selectedCountry
            }
            guard let selectedIndex  = index else { return }
            if let listing =  self.viewModel.countryBrandsDict[selectedIndex][self.selectedCountry] {
                let indexx =  listing.firstIndex { (model) -> Bool in
                    model.id == listing[indexPath.row].id
                }
                guard let selectedIndexx  = indexx else { return }
                self.viewModel.countryBrandsDict[selectedIndex][self.selectedCountry]?[selectedIndexx].isSelected = !(listing[selectedIndexx].isSelected ?? false)
            }
            self.mainTableView.reloadData()
        }
    }

}

extension GarageServiceRequestVC :GarageServiceRequestVMDelegate {
    func placeBidSuccess(message: String) {
         pop()
    }
    
    func placeBidFailure(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func getGarageDetailSuccess(message: String) {
        updateDataSource()
        self.quantity = viewModel.garageRequestDetailArr?.quantity ?? 0
        self.mainTableView.reloadData()
        //
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
        self.mainTableView.reloadData()
    }
    
    func brandListingFailed(error:String) {
        ToastView.shared.showLongToast(self.view, msg: error)
        
    }
    
    func cancelGarageRequestSuccess(message: String){
        self.delegate?.cancelUserMyRequestDetailSuccess(requestId: self.requestId)
        pop()
//        dismiss(animated: true, completion: nil)
    }
    
    func cancelGarageRequestFailure(error:String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func updateDataSource() {
        var apiHit : Bool = true
        sectionType.append(.countryDetail)
        let serviceType = viewModel.garageRequestDetailArr?.requestType
        titleLbl.text = serviceType == .tyres ? "Tyre Service Request" : serviceType == .battery ? "Battery Service Request" :  "Oil Service Request"
        if !(viewModel.garageRequestDetailArr?.preferredCountries.isEmpty ?? false) {
            apiHit = false
            brandsType = .countryBrands
        }
        
        if !(viewModel.garageRequestDetailArr?.preferredBrands.isEmpty ?? false) {
            apiHit = false
            brandsType = .onlyBrands
            self.viewModel.countryBrandsDict.append([self.selectedCountry : viewModel.garageRequestDetailArr?.preferredBrands ?? [PreferredBrand]()])
            sectionType.append(.brandListing)
        }
        if apiHit{
            hitBrandListingApi()
        }
        self.mainTableView.reloadData()
    }
    
    func hitBrandListingApi(country: String = "") {
        var params = [ApiKey.page: "1",ApiKey.limit : "100",ApiKey.type: viewModel.garageRequestDetailArr?.requestType.rawValue ?? ""]
        if !country.isEmpty {
            params[ApiKey.country] = country
        }
        viewModel.getBrandListingData(params : params,loader: false)
    }
}
