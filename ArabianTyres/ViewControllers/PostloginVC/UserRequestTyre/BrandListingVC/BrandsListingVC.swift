//
//  BrandsListingVC.swift
//  ArabianTyres
//
//  Created by Arvind on 17/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

protocol BrandsListnig: class {
    func listing( listingType: ListingType,BrandsListings: [TyreBrandModel],countryListings: [TyreCountryModel])
}


class BrandsListingVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var clearAllBtn: UIButton!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var viewModel = BrandsListingVM()
    var listingType : ListingType = .brands
    weak var delegate : BrandsListnig?
    var isSearchOn: Bool = false
    let buttonView = UIButton()
    var selectedIndexPath = [Int]()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func doneBtnAction(_ sender: UIButton) {
        var list :[Any] = []
        if listingType == .brands {
            list = self.viewModel.selectedBrandsArr
        }else {
            list = self.viewModel.selectedCountryArr
        }
        dismiss(animated: true) {
            self.delegate?.listing(listingType: self.listingType,BrandsListings: list as? [TyreBrandModel] ?? [] ,countryListings: list as? [TyreCountryModel] ?? [] )
        }
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        viewModel.searchText = sender.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        isSearchOn = !viewModel.searchText.isEmpty
        buttonView.isHidden = viewModel.searchText.isEmpty
        mainTableView.reloadData()
    }
    
    @IBAction func clearAllAction(_ sender: UIButton) {
        self.viewModel.selectedCountryArr = []
        self.viewModel.selectedBrandsArr = []
        mainTableView.reloadData()
    }
}

// MARK: - Extension For Functions
//===========================
extension BrandsListingVC {
    
    private func initialSetup() {
        self.viewModel.delegate = self
        setupTextAndFont()
        textFieldSetUp()
        tableViewSetUp()
        hitApi()
    }
    
    private func hitApi(){
        if   (listingType == .brands) {
            self.hitBrandListingApi()
        } else {
            self.hitCountryListingApi()
        }
    }
    
    private func tableViewSetUp(){
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.emptyDataSetSource = self
        mainTableView.emptyDataSetDelegate = self
        mainTableView.registerHeaderFooter(with: FacilityTableHeaderView.self)
        self.mainTableView.registerCell(with: LoaderCell.self)
    }
    
    private func textFieldSetUp(){
        buttonView.isHidden = true
        buttonView.addTarget(self, action: #selector(clear(_:)), for: .touchUpInside)
        searchTxtField.setButtonToRightView(btn: buttonView, selectedImage: #imageLiteral(resourceName: "cancel"), normalImage: #imageLiteral(resourceName: "cancel"), size: CGSize(width: 20, height: 20))
    }
    
    private func hitBrandListingApi(){
        self.viewModel.getBrandListingData(params: [ApiKey.page: "1",ApiKey.limit : "100",ApiKey.type: "Tyres"],loader: false)
    }
    
    private func hitCountryListingApi(){
        self.viewModel.getCountryListingData(params: [ApiKey.page: "1",ApiKey.limit : "100",ApiKey.type: "Tyres"],loader: false)
    }
    
    private func selectedDataSource(){
        if (listingType == .brands) {
            if !self.viewModel.selectedBrandsArr.isEmpty {
                self.viewModel.selectedBrandsArr = self.viewModel.selectedBrandsArr.count == self.viewModel.searchBrandListing.count - 1 ? [self.viewModel.searchBrandListing[0]] : self.viewModel.selectedBrandsArr
            }
            
            for (index, item) in self.viewModel.searchBrandListing.enumerated() {
                if self.viewModel.selectedBrandsArr.contains(item) {
                    self.selectedIndexPath.append(index)
                }
            }
        }
            
        else {
            if !self.viewModel.selectedCountryArr.isEmpty {
                self.viewModel.selectedCountryArr = self.viewModel.selectedCountryArr.count == self.viewModel.searchCountryListing.endIndex - 1 ? [self.viewModel.searchCountryListing[0]] : self.viewModel.selectedCountryArr
            }
            
            for (index, item) in self.viewModel.searchCountryListing.enumerated() {
                if self.viewModel.selectedCountryArr.contains(item) {
                    self.selectedIndexPath.append(index)
                }
            }
        }
    }
    
    private func getSelectedBrandList() -> [TyreBrandModel] {
        
        var arr : [TyreBrandModel] = []
        if selectedIndexPath.contains(0){
            selectedIndexPath = Array(1...self.viewModel.searchBrandListing.count - 1)
        }
        selectedIndexPath.forEach { (index) in
            arr.append(self.viewModel.searchBrandListing[index]) //: //self.viewModel.countryListings[index])
        }
        return arr
    }
    
    private func getSelectedCountryList() -> [TyreCountryModel] {
        
        var arr : [TyreCountryModel] = []
        if selectedIndexPath.contains(0){
            selectedIndexPath = Array(1...self.viewModel.searchCountryListing.count - 1)
        }
        selectedIndexPath.forEach { (index) in
            arr.append(self.viewModel.searchCountryListing[index])
        }
        return arr
    }
    
    private func setupTextAndFont(){
        
        if listingType == .brands {
            titleLbl.text = LocalizedString.selectBrand.localized
        } else {
            titleLbl.text = LocalizedString.selectCountry.localized
        }
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        cancelBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(17.0)
        doneBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(17.0)
        clearAllBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(12.0)
        cancelBtn.setTitle(LocalizedString.cancel.localized, for: .normal)
        doneBtn.setTitle(LocalizedString.done.localized, for: .normal)
        clearAllBtn.setTitle(LocalizedString.clearAll.localized, for: .normal)
        
    }
    
    @objc private func clear(_ sender: UIButton) {
        searchTxtField.text = ""
        viewModel.searchText = searchTxtField.text ?? ""
        isSearchOn = !viewModel.searchText.isEmpty
        buttonView.isHidden = viewModel.searchText.isEmpty
        mainTableView.reloadData()
    }
}


// MARK: - Extension For TableView
//===========================
extension BrandsListingVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (listingType == .brands) {
            return self.viewModel.searchBrandListing.endIndex +  (self.viewModel.showPaginationLoader ?  0 : 0)
        }else {
            return  self.viewModel.searchCountryListing.endIndex +  (self.viewModel.showPaginationLoader ?  0 : 0)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueHeaderFooter(with: FacilityTableHeaderView.self)
        view.bottomView.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
        view.categoryName.text = listingType == .brands ? self.viewModel.searchBrandListing[section].name : self.viewModel.searchCountryListing[section].name
        view.arrowImg.isHidden = section == 0 ? true : false
        view.arrowImg.setImage_kf(imageString: listingType == .brands ? self.viewModel.searchBrandListing[section].iconImage : self.viewModel.searchCountryListing[section].flag, placeHolderImage: #imageLiteral(resourceName: "icUnCheck"), loader: true)
        //        view.checkBtn.isSelected = selectedIndexPath.contains(section) || selectedIndexPath.contains(0)
        //
        if   self.listingType == .brands {
            let isPowerSelected = self.viewModel.selectedBrandsArr.contains(where: {$0.id == (self.isSearchOn ? self.viewModel.searchBrandListing[section].id : self.viewModel.brandsListings[section].id)})
            if self.viewModel.brandsListings.endIndex  > 0  {
                view.configureCell(isPowerSelected: isPowerSelected, model: (self.isSearchOn ? self.viewModel.searchBrandListing[section] : self.viewModel.brandsListings[section]))
            }
        }else{
            let isPowerSelected = self.viewModel.selectedCountryArr.contains(where: {$0.id == (self.isSearchOn ? self.viewModel.searchCountryListing[section].id : self.viewModel.countryListings[section].id)})
            if self.viewModel.countryListings.endIndex  > 0 {
                view.configureCell(isPowerSelected: isPowerSelected, model: (self.isSearchOn ? self.viewModel.searchCountryListing[section] : self.viewModel.countryListings[section]))
            }
        }
        
        //
        
        view.cellBtnTapped = { [weak self] in
            guard let `self` = self else {return}
            //
            //            if section == 0 {
            //
            //                if self.selectedIndexPath.count == 0 {
            //                    self.selectedIndexPath.append(section)
            //                }else {
            //                    if (self.selectedIndexPath.count == 1 &&  self.selectedIndexPath.contains(0)){
            //                        self.selectedIndexPath.removeAll()
            //
            //                    }else {
            //                        self.selectedIndexPath.removeAll()
            //                        self.selectedIndexPath.append(section)
            //                    }
            //                }
            //            }else{
            //                if self.selectedIndexPath.count == 1 &&  self.selectedIndexPath.contains(0) {
            //                    self.selectedIndexPath = Array(1...(self.listingType == .brands ? (self.viewModel.searchBrandListing.count - 1) : (self.viewModel.searchCountryListing.count - 1)))
            //                    self.selectedIndexPath.removeAll{($0 == section)}
            //                }else {
            //
            //                    self.selectedIndexPath.contains(section) ? self.selectedIndexPath.removeAll{($0 == section)} : self.selectedIndexPath.append(section)
            //                    if self.listingType == .brands {
            //                      self.selectedIndexPath = self.selectedIndexPath.count == self.viewModel.searchBrandListing.count - 1 ? [0] : self.selectedIndexPath
            //                    }else {
            //                        self.selectedIndexPath = self.selectedIndexPath.count == self.viewModel.searchCountryListing.count - 1 ? [0] : self.selectedIndexPath
            //                    }
            //                }
            //            }
            //
            if self.listingType == .brands {
                let searchId = self.viewModel.searchBrandListing[section].id
                let brandId = self.viewModel.brandsListings[section].id
                if self.viewModel.selectedBrandsArr.contains(where: {$0.id  == (self.isSearchOn ? searchId : brandId)}){
                    self.viewModel.removeSelectedBrands(model: self.isSearchOn ? self.viewModel.searchBrandListing[section] : self.viewModel.brandsListings[section])
                } else {
                    self.viewModel.setSelectedBrands(model: self.isSearchOn ? self.viewModel.searchBrandListing[section] : self.viewModel.brandsListings[section])
                }
            }else {
                let searchId = self.viewModel.searchCountryListing[section].id
                let countryId = self.viewModel.countryListings[section].id
                if self.viewModel.selectedCountryArr.contains(where: {$0.id  == (self.isSearchOn ? searchId : countryId)}) {
                    self.viewModel.removeSelectedCountry(model: self.isSearchOn ? self.viewModel.searchCountryListing[section] : self.viewModel.countryListings[section])
                } else {
                    self.viewModel.setSelectedCountry(model: self.isSearchOn ? self.viewModel.searchCountryListing[section] : self.viewModel.countryListings[section])
                }
            }
            //
            self.mainTableView.reloadData()
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("displaycell = =",indexPath.row)
    }
}


// MARK: - BrandsListingVMDelegate
//===========================
extension BrandsListingVC: BrandsListingVMDelegate{
    func countryListingSuccess(message: String) {
        selectedDataSource()
        self.mainTableView.reloadData()
    }
    
    func countryListingFailed(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func brandListingSuccess(message: String) {
        selectedDataSource()
        self.mainTableView.reloadData()
    }
    
    func brandListingFailed(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
}

//MARK: DZNEmptyDataSetSource and DZNEmptyDataSetDelegate
//================================
extension BrandsListingVC : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return  nil
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No Data Found", attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontTertiaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(18)])
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
    
}
