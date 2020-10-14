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
    //===========================
    var quantity : Int = 0
    var requestId : String = ""
    var selectedCountry: String  = "India"
    var sectionType : [Section] = [.userDetail]
    var brandsType : BrandsType = .onlyBrands
    let viewModel = GarageServiceRequestVM()
    weak var delegate: UserServiceRequestVCDelegate?
    
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
        var selectedDict  = JSONDictionaryArray()
        selectedCountryBrandsArray.forEach { (model) in
            var dict  = JSONDictionary()
            dict[ApiKey.brandName] = model.name
            dict[ApiKey.brandId] = model.id
            dict[ApiKey.amount] = model.amount ?? 0
            dict[ApiKey.quantity] = quantity
            selectedDict.append(dict)
        }
        self.viewModel.postPlaceBidData(params: [ApiKey.requestId:requestId,ApiKey.bidData: selectedDict])
    }
    
    @IBAction func rejectRequestAction(_ sender: AppButton) {
        viewModel.rejectGarageRequest(params: [ApiKey.requestId : viewModel.garageRequestDetailArr?.id ?? ""] )
    }
    
    @IBAction func crossBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
        //        return sectionType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionType[indexPath.section] {
            
        case .userDetail:
            let cell = tableView.dequeueCell(with: GarageServiceTopCell.self, indexPath: indexPath)
            cell.popluateData(viewModel.garageRequestDetailArr ?? GarageRequestModel())
            return cell
            
        case .countryDetail:
            let cell = tableView.dequeueCell(with: GarageServiceCountryCell.self, indexPath: indexPath)
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
            //
            //            cell.countryBrandsSelected = {  [weak self] (SelectedIndexPath)  in
            //            guard let `self` = self else { return }
            //                let index = self.viewModel.countryBrandsDict.firstIndex { (model) -> Bool in
            //                    Array(model.keys)[0] == self.selectedCountry
            //                }
            //                guard let selectedIndex  = index else { return }
            //                if let listing =  self.viewModel.countryBrandsDict[selectedIndex][self.selectedCountry] {
            //                    let indexx =  listing.firstIndex { (model) -> Bool in
            //                        model.id == listing[SelectedIndexPath.row].id
            //                    }
            //                    guard let selectedIndexx  = indexx else { return }
            //                    self.viewModel.countryBrandsDict[selectedIndex][self.selectedCountry]?[selectedIndexx].isSelected = !(listing[selectedIndexx].isSelected ?? false)
            //                }
            //                self.mainTableView.reloadData()
            //            }
            //
            //
            //            cell.unitPriceUpdated = { [weak self] (unitPrice,SelectedIndexPath)  in
            //                guard let `self` = self else { return }
            //                if self.brandsType == .onlyBrands {
            //                self.viewModel.countryBrandsDict[0][self.selectedCountry]?[SelectedIndexPath.row].amount = Int(unitPrice) ?? 0
            //                }
            //                if self.brandsType == .countryBrands {
            //                    let indexx = self.viewModel.countryBrandsDict.firstIndex { (model) -> Bool in
            //                        Array(model.keys)[0] == self.selectedCountry
            //                    }
            //                    guard let selectedIndexx  = indexx else { return}
            //                    self.viewModel.countryBrandsDict[selectedIndexx][self.selectedCountry]?[SelectedIndexPath.row].amount = Int(unitPrice) ?? 0
            //                }
            //            }
            //
            //            let indexx = self.viewModel.countryBrandsDict.firstIndex { (model) -> Bool in
            //                Array(model.keys)[0] == self.selectedCountry
            //            }
            //            guard let selectedIndexx  = indexx else { return UITableViewCell()}
            //            cell.brandDataArr = self.viewModel.countryBrandsDict[selectedIndexx][self.selectedCountry] ?? [PreferredBrand]()
            //            cell.quantity = self.quantity
            //            return cell
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
                        self.viewModel.countryBrandsDict[0][self.selectedCountry]?[SelectedIndexPath.row].amount = Int(unitPrice) ?? 0
                    }
                    if self.brandsType == .countryBrands {
                        let indexx = self.viewModel.countryBrandsDict.firstIndex { (model) -> Bool in
                            Array(model.keys)[0] == self.selectedCountry
                        }
                        guard let selectedIndexx  = indexx else { return}
                        self.viewModel.countryBrandsDict[selectedIndexx][self.selectedCountry]?[SelectedIndexPath.row].amount = Int(unitPrice) ?? 0
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
        
    }
    
    func placeBidFailure(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func getGarageDetailSuccess(message: String) {
        updateDataSource()
        self.quantity = viewModel.garageRequestDetailArr?.quantity ?? 0
        
        mainTableView.reloadData()
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
        dismiss(animated: true, completion: nil)
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
    }
    
    func hitBrandListingApi(country: String = "") {
        var params = [ApiKey.page: "1",ApiKey.limit : "100",ApiKey.type: viewModel.garageRequestDetailArr?.requestType.rawValue ?? ""]
        if !country.isEmpty {
            params[ApiKey.country] = country
        }
        viewModel.getBrandListingData(params : params,loader: false)
    }
}
