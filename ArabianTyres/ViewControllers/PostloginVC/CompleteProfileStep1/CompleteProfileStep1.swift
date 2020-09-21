//
//  CompleteProfileStep1.swift
//  ArabianTyres
//
//  Created by Admin on 17/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit
import GoogleMaps
import GooglePlaces
import SkyFloatingLabelTextField

class CompleteProfileStep1: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var centreNameLbl: UILabel!
    @IBOutlet weak var distTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var addressTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var nameTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var saveContinueBtn: AppButton!
    
    // MARK: - Variables
    //===========================
    var locationValue = LocationController.sharedLocationManager.locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: GarageProfileModel.shared.latitude, longitude: GarageProfileModel.shared.longitude)
    private var locationManager = CLLocationManager()
    let markerView = UIImageView(frame:CGRect(x: 0, y: 0, width: 41, height: 56.0))
    var gmssMarker = GMSMarker()
    var getLocation: ((CLLocationCoordinate2D,String)->())?
    var currentZoomLevel: Float = 14.0
    private var mapPermission: Bool = false
    private var isMarkerAnimation : Bool = true
    private var liveAddress : String = ""
    fileprivate var hasImageUploaded = true {
        didSet {
            if hasImageUploaded {
                print("StringConstants.K_PROFILE_PIC_UPLOADED.localized")
            }
        }
    }
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func locationBtnAction(_ sender: UIButton) {
        
    }
    
    @IBAction func saveContinueAction(_ sender: UIButton) {
        AppRouter.goToGarageProfileStep2VC(vc: self)
    }
}


// MARK: - Extension For Functions
//===========================
extension CompleteProfileStep1 {
    
    private func initialSetup() {
        self.setUpTextField()
        self.prepareMap()
        self.setAddress()
    }
    
    public func setUpTextField(){
        self.distTxtField.title = LocalizedString.serviceCenterDist.localized
        self.nameTxtField.title = LocalizedString.serviceCenterNames.localized
        self.nameTxtField.selectedTitle = LocalizedString.serviceCenterNames.localized
        self.distTxtField.selectedTitle = LocalizedString.serviceCenterDist.localized
        self.nameTxtField.placeholder = LocalizedString.enterServiceCenterName.localized
        self.addressTxtField.placeholder = LocalizedString.enterServiceCenterAddress.localized
        self.distTxtField.placeholder = LocalizedString.enterServiceCenterDist.localized
        self.addressTxtField.title = LocalizedString.serviceCenterAddress.localized
        self.addressTxtField.selectedTitle = LocalizedString.mobileNo.localized
        [nameTxtField,distTxtField,addressTxtField].forEach({$0?.lineColor = AppColors.fontTertiaryColor})
        [nameTxtField,distTxtField,addressTxtField].forEach({$0?.selectedLineColor = AppColors.fontTertiaryColor})
        [nameTxtField,distTxtField,addressTxtField].forEach({$0?.selectedTitleColor = AppColors.fontTertiaryColor})
        self.saveContinueBtn.setTitle(LocalizedString.saveContinue.localized, for: .normal)
//        self.saveContinueBtn.isEnabled = false
    }
    private func prepareMap() {
        self.mapView.isMyLocationEnabled = true
        self.mapView.delegate = self
        self.locationManager.delegate = self
        markerView.image = #imageLiteral(resourceName: "markerIcon")
        self.gmssMarker = GMSMarker(position: CLLocationCoordinate2D(latitude:  locationValue.latitude, longitude: locationValue.longitude))
        DispatchQueue.main.async {
            self.gmssMarker.map = self.mapView
        }
        gmssMarker.iconView = markerView
        let camera = GMSCameraPosition.camera(withLatitude: locationValue.latitude, longitude: locationValue.longitude, zoom: 14.0)
        mapView.animate(to: camera)
    }
    private func setAddress() {
        GMSGeocoder().reverseGeocodeCoordinate(locationValue) { (response, error) in
            
            guard let address = response?.firstResult(), let lines = address.lines else { return }
            _ = (address.locality?.isEmpty ?? true) ? ((address.subLocality?.isEmpty ?? true) ? ((address.administrativeArea?.isEmpty ?? true) ? address.country : address.administrativeArea)  : address.subLocality)   : address.locality
            self.addressTxtField.text = "\(lines.joined(separator: ","))"
            self.liveAddress = lines.joined(separator: ",")
        }
    }
    
    private func addMarkers() {
        mapView.clear()
    }

    private func locationButtonTapped() {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    //OPEN SETTING
    func openSettingApp(message: String) {
        self.showAlert(title: "", msg: message) {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
    }
    
    func moveMarker(coordinate: CLLocationCoordinate2D){
        CATransaction.begin()
        CATransaction.setValue(0.0, forKey: kCATransactionAnimationDuration)
        self.mapView.animate(to: GMSCameraPosition.camera(withLatitude:coordinate.latitude, longitude: coordinate.longitude, zoom: currentZoomLevel))
        self.gmssMarker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CATransaction.commit()
        CommonFunctions.delay(delay: 1.0) {
            self.isMarkerAnimation = true
        }
    }
}
// MARK: - Map and cluster Functions
//==================================
extension CompleteProfileStep1 :  GMSMapViewDelegate ,CLLocationManagerDelegate {
    
    //MARK: Permission for current Location=====
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == .authorizedWhenInUse || status == .authorizedAlways){
            self.mapPermission = true
        } else {
            self.mapPermission = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.locationValue = locValue
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        printDebug(mapView.projection.coordinate(for: mapView.center))
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if isMarkerAnimation {
            self.isMarkerAnimation = false
            let currentCoordinate = mapView.projection.coordinate(for: mapView.center)
            self.locationValue = mapView.projection.coordinate(for: mapView.center)
            self.moveMarker(coordinate: currentCoordinate)
            self.setAddress()
        }
        currentZoomLevel = position.zoom
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        currentZoomLevel = position.zoom
    }
}

// MARK: - Google Auto complete
//==============================
extension CompleteProfileStep1: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        self.showAlert(msg: error.localizedDescription)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        locationValue = place.coordinate
        setAddress()
        moveMarker(coordinate: locationValue)
        viewController.dismiss(animated: true) { [weak self] in
            guard let `self` = self else { return }
            printDebug(self)
        }
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
