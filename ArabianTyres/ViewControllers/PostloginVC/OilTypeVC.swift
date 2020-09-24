//
//  OilTypeVC.swift
//  ArabianTyres
//
//  Created by Arvind on 24/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit


class OilTypeVC: BaseVC {

    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var thePreferredLbl: UILabel!
    @IBOutlet weak var chooseOilTypeLbl: UILabel!
    @IBOutlet weak var submitBtn: AppButton!
    @IBOutlet weak var skipBtn: AppButton!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var oilTypeCustomView: CustomTextView!
    @IBOutlet weak var oTCustomViewHeightConstraint: NSLayoutConstraint!
   


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
    var brandListingArr :[TyreBrandModel] = []
    var countryListingArr :[TyreCountryModel] = []
    var listingType : ListingType = .brands
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
      
        if !self.brandListingArr.isEmpty {
            if let oilTypeCustomView = self.oilTypeCustomView {
                self.oTCustomViewHeightConstraint.constant = oilTypeCustomView.collView.contentSize.height + 38.0
            }
        }else {
                self.oTCustomViewHeightConstraint.constant = 60.0
        }
    }
    
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        AppRouter.goToURTyreSizeVC(vc: self)
    }
    
    @IBAction func skipBtnAction(_ sender: UIButton) {
        print("skip btn tap")
    }
   
}

// MARK: - Extension For Functions
//===========================
extension OilTypeVC {
    
    private func initialSetup() {
        setupTextFont()
        setupCustomView()
    }
    
    private func setupTextFont() {
        thePreferredLbl.font = AppFonts.NunitoSansBold.withSize(21.0)
        chooseOilTypeLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
       
        thePreferredLbl.text = LocalizedString.theTypeOfOilAreYouLookingFor.localized
        chooseOilTypeLbl.text = LocalizedString.thePreferredOriginForMytyreWouldBe.localized
        submitBtn.setTitle(LocalizedString.submit.localized, for: .normal)
        submitBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        submitBtn.isEnabled = true
        
    }
    
    private func submitBtnStatus()-> Bool{
        return !TyreRequestModel.shared.countries.isEmpty
    }
    
    private func setupCustomView() {
       
        oilTypeCustomView.placeHolderTxt = LocalizedString.selectType.localized
        oilTypeCustomView.floatLbl.text = LocalizedString.oilType.localized
        oilTypeCustomView.delegate = self
        oilTypeCustomView.leftImgContainerView.isHidden = true
        oilTypeCustomView.rightImgView.image = #imageLiteral(resourceName: "group3689")
        oilTypeCustomView.txtViewEditable = false
        oilTypeCustomView.collView.registerCell(with: FacilityCollectionViewCell.self)
        oilTypeCustomView.collView.delegate = self
        oilTypeCustomView.collView.dataSource = self
      
    }
}

//MARK:-CollectionView Delegate and DataSource
extension OilTypeVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return countryListingArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: FacilityCollectionViewCell.self, indexPath: indexPath)
            cell.skillLbl.text = brandListingArr[indexPath.item].name
  
        cell.cancelBtn.addTarget(self, action: #selector(cancelBtnTapped(_:)), for: .touchUpInside)
        cell.layoutSubviews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cardSizeForItemAt(collectionView,layout: collectionViewLayout,indexPath: indexPath)
    }
    
    private func cardSizeForItemAt(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
            let textSize = brandListingArr[indexPath.row].name.sizeCount(withFont: AppFonts.NunitoSansSemiBold.withSize(13.0), boundingSize: CGSize(width: 10000.0, height: collectionView.frame.height))
            return CGSize(width: textSize.width + 40, height: 23.0)
      
        
    }

    @objc func cancelBtnTapped(_ sender : UIButton) {
        if let indexPath = self.oilTypeCustomView.collView.indexPath(forItem: sender) {
            printDebug(indexPath)
            brandListingArr.remove(at: indexPath.item)
            if brandListingArr.isEmpty {
                oilTypeCustomView.collView.isHidden = true
                oilTypeCustomView.floatLbl.isHidden = true
            }
            oilTypeCustomView.collView.reloadData()
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

extension OilTypeVC : CustomTextViewDelegate{
    func shouldBegin(_ tView: UITextView) {
        switch tView {
       
        case oilTypeCustomView.tView:
            AppRouter.goToBrandsListingVC(vc: self, listingType: .brands, brandsData : brandListingArr, countryData: [], category: .oil)
        default:
            break
        }
    }
    
    func collViewTapped(listingType: ListingType) {
        openSheet(listingType: listingType)
    }
    
    private func openSheet(listingType: ListingType) {
        oilTypeCustomView.collView.isHidden = false
        AppRouter.goToBrandsListingVC(vc: self, listingType: listingType,brandsData :  brandListingArr , countryData: countryListingArr, category: .oil)
    }
}

extension OilTypeVC: BrandsListnig {
   
    func listing(listingType : ListingType,BrandsListings: [TyreBrandModel],countryListings: [TyreCountryModel]) {
        if listingType == .brands {
            brandListingArr = BrandsListings
            self.listingType = listingType
            brandListingArr = BrandsListings
            TyreRequestModel.shared.tyreBrands = BrandsListings.map({ (tyreModel) -> String in
                return tyreModel.id
            })
            TyreRequestModel.shared.tyreBrandsListing = BrandsListings.map({ (tyreModel) -> String in
                return tyreModel.name
            })
            self.submitBtn.isEnabled = submitBtnStatus()
            oilTypeCustomView.collView.isHidden = brandListingArr.isEmpty
            oilTypeCustomView.floatLbl.isHidden = brandListingArr.isEmpty
            oilTypeCustomView.collView.reloadData()
           
        }
        view.layoutIfNeeded()
        view.setNeedsLayout()
    }
}
