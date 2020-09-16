//
//  GarageAddImageVC.swift
//  ArabianTyres
//
//  Created by Admin on 15/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import GoogleMaps
import GooglePlaces
import UIKit
import DKImagePickerController


class GarageAddImageVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var collViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var locationTextLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var mainCollView: UICollectionView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    // MARK: - Variables
    //===========================
    var locationValue = LocationController.sharedLocationManager.locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 34.052238, longitude: -118.24334)
    private var locationManager = CLLocationManager()
    let markerView = UIImageView(frame:CGRect(x: 0, y: 0, width: 41, height: 56.0))
    var gmssMarker = GMSMarker()
    var getLocation: ((CLLocationCoordinate2D,String)->())?
    var currentZoomLevel: Float = 14.0
    private var mapPermission: Bool = false
    private var isMarkerAnimation : Bool = true
    private var liveAddress : String = ""
    var imagesArray = [String]()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    
    // MARK: - IBActions
    //===========================
    
    
}

// MARK: - Extension For Functions
//===========================
extension GarageAddImageVC {
    
    private func initialSetup() {
        self.collViewSetUp()
        self.prepareMap()
        self.setAddress()
    }
    
    private func prepareMap() {
        self.mapView.isMyLocationEnabled = true
        self.mapView.delegate = self
        self.locationManager.delegate = self
        markerView.image = #imageLiteral(resourceName: "notification")
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
            self.locationTextLbl.text = "\(lines.joined(separator: ","))"
            self.liveAddress = lines.joined(separator: ",")
        }
    }
    
    private func addMarkers() {
        mapView.clear()
    }
    
    private func collViewSetUp(){
        mainCollView.dataSource = self
        mainCollView.delegate = self
        mainCollView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        mainCollView.registerCell(with: AddImageCollCell.self)
        self.mainCollView.isScrollEnabled = false
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
    
   @objc private func addImageBtnTapped(_ sender: UIButton) {
    self.imagesArray.append("Hello")
    self.reloadCollectionViewWithUIUpdation()
//        if !self.hasImageUploaded{
//            self.showAlert(msg: StringConstants.wait_Img_Upload)
//            return
//        }

//        let pickerController = DKImagePickerController()
//        pickerController.assetType = .allPhotos
//        pickerController.maxSelectableCount = 1
//        pickerController.didSelectAssets = { (assets: [DKAsset]) in
//
//            if (self.imagesArray.count > 5){
////                self.showAlert(msg: StringConstants.Upload5Images.localized)
//                return
//            }
//
//            for asset in assets{
//                if asset.type == .photo{
//                    asset.fetchOriginalImage { [weak self](image, _) in
//                        guard let strongSelf = self else{return}
//                        guard let res = image else {return}
//                        if asset.type == .photo{
//                            DispatchQueue.main.async {
//                                Cropper.shared.openCropper(withImage: res, mode: .square, on: strongSelf)
//                            }
//                        }
//                    }
//                }else {}
//            }
//            print("didSelectAssets")
//            print(assets)
//        }
//        self.present(pickerController, animated: true) {}
    }
    
    func reloadCollectionViewWithUIUpdation(){
        if imagesArray.count > 2 {
            DispatchQueue.main.async {
                self.collViewHeightConst.constant = 110 * 2
            }
        }
        DispatchQueue.main.async {
            self.mainCollView.reloadData()
        }
    }
}
// MARK: - Map and cluster Functions
//==================================
extension GarageAddImageVC :  GMSMapViewDelegate ,CLLocationManagerDelegate {
    
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
extension GarageAddImageVC: GMSAutocompleteViewControllerDelegate {
    
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


//MARK:-
//=====
extension GarageAddImageVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        if !self.imagesArray.isEmpty && self.imagesArray.count <= 4{
            return self.imagesArray.count + 1
        }else if self.imagesArray.count == 5{
            return self.imagesArray.count
        }else{
            return 1
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell = collectionView.dequeueCell(with: AddImageCollCell.self, indexPath: indexPath)
        if (indexPath.row == self.imagesArray.count - 1){
            imageCell.activityIndictor.startAnimating()
        }else{
            imageCell.activityIndictor.stopAnimating()
        }
        if !self.imagesArray.isEmpty && self.imagesArray.count <= 4 && indexPath.item < self.imagesArray.count {
//            data = self.imagesArray[indexPath.item]
            
        } else if !self.imagesArray.isEmpty && self.imagesArray.count == 5 && indexPath.item < self.imagesArray.count{
        }else {
            imageCell.mainImgView.image = #imageLiteral(resourceName: "group3875")
        }
        
        imageCell.addImgBtn.addTarget(self, action: #selector(addImageBtnTapped(_:)), for: .touchUpInside)

        if !self.imagesArray.isEmpty{
            
            if indexPath.item == self.imagesArray.count{
//                imageCell.crossBtn.isHidden = true
//                imageCell.addImage.isHidden = false
            }else{
//                imageCell.crossBtn.isHidden = false
//                imageCell.addImage.isHidden = true
            }
        }else{
//            imageCell.crossBtn.isHidden = true
//            imageCell.addImage.isHidden = false
            
        }
        
  
//        imageCell.addImage.addTarget(self, action: #selector(addEventImageBtnTapped(_:)), for: .touchUpInside)
        
        return imageCell
    }
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.mainCollView.frame.width / 3) - 5, height: 72.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

