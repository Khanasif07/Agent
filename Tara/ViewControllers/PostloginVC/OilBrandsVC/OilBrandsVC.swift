//
//  OilBrandsVC.swift
//  ArabianTyres
//
//  Created by Arvind on 24/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import SkyFloatingLabelTextField


class OilBrandsVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var thePreferredLbl: UILabel!
    @IBOutlet weak var chooseOilBrandLbl: UILabel!
    @IBOutlet weak var submitBtn: AppButton!
    @IBOutlet weak var skipBtn: AppButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var oilBrandCustomView: CustomTextView!
    @IBOutlet weak var oBCustomViewHeightConstraint: NSLayoutConstraint!
    
    
    
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
    //Location
    private var locationValue = LocationController.sharedLocationManager.locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 18.052238, longitude: 77.24334)
    private var locationManager = CLLocationManager()
    private var isLocationEnable : Bool = true
    private var isHitApi: Bool = false
    
    
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
            if let oilBrandCustomView = self.oilBrandCustomView {
                self.oBCustomViewHeightConstraint.constant = oilBrandCustomView.collView.contentSize.height + 38.0
            }
        }else {
            self.oBCustomViewHeightConstraint.constant = 60.0
        }
    }
    
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        isHitApi = true
        setupLocations()
        
    }
    
    @IBAction func skipBtnAction(_ sender: UIButton) {
        brandListingArr = []
        countryListingArr = []
        TyreRequestModel.shared.selectedTyreCountryListings = []
        TyreRequestModel.shared.selectedTyreBrandsListings = []
        listing(listingType: listingType, BrandsListings: brandListingArr, countryListings: countryListingArr)
        isHitApi = true
        setupLocations()
    }
    
}

// MARK: - Extension For Functions
//===========================
extension OilBrandsVC {
    
    private func initialSetup() {
        locationManager.delegate = self
        LocationController.sharedLocationManager.fetchCurrentLocation { (location) in
            LocationController.sharedLocationManager.currentLocation = location
        }
        brandListingArr = TyreRequestModel.shared.selectedTyreBrandsListings
        countryListingArr = TyreRequestModel.shared.selectedTyreCountryListings
        setupTextFont()
        setupCustomView()
        setupTextFont()
        listing(listingType: listingType, BrandsListings: brandListingArr, countryListings: countryListingArr)
    }
    
    private func setupTextFont() {
        thePreferredLbl.font = AppFonts.NunitoSansBold.withSize(21.0)
        chooseOilBrandLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        skipBtn.setTitleColor(AppColors.appRedColor, for: .normal)
        skipBtn.setTitle(LocalizedString.skipAndSubmit.localized, for: .normal)
        thePreferredLbl.text = LocalizedString.thePreferredBrandForMyOilWouldBe.localized
        chooseOilBrandLbl.text = LocalizedString.chooseOilBrand.localized
        submitBtn.setTitle(LocalizedString.submit.localized, for: .normal)
        submitBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        submitBtn.isEnabled = true
        
    }
    
    private func submitBtnStatus()-> Bool{
        return !TyreRequestModel.shared.tyreBrands.isEmpty
    }
    
    private func setupCustomView() {
        let layout = AlignmentFlowLayout()
        layout.horizontalAlignment = .left
        layout.verticalAlignment = .bottom
        oilBrandCustomView.collView.collectionViewLayout = layout
        oilBrandCustomView.placeHolderTxt = LocalizedString.selectBrand.localized
        oilBrandCustomView.floatLbl.text = LocalizedString.brands.localized
        oilBrandCustomView.delegate = self
        oilBrandCustomView.leftImgContainerView.isHidden = true
        oilBrandCustomView.rightImgView.image = #imageLiteral(resourceName: "group3689")
        oilBrandCustomView.txtViewEditable = false
        oilBrandCustomView.collView.registerCell(with: FacilityCollectionViewCell.self)
        oilBrandCustomView.collView.delegate = self
        oilBrandCustomView.collView.dataSource = self
        
    }
    
    ///SETUP LOCATIONS
    private func setupLocations() {
        let status = CLLocationManager.authorizationStatus()
        if CLLocationManager.locationServicesEnabled() {
            if  status == CLAuthorizationStatus.authorizedAlways
                || status == CLAuthorizationStatus.authorizedWhenInUse {
                self.setAddress()
                TyreRequestModel.shared.latitude = "\(locationValue.latitude)"
                TyreRequestModel.shared.longitude = "\(locationValue.longitude)"
                AppRouter.goToOilRequestedVC(vc: self)
            }
            else { AppRouter.presentLocationPopUpVC(vc: self) }
        }
        else{ AppRouter.presentLocationPopUpVC(vc: self) }
    }
    
    private func setAddress() {
           GMSGeocoder().reverseGeocodeCoordinate(locationValue) { (response, error) in
               
               guard let address = response?.firstResult(), let lines = address.lines else { return }
               _ = (address.locality?.isEmpty ?? true) ? ((address.subLocality?.isEmpty ?? true) ? ((address.administrativeArea?.isEmpty ?? true) ? address.country : address.administrativeArea)  : address.subLocality)   : address.locality
                TyreRequestModel.shared.address = lines.joined(separator: ",")
           }
       }
    
}

extension OilBrandsVC :UITextFieldDelegate {
    
}


//MARK:-CollectionView Delegate and DataSource
extension OilBrandsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandListingArr.count
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
        if let indexPath = self.oilBrandCustomView.collView.indexPath(forItem: sender) {
            printDebug(indexPath)
            brandListingArr.remove(at: indexPath.item)
            if brandListingArr.isEmpty {
                oilBrandCustomView.collView.isHidden = true
                oilBrandCustomView.floatLbl.isHidden = true
            }
            oilBrandCustomView.collView.reloadData()
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

extension OilBrandsVC : CustomTextViewDelegate{
    func shouldBegin(_ tView: UITextView) {
        switch tView {
            
        case oilBrandCustomView.tView:
            AppRouter.goToBrandsListingVC(vc: self, listingType: .brands, brandsData : brandListingArr, countryData: [], category: .oil)
        default:
            break
        }
    }
    
    func collViewTapped(listingType: ListingType) {
        openSheet(listingType: listingType)
    }
    
    private func openSheet(listingType: ListingType) {
        oilBrandCustomView.collView.isHidden = false
        AppRouter.goToBrandsListingVC(vc: self, listingType: listingType,brandsData :  brandListingArr , countryData: countryListingArr, category: .oil)
    }
}

extension OilBrandsVC: BrandsListnig {
    
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
            oilBrandCustomView.collView.isHidden = brandListingArr.isEmpty
            oilBrandCustomView.floatLbl.isHidden = brandListingArr.isEmpty
            oilBrandCustomView.collView.reloadData()
            
        }
        view.layoutIfNeeded()
        view.setNeedsLayout()
    }
}

// MARK: - LocationPopUpVMDelegate
//==============================
extension OilBrandsVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location  = locations.last {
            self.locationValue = location.coordinate
            TyreRequestModel.shared.latitude = "\(location.coordinate.latitude)"
            TyreRequestModel.shared.longitude = "\(location.coordinate.longitude)"
            self.setAddress()
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.stopUpdatingLocation()
            self.locationManager.startUpdatingLocation()
            LocationController.sharedLocationManager.fetchCurrentLocation { [weak self] (location) in
                guard let strongSelf = self else { return }
                strongSelf.isLocationEnable = true
                strongSelf.locationValue = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                strongSelf.setAddress()
                TyreRequestModel.shared.latitude = "\(location.coordinate.latitude)"
                TyreRequestModel.shared.longitude = "\(location.coordinate.longitude)"
            }
        default:
            self.isLocationEnable = false
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
}
