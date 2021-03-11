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
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var viewModel = BrandsListingVM()
    var listingType : ListingType = .brands
    weak var delegate : BrandsListnig?
    var isSearchOn: Bool = false
    let buttonView = UIButton()
    var isApiHitInProcess : Bool = false
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
            let emptyModelIndex = self.viewModel.selectedBrandsArr.firstIndex { (model) -> Bool in
                return model.id.isEmpty
            }
            if let selectedIndex = emptyModelIndex {
                self.viewModel.selectedBrandsArr.remove(at: selectedIndex)
            }
            TyreRequestModel.shared.selectedTyreBrandsListings = self.viewModel.selectedBrandsArr
            list = self.viewModel.selectedBrandsArr
        }else {
            let emptyModelIndex = self.viewModel.selectedCountryArr.firstIndex { (model) -> Bool in
                return model.id.isEmpty
            }
            if let selectedIndex = emptyModelIndex {
                self.viewModel.selectedCountryArr.remove(at: selectedIndex)
            }
            TyreRequestModel.shared.selectedTyreCountryListings = self.viewModel.selectedCountryArr
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
        isApiHitInProcess = false
        if   (listingType == .brands) {
            self.hitBrandListingApi(loader:true)
        } else {
            self.hitCountryListingApi(loader:true)
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
        buttonView.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        searchTxtField.setButtonToRightView(btn: buttonView, selectedImage: #imageLiteral(resourceName: "cancel"), normalImage: #imageLiteral(resourceName: "cancel"), size: CGSize(width: 20, height: 20))
        searchTxtField.placeholder = (listingType == .brands) ? LocalizedString.search_Brand_by_name.localized : LocalizedString.search_Country_by_name.localized
    }
    
    private func hitBrandListingApi(loader:Bool){
        let type = categoryType == .tyres ? ApiKey.tyres : (categoryType == .battery ? ApiKey.battery : ApiKey.oil)
        self.viewModel.getBrandListingData(params: [ApiKey.page: "1",ApiKey.limit : "100",ApiKey.type: type],loader: loader)
    }
    
    private func hitCountryListingApi(loader:Bool){
        self.viewModel.getCountryListingData(params: [ApiKey.page: "1",ApiKey.limit : "100",ApiKey.type: ApiKey.tyres],loader: loader)
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
        cancelBtn.setTitle(LocalizedString.cancel.localized, for: .normal)
        doneBtn.setTitle(LocalizedString.done.localized, for: .normal)
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
            return self.viewModel.searchBrandListing.endIndex
        }else {
            return self.viewModel.searchCountryListing.endIndex
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueHeaderFooter(with: FacilityTableHeaderView.self)
        view.bottomView.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
        view.categoryName.text = listingType == .brands ? self.viewModel.searchBrandListing[section].name : self.viewModel.searchCountryListing[section].name
        if   (listingType == .brands) {
            if self.viewModel.searchBrandListing[section].name == LocalizedString.allBrands.localized {
                view.arrowImg.isHidden = true }else {
                view.arrowImg.isHidden = false
                view.arrowImg.setImage_kf(imageString: self.viewModel.searchBrandListing[section].iconImage, placeHolderImage: #imageLiteral(resourceName: "terms"), loader: false)
            }
        } else {
            view.arrowImg.isHidden = true
        }
        if self.listingType == .brands {
            let isPowerSelected = self.viewModel.selectedBrandsArr.contains(where: {$0.id == (self.isSearchOn ? self.viewModel.searchBrandListing[section].id : self.viewModel.brandsListings[section].id)})
            if self.viewModel.brandsListings.endIndex  > 0  {
                if section == 0{
                    if self.viewModel.selectedBrandsArr.endIndex ==  self.viewModel.brandsListings.endIndex - 1 {
                        view.configureCell(isPowerSelected: true, model: (self.isSearchOn ? self.viewModel.searchBrandListing[section] : self.viewModel.brandsListings[section]))
                    }else {
                        view.configureCell(isPowerSelected: isPowerSelected, model: (self.isSearchOn ? self.viewModel.searchBrandListing[section] : self.viewModel.brandsListings[section]))
                    }
                } else {
                    view.configureCell(isPowerSelected: isPowerSelected, model: (self.isSearchOn ? self.viewModel.searchBrandListing[section] : self.viewModel.brandsListings[section]))
                }
            }
        }else{
            let isPowerSelected = self.viewModel.selectedCountryArr.contains(where: {$0.id == (self.isSearchOn ? self.viewModel.searchCountryListing[section].id : self.viewModel.countryListings[section].id)})
            if self.viewModel.countryListings.endIndex  > 0 {
                if section == 0{
                    if self.viewModel.selectedCountryArr.endIndex ==  self.viewModel.countryListings.endIndex - 1 {
                        view.configureCell(isPowerSelected: true, model: (self.isSearchOn ? self.viewModel.searchCountryListing[section] : self.viewModel.countryListings[section]))
                    }else {
                        view.configureCell(isPowerSelected: isPowerSelected, model: (self.isSearchOn ? self.viewModel.searchCountryListing[section] : self.viewModel.countryListings[section]))
                    }
                } else {
                    view.configureCell(isPowerSelected: isPowerSelected, model: (self.isSearchOn ? self.viewModel.searchCountryListing[section] : self.viewModel.countryListings[section]))
                }
            }
        }
        view.cellBtnTapped = { [weak self] in
            guard let `self` = self else {return}
            if self.listingType == .brands {
                let searchId = self.viewModel.searchBrandListing[section].id
                let brandId = self.viewModel.brandsListings[section].id
                if (self.isSearchOn ? searchId.isEmpty : brandId.isEmpty) {
                    if self.viewModel.selectedBrandsArr.endIndex == self.viewModel.brandsListings.endIndex - 1{
                        self.viewModel.selectedBrandsArr = []
                        self.mainTableView.reloadData()
                    }  else {
                        self.viewModel.selectedBrandsArr = self.viewModel.brandsListings
                        let emptyModelIndex = self.viewModel.selectedBrandsArr.firstIndex { (model) -> Bool in
                            return model.id.isEmpty
                        }
                        if let selectedIndex = emptyModelIndex {
                            self.viewModel.selectedBrandsArr.remove(at: selectedIndex)
                        }
                        self.mainTableView.reloadData()
                    }
                    return
                }
                if self.viewModel.selectedBrandsArr.contains(where: {$0.id  == (self.isSearchOn ? searchId : brandId)}){
                    self.viewModel.removeSelectedBrands(model: self.isSearchOn ? self.viewModel.searchBrandListing[section] : self.viewModel.brandsListings[section])
                } else {
                    self.viewModel.setSelectedBrands(model: self.isSearchOn ? self.viewModel.searchBrandListing[section] : self.viewModel.brandsListings[section])
                }
            }else {
                let searchId = self.viewModel.searchCountryListing[section].id
                let countryId = self.viewModel.countryListings[section].id
                if (self.isSearchOn ? searchId.isEmpty : countryId.isEmpty) {
                    if self.viewModel.selectedCountryArr.endIndex == self.viewModel.countryListings.endIndex - 1 {
                        self.viewModel.selectedCountryArr = []
                        self.mainTableView.reloadData()
                    }  else {
                        self.viewModel.selectedCountryArr = self.viewModel.countryListings
                        let emptyModelIndex = self.viewModel.selectedCountryArr.firstIndex { (model) -> Bool in
                            return model.id.isEmpty
                        }
                        if let selectedIndex = emptyModelIndex {
                            self.viewModel.selectedCountryArr.remove(at: selectedIndex)
                        }
                        self.mainTableView.reloadData()
                    }
                    return
                }
                if self.viewModel.selectedCountryArr.contains(where: {$0.id  == (self.isSearchOn ? searchId : countryId)}) {
                    self.viewModel.removeSelectedCountry(model: self.isSearchOn ? self.viewModel.searchCountryListing[section] : self.viewModel.countryListings[section])
                } else {
                    self.viewModel.setSelectedCountry(model: self.isSearchOn ? self.viewModel.searchCountryListing[section] : self.viewModel.countryListings[section])
                }
            }
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
        isApiHitInProcess = true
        self.mainTableView.reloadData()
    }
    
    func countryListingFailed(error: String) {
        isApiHitInProcess = true
        self.mainTableView.reloadData()
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func brandListingSuccess(message: String) {
        isApiHitInProcess = true
        self.mainTableView.reloadData()
    }
    
    func brandListingFailed(error: String) {
        isApiHitInProcess = true
        self.mainTableView.reloadData()
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
        var emptyData = ""
        if (listingType == .brands) {
            emptyData =  (self.viewModel.searchBrandListing.endIndex == 0 && !isApiHitInProcess) ? "Loading..." : (self.viewModel.searchBrandListing.endIndex == 0 ? LocalizedString.noDataFound.localized : "")
        }else {
            emptyData =  (self.viewModel.searchCountryListing.endIndex  == 0 && !isApiHitInProcess) ? "Loading..." : (self.viewModel.searchCountryListing.endIndex == 0 ? LocalizedString.noDataFound.localized : "")
        }
        return NSAttributedString(string:emptyData , attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontTertiaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(18)])
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
        if let tableView = scrollView as? UITableView, tableView.numberOfSections == 0 {
            isApiHitInProcess = true
            return true
        }
        return false
    }
}

