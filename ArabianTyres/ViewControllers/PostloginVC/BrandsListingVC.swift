//
//  BrandsListingVC.swift
//  ArabianTyres
//
//  Created by Arvind on 17/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

protocol BrandsListnig: class {
    func listing(_ data: [String])
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
    var selectedSkillArr : [String] = []
    var brandArr = ["All Brands", "MRF","Nokian Tyre","Apollo Tyres","CEAT Ltd","Goodyear","Peerless Tyre","Michelin ","Dunlop","Pirelli","Yokohama"]
    var selectedItem : [String] = []
    weak var delegate : BrandsListnig?
    var listingType : ListingType = .brands
    var viewModel = CountryVM()

    
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
        dismiss(animated: true) {
        self.delegate?.listing(self.selectedItem)
    }
    }

    @IBAction func clearAllAction(_ sender: UIButton) {
        
    }


}

// MARK: - Extension For Functions
//===========================
extension BrandsListingVC {

    private func initialSetup() {
        setupTextAndFont()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.registerHeaderFooter(with: FacilityTableHeaderView.self)
    }

    private func setupTextAndFont(){
       
        if listingType == .brands {
            titleLbl.text = LocalizedString.selectBrand.localized
            brandLbl.text = LocalizedString.brandName.localized

        } else {
            titleLbl.text = LocalizedString.selectCountry.localized
            brandLbl.text = LocalizedString.countryName.localized
            viewModel.getCountyData()
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
        if  (listingType == .brands) {
            return brandArr.count
        }else {
            return viewModel.searchedCountry.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueHeaderFooter(with: FacilityTableHeaderView.self)
        view.bottomView.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
        if listingType == .brands {
            view.categoryName.text = brandArr[section]

        }else {
            if let name = viewModel.searchedCountry[section][CountryVM.CountryKeys.name.rawValue]{
                view.categoryName.text = name
            }
        }
        view.checkBtn.isSelected = selectedItem.contains(brandArr[section])
        
        view.cellBtnTapped = { [weak self] in
            guard let `self` = self else {return}
            let item = self.brandArr[section]
            
            if item == self.brandArr[0] {
                self.selectedItem.removeAll()
                self.selectedItem.append(item)
            }else {
                if self.selectedItem.contains(self.brandArr[0]) {
                    self.selectedItem = []
                }
                self.selectedItem.contains(item) ? self.selectedItem.removeAll{($0 == item)} : self.selectedItem.append(item)
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
}
