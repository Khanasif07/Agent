//
//  BrandsListingVC.swift
//  ArabianTyres
//
//  Created by Arvind on 17/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

protocol BrandsListnig: class {
    func listing(_ data: [String], listingType: ListingType)
}


class BrandsListingVC: BaseVC {

    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var clearAllBtn: UIButton!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var brandLbl: UILabel!

    // MARK: - Variables
    //===========================
    var viewModel = BrandsListingVM()
    var selectedSkillArr : [String] = []
    var brandArr = ["All Brands", "MRF","Nokian Tyre","Apollo Tyres","CEAT Ltd","Goodyear","Peerless Tyre","Michelin ","Dunlop","Pirelli","Yokohama"]
    var selectedBrandsArr : [TyreBrandModel] = []
    var selectedCountryArr : [String] = []
    var selectedIndexPath : [Int] = []
    var listingType : ListingType = .brands
    var countryViewModel = CountryVM()
    var countryArr :[String] = []
    
    weak var delegate : BrandsListnig?

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
        let list = getSelectedList()
        dismiss(animated: true) {
            self.delegate?.listing(list, listingType: self.listingType)
       }
    }

    @IBAction func clearAllAction(_ sender: UIButton) {
        selectedIndexPath.removeAll()
        mainTableView.reloadData()
    }
}

// MARK: - Extension For Functions
//===========================
extension BrandsListingVC {

    private func initialSetup() {
        self.viewModel.delegate = self
        countryArr = countryViewModel.getCountriesArr()
        selectedDataSource()
        setupTextAndFont()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.registerHeaderFooter(with: FacilityTableHeaderView.self)
        self.mainTableView.registerCell(with: LoaderCell.self)
        self.hitBrandListingApi()
    }
    
    private func hitBrandListingApi(){
        self.viewModel.getBrandListingData(params: [ApiKey.page: "1",ApiKey.limit : "20",ApiKey.type: "Tyres"],loader: false)
    }

    
    private func selectedDataSource(){
        if (listingType == .brands) {
            if !selectedBrandsArr.isEmpty {
                self.selectedBrandsArr = self.selectedBrandsArr.count == self.viewModel.brandsListings.count - 1 ? [self.viewModel.brandsListings[0]] : self.selectedBrandsArr
            }
            
            for (index, item) in self.viewModel.brandsListings.enumerated() {
                if selectedBrandsArr.contains(item) {
                    self.selectedIndexPath.append(index)
                }
            }
        }
            
        else {
            
            if !selectedCountryArr.isEmpty {
                self.selectedCountryArr = self.selectedCountryArr.count == self.countryArr.count - 1 ? [self.countryArr[0]] : self.selectedCountryArr
            }
            
            for (index, item) in countryArr.enumerated() {
                if selectedCountryArr.contains(item) {
                    self.selectedIndexPath.append(index)
                }
            }
        }
    }

    private func getSelectedList() -> [String] {
      
        var arr : [String] = []
        
        if selectedIndexPath.contains(0){
            selectedIndexPath = Array(1...(listingType == .brands ? self.viewModel.brandsListings.count - 1: self.countryArr.count - 1))
        }
        selectedIndexPath.forEach { (index) in
            arr.append(listingType == .brands ? self.viewModel.brandsListings[index].name : self.countryArr[index])
        }
        return arr
    }
    
    private func setupTextAndFont(){
       
        if listingType == .brands {
            titleLbl.text = LocalizedString.selectBrand.localized
            brandLbl.text = LocalizedString.brandName.localized

        } else {
            titleLbl.text = LocalizedString.selectCountry.localized
            brandLbl.text = LocalizedString.countryName.localized
        }
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        brandLbl.font = AppFonts.NunitoSansBold.withSize(13.0)
        cancelBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(17.0)
        doneBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(17.0)
        clearAllBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(12.0)

        cancelBtn.setTitle(LocalizedString.cancel.localized, for: .normal)
        doneBtn.setTitle(LocalizedString.done.localized, for: .normal)
        clearAllBtn.setTitle(LocalizedString.clearAll.localized, for: .normal)

    }
}


// MARK: - Extension For TableView
//===========================
extension BrandsListingVC : UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        if (listingType == .brands) {
            return self.viewModel.brandsListings.endIndex
//             self.viewModel.subscriberListings.endIndex +  (self.viewModel.showPaginationLoader ?  1 : 0)
        }else {
            return countryArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueHeaderFooter(with: FacilityTableHeaderView.self)
        view.bottomView.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
        view.arrowImg.isHidden = listingType == .brands ? false : true
        view.categoryName.text = listingType == .brands ? self.viewModel.brandsListings[section].name : countryArr[section]
        view.arrowImg.setImage_kf(imageString: self.viewModel.brandsListings[section].iconImage, placeHolderImage: #imageLiteral(resourceName: "placeHolder"), loader: true)
        view.checkBtn.isSelected = selectedIndexPath.contains(section) || selectedIndexPath.contains(0)

        
        view.cellBtnTapped = { [weak self] (selected) in
            guard let `self` = self else {return}
            
            if section == 0 {

                if self.selectedIndexPath.count == 0 {
                    self.selectedIndexPath.append(section)
                }else {
                    if (self.selectedIndexPath.count == 1 &&  self.selectedIndexPath.contains(0)){
                        self.selectedIndexPath.removeAll()

                    }else {
                        self.selectedIndexPath.removeAll()
                        self.selectedIndexPath.append(section)
                    }
                }
            }else{
                if self.selectedIndexPath.count == 1 &&  self.selectedIndexPath.contains(0) {
                   self.selectedIndexPath = Array(1...self.brandArr.count - 1)
                   self.selectedIndexPath.removeAll{($0 == section)}
                }else {
                   
                   self.selectedIndexPath.contains(section) ? self.selectedIndexPath.removeAll{($0 == section)} : self.selectedIndexPath.append(section)
                   self.selectedIndexPath = self.selectedIndexPath.count == self.brandArr.count - 1 ? [0] : self.selectedIndexPath
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
        if cell as? LoaderCell != nil {
            let params: JSONDictionary = [ApiKey.limit: "20", ApiKey.page: viewModel.currentPage]
             self.viewModel.getBrandListingData(params: params,loader: false)
        }
    }
}


// MARK: - BrandsListingVMDelegate
//===========================
extension BrandsListingVC: BrandsListingVMDelegate{
    func brandListingSuccess(message: String) {
        self.mainTableView.reloadData()
    }
    
    func brandListingFailed(error: String) {
    }
}
