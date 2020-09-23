//
//  TyreBrandVC.swift
//  ArabianTyres
//
//  Created by Arvind on 17/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField


class TyreBrandVC: BaseVC {

    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var thePreferredLbl: UILabel!
    @IBOutlet weak var setYourPrefernceLbl: UILabel!
    @IBOutlet weak var submitBtn: AppButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tyreBrandCustomView: CustomTextView!
    @IBOutlet weak var countryOriginCustomView: CustomTextView!
    @IBOutlet weak var tBCustomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var countryOriginViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tyreBrandLbl: UILabel!
    @IBOutlet weak var countryOriginLbl: UILabel!
    @IBOutlet weak var tyreBrandCheckBtn: UIButton!
    @IBOutlet weak var countryOriginCheckBtn: UIButton!


    // MARK: - Variables
    //===========================
    var placeHolderArr : [String] = [LocalizedString.enterVehicleMake.localized,
     LocalizedString.enterVehicleModel.localized,
     LocalizedString.enterModelYear.localized
    ]
   
    var titleArr : [String] = [LocalizedString.vehicleMake.localized,
                                 LocalizedString.vehicleModel.localized,
                                 LocalizedString.modelYear.localized
                                ]
//    var brandListingArr :[String] = []
//    var countryListingArr :[String] = []
//    var listingType : ListingType = .brands
    var brandListingArr :[TyreBrandModel] = []
    var countryListingArr :[TyreCountryModel] = []
    var listingType : ListingType = .brands
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
      
        if !self.brandListingArr.isEmpty {
            if let tyreBrandCustomView = self.tyreBrandCustomView {
                self.tBCustomViewHeightConstraint.constant = tyreBrandCustomView.collView.contentSize.height + 38.0
                printDebug(tBCustomViewHeightConstraint.constant)
                printDebug(tyreBrandCustomView.collView.contentSize.height)
            }
        }else {
                self.tBCustomViewHeightConstraint.constant = 60.0
        }
        
        if !self.countryListingArr.isEmpty {
            if let countryOriginCustomView = self.countryOriginCustomView {
                self.countryOriginViewHeightConstraint.constant = countryOriginCustomView.collView.contentSize.height + 38.0
            }
        }else {
            self.countryOriginViewHeightConstraint.constant = countryOriginCheckBtn.isSelected ? 60.0 : 0.0
        }
    }
    
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        AppRouter.presentLocationPopUpVC(vc: self)
    }
    
    @IBAction func tyreCheckBtnAction(_ sender: UIButton) {
        tyreBrandCheckBtn.isSelected.toggle()
    }
    
    @IBAction func countryCheckBtnAction(_ sender: UIButton) {
        countryOriginCheckBtn.isSelected.toggle()
        countryOriginViewHeightConstraint.constant = countryOriginCheckBtn.isSelected ? 60.0 : 0.0
    }
   
}

// MARK: - Extension For Functions
//===========================
extension TyreBrandVC {
    
    private func initialSetup() {
        setupTextFont()
        setupCustomView()
        countryOriginViewHeightConstraint.constant = 0.0
    }
    
    private func setupTextFont() {
       
        countryOriginLbl.text = LocalizedString.countryOrigin.localized
        tyreBrandLbl.text = LocalizedString.tyreBrand.localized
        
        countryOriginLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        tyreBrandLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        thePreferredLbl.text = LocalizedString.thePreferredOriginForMytyreWouldBe.localized
        setYourPrefernceLbl.text = LocalizedString.setYourPreferencesAmongTyreBrandOrCountryOrigin.localized
        submitBtn.setTitle(LocalizedString.submit.localized, for: .normal)

        thePreferredLbl.font = AppFonts.NunitoSansBold.withSize(21.0)
        setYourPrefernceLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        submitBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        submitBtn.isEnabled = false
        
    }
    
    private func submitBtnStatus()-> Bool{
        return !TyreRequestModel.shared.countries.isEmpty &&  !TyreRequestModel.shared.tyreBrands.isEmpty
    }
    
    private func setupCustomView() {
        
        tyreBrandCustomView.placeHolderTxt = LocalizedString.selectTyreBrand.localized
        countryOriginCustomView.placeHolderTxt = LocalizedString.selectCountryOrigin.localized
        tyreBrandCustomView.floatLbl.text = LocalizedString.brands.localized
        countryOriginCustomView.floatLbl.text = LocalizedString.origin.localized

        
        countryOriginCustomView.delegate = self
        tyreBrandCustomView.delegate = self
        tyreBrandCustomView.listingType = .brands
        tyreBrandCustomView.leftImgContainerView.isHidden = true
        countryOriginCustomView.leftImgContainerView.isHidden = true
        countryOriginCustomView.listingType = .countries
        tyreBrandCustomView.rightImgView.image = #imageLiteral(resourceName: "group3689")
        tyreBrandCustomView.txtViewEditable = false
        countryOriginCustomView.txtViewEditable = false
        tyreBrandCustomView.collView.registerCell(with: FacilityCollectionViewCell.self)
        tyreBrandCustomView.collView.delegate = self
        tyreBrandCustomView.collView.dataSource = self
        countryOriginCustomView.collView.registerCell(with: FacilityCollectionViewCell.self)
        countryOriginCustomView.collView.delegate = self
        countryOriginCustomView.collView.dataSource = self
    }
    
}

extension TyreBrandVC :UITextFieldDelegate {
    
}


//MARK:-CollectionView Delegate and DataSource
extension TyreBrandVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if tyreBrandCustomView.collView == collectionView {
            return brandListingArr.count

        }else {
            return countryListingArr.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: FacilityCollectionViewCell.self, indexPath: indexPath)
        if tyreBrandCustomView.collView == collectionView {
            cell.skillLbl.text = brandListingArr[indexPath.item].name
        }else {
            cell.skillLbl.text = countryListingArr[indexPath.item].name

        }
        cell.cancelBtn.addTarget(self, action: #selector(cancelBtnTapped(_:)), for: .touchUpInside)
        cell.layoutSubviews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cardSizeForItemAt(collectionView,layout: collectionViewLayout,indexPath: indexPath)
    }
    
    private func cardSizeForItemAt(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        if tyreBrandCustomView.collView == collectionView {
            let textSize = brandListingArr[indexPath.row].name.sizeCount(withFont: AppFonts.NunitoSansSemiBold.withSize(13.0), boundingSize: CGSize(width: 10000.0, height: collectionView.frame.height))
            return CGSize(width: textSize.width + 40, height: 23.0)
        }else {
            let textSize = countryListingArr[indexPath.row].name.sizeCount(withFont: AppFonts.NunitoSansSemiBold.withSize(13.0), boundingSize: CGSize(width: 10000.0, height: collectionView.frame.height))
            return CGSize(width: textSize.width + 40, height: 23.0)
        }
        
    }

    @objc func cancelBtnTapped(_ sender : UIButton) {
        if let indexPath = self.tyreBrandCustomView.collView.indexPath(forItem: sender) {
            printDebug(indexPath)
            brandListingArr.remove(at: indexPath.item)
            if brandListingArr.isEmpty {
                tyreBrandCustomView.collView.isHidden = true
                tyreBrandCustomView.floatLbl.isHidden = true
                tyreBrandCheckBtn.isSelected = false
            }
            tyreBrandCustomView.collView.reloadData()
            view.layoutIfNeeded()
            view.setNeedsLayout()
        }
        
        if let indexPath = self.countryOriginCustomView.collView.indexPath(forItem: sender) {
            printDebug(indexPath)
            countryListingArr.remove(at: indexPath.item)
            if countryListingArr.isEmpty {
                countryOriginCustomView.collView.isHidden = true
                countryOriginCustomView.floatLbl.isHidden = true
            }
            countryOriginCustomView.collView.reloadData()
            view.layoutIfNeeded()
            view.setNeedsLayout()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

extension TyreBrandVC : CustomTextViewDelegate{
    func shouldBegin(_ tView: UITextView) {
        switch tView {
       
        case tyreBrandCustomView.tView:
            AppRouter.goToBrandsListingVC(vc: self, listingType: .brands, brandsData : brandListingArr, countryData: [])
        case countryOriginCustomView.tView:
            AppRouter.goToBrandsListingVC(vc: self, listingType: .countries, brandsData: [], countryData: countryListingArr)
        default:
            break
        }
    }
    
    func collViewTapped(listingType: ListingType) {
        openSheet(listingType: listingType)
    }
    
    private func openSheet(listingType: ListingType) {
        tyreBrandCustomView.collView.isHidden = false
        AppRouter.goToBrandsListingVC(vc: self, listingType: listingType,brandsData :  brandListingArr , countryData: countryListingArr)
    }
}

extension TyreBrandVC: BrandsListnig {
   
    func listing(listingType : ListingType,BrandsListings: [TyreBrandModel],countryListings: [TyreCountryModel]) {
        if listingType == .brands {
            brandListingArr = BrandsListings
            self.listingType = listingType
            brandListingArr = BrandsListings
            TyreRequestModel.shared.tyreBrands = BrandsListings.map({ (tyreModel) -> String in
                return tyreModel.id
            })
            self.submitBtn.isEnabled = submitBtnStatus()
            tyreBrandCheckBtn.isSelected = !brandListingArr.isEmpty
            tyreBrandCustomView.collView.isHidden = brandListingArr.isEmpty
            tyreBrandCustomView.floatLbl.isHidden = brandListingArr.isEmpty
            tyreBrandCustomView.collView.reloadData()
           
        }else {
            self.listingType = listingType
            countryListingArr = countryListings
            TyreRequestModel.shared.countries = countryListings.map({ (tyreCountryModel) -> String in
                return tyreCountryModel.name
            })
            self.submitBtn.isEnabled = submitBtnStatus()
            countryOriginCheckBtn.isSelected = !countryListingArr.isEmpty
            countryOriginCustomView.collView.isHidden = countryListingArr.isEmpty
            countryOriginCustomView.floatLbl.isHidden = countryListingArr.isEmpty
            countryOriginCustomView.collView.reloadData()
        }
        view.layoutIfNeeded()
        view.setNeedsLayout()
    }
}
