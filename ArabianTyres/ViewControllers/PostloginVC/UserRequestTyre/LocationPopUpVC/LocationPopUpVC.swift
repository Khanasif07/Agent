//
//  LocationPopUpVC.swift
//  ArabianTyres
//
//  Created by Arvind on 18/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class LocationPopUpVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var subHeadingLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var allowBtn: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.dataContainerView.addShadow(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
    }
    
    // MARK: - Variables
    //===========================
    private var locationValue = LocationController.sharedLocationManager.locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 34.052238, longitude: -118.24334)
    private var locationManager = CLLocationManager()
    private var isLocationEnable : Bool = true
    private var isHitApi: Bool = false
    var onAllowTap: (()->())?
    // MARK: - Lifecycle


    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func allowBtnAction(_ sender: UIButton) {
        self.setupLocations()
    }
}

// MARK: - Extension For Functions
//===========================
extension LocationPopUpVC {
    
    private func initialSetup() {
        setupTextAndFont()
        isMapLocationEnable()
    }
    
    private func setupTextAndFont(){
        self.isHitApi = false
        self.locationManager.delegate = self
        headingLbl.text = LocalizedString.arabianTyresWantToAccessYourCurrentLocation.localized
        subHeadingLbl.text = LocalizedString.allowCureentLocationWillHelpYouInGettingGreatOffers.localized
        
        headingLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        subHeadingLbl.font = AppFonts.NunitoSansRegular.withSize(15.0)
        cancelBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        allowBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        
        cancelBtn.setTitle(LocalizedString.cancel.localized, for: .normal)
        allowBtn.setTitle(LocalizedString.allow.localized, for: .normal)
    }
    
    private func isMapLocationEnable() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                self.isLocationEnable = false
            case .authorizedAlways, .authorizedWhenInUse:
                self.isLocationEnable = true
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    ///SETUP LOCATIONS
    private func setupLocations() {
        let status = CLLocationManager.authorizationStatus()
        if CLLocationManager.locationServicesEnabled() {
            if  status == CLAuthorizationStatus.authorizedAlways
                || status == CLAuthorizationStatus.authorizedWhenInUse {
                TyreRequestModel.shared.latitude = "\(locationValue.latitude)"
                TyreRequestModel.shared.longitude = "\(locationValue.longitude)"
                self.dismiss(animated: true) {
                    self.onAllowTap?()
                }
            }
            else { self.openSettingApp() }
        }
        else{ self.openSettingApp() }
    }
    
    private func openSettingApp() {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
    }
}

// MARK: - LocationPopUpVMDelegate
//===========================

extension LocationPopUpVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.stopUpdatingLocation()
            self.locationManager.startUpdatingLocation()
            LocationController.sharedLocationManager.fetchCurrentLocation { [weak self] (location) in
                guard let strongSelf = self else { return }
                strongSelf.isLocationEnable = true
                TyreRequestModel.shared.latitude = "\(location.coordinate.latitude)"
                TyreRequestModel.shared.longitude = "\(location.coordinate.longitude)"
            }
        default:
            self.isLocationEnable = false
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
}
