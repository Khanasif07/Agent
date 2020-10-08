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
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var placeBidBtn: AppButton!
    @IBOutlet weak var requestBtn: AppButton!
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: - Variables
    //===========================
    var requestId : String = ""
    var sectionType : [Section] = [.userDetail]
    let viewModel = GarageServiceRequestVM()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        self.mainTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        placeBidBtn.round(radius: 4.0)
        requestBtn.round(radius: 4.0)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func placeBidAction(_ sender: AppButton) {
    }
    
    @IBAction func rejectRequestAction(_ sender: AppButton) {
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
        self.mainTableView.registerCell(with: GarageServiceBottomCell.self)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionType[indexPath.row] {
        case .userDetail:
            let cell = tableView.dequeueCell(with: GarageServiceTopCell.self, indexPath: indexPath)
            return cell
        case .countryDetail:
            let cell = tableView.dequeueCell(with: GarageServiceCountryCell.self, indexPath: indexPath)
            cell.countryNameArr = viewModel.garageRequestDetailArr?.preferredCountries ?? []
            cell.countryCollView.reloadData()
            return cell
        case .brandListing:
            let cell = tableView.dequeueCell(with: GarageServiceBottomCell.self, indexPath: indexPath)
            cell.brandDataArr = viewModel.garageRequestDetailArr?.preferredBrands ?? []
            cell.internalTableView.reloadData()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension GarageServiceRequestVC :GarageServiceRequestVMDelegate {
    func getGarageDetailSuccess(message: String) {
        updateDataSource()
        mainTableView.reloadData()
    }
    
    func getGarageDetailFailed(error: String) {
        
    }
    
    func brandListingSuccess(message: String) {
        
    }
    
    func brandListingFailed(error:String) {
        
    }
    
    func updateDataSource() {
        var apiHit : Bool = true
  
        if !(viewModel.garageRequestDetailArr?.preferredCountries.isEmpty ?? false) {
            apiHit = false
            sectionType.append(.countryDetail)
        }
        
        if !(viewModel.garageRequestDetailArr?.preferredBrands.isEmpty ?? false) {
            apiHit = false
            sectionType.append(.brandListing)
        }
        if apiHit{
            hitBrandListingApi()
           
        }
    }
    
    func hitBrandListingApi(country: String = "") {
        var params = [ApiKey.page: "1",ApiKey.limit : "100",ApiKey.type: viewModel.garageRequestDetailArr?.requestType ?? ""]
        if !country.isEmpty {
            params[ApiKey.countries] = country
        }
        viewModel.getBrandListingData(params : params,loader: false)
    }
}
