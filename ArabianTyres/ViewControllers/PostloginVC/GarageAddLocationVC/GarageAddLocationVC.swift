//
//  GarageAddLocationVC.swift
//  ArabianTyres
//
//  Created by Admin on 16/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import UIKit
import GoogleMaps
import GooglePlaces

class GarageAddLocationVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var serviceAddresslbl: UILabel!
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var garageName: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var saveContinueBtn: AppButton!
    
    // MARK: - Variables
    //===========================
    var locationValue = LocationController.sharedLocationManager.locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 34.052238, longitude: -118.24334)
    private var locationManager = CLLocationManager()
    let markerView = UIImageView(frame:CGRect(x: 0, y: 0, width: 21, height: 21))
    var gmssMarker = GMSMarker()
    var getLocation: ((CLLocationCoordinate2D,String)->())?
    var currentZoomLevel: Float = 14.0
    private var mapPermission: Bool = false
    private var isMarkerAnimation : Bool = true
    private var liveAddress : String = ""
    var imagesArray = [ImageModel]()
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
        initialSetup()
        logoImgView.image = GarageProfileModel.shared.logo
        garageName.text = GarageProfileModel.shared.serviceCenterName
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func locationBtnAction(_ sender: UIButton) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func currentLocationBtnAction(_ sender: UIButton) {
        self.setupLocations()
    }
    
    
    @IBAction func saveAndContinueBtnAction(_ sender: UIButton) {
        GarageProfileModel.shared.latitude = locationValue.latitude
        GarageProfileModel.shared.longitude = locationValue.longitude
        GarageProfileModel.shared.address = liveAddress
        AppRouter.goToGarageAddImageVC(vc: self)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        pop()
    }
}

// MARK: - Extension For Functions
//===========================
extension GarageAddLocationVC {
    
    private func initialSetup() {
        self.prepareMap()
        setAddress()
        self.saveContinueBtn.isEnabled = false
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
            self.serviceAddresslbl.text = "\(lines.joined(separator: ","))"
            self.liveAddress = "\(lines.joined(separator: ","))"
            self.saveContinueBtn.isEnabled = true
        }
    }
    
    private func addMarkers() {
        mapView.clear()
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
    
    ///SETUP LOCATIONS
    private func setupLocations() {
        let status = CLLocationManager.authorizationStatus()
        if CLLocationManager.locationServicesEnabled() {
            if  status == CLAuthorizationStatus.authorizedAlways
                || status == CLAuthorizationStatus.authorizedWhenInUse {
                self.moveMarker(coordinate: locationValue)
                self.setAddress()
            }
            else { self.locationPermissonPopUp() }
        }
        else{ self.locationPermissonPopUp() }
    }
    
    private func locationPermissonPopUp() {
        openSettingApp(message: "We need permission to access this app")
    }
    
    private func openSettingApp(message: String) {
        
        self.showAlertWithAction(title: "", msg: message, cancelTitle: LocalizedString.cancel.localized, actionTitle: "Ok", actioncompletion: {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }) { }
    }
}


// MARK: - Map and cluster Functions
//==================================
extension GarageAddLocationVC :  GMSMapViewDelegate ,CLLocationManagerDelegate {
    
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
        self.moveMarker(coordinate: locationValue)
        self.setAddress()
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
extension GarageAddLocationVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        self.showAlert(msg: error.localizedDescription)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if let address =  place.formattedAddress {
            self.locationValue = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            self.serviceAddresslbl.text = address
            liveAddress = address
            moveMarker(coordinate: CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
        }
        viewController.dismiss(animated: true)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
