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
import RSKImageCropper


class GarageAddImageVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var saveContinueBtn: AppButton!
    @IBOutlet weak var collViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var locationTextLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var mainCollView: UICollectionView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var garageName: UILabel!

    
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
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.mapView.round(radius: 2.0)
    }
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_ sender: UIButton) {
        pop()
    }
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        AppRouter.goToUploadDocumentVC(vc: self)
    }
}

// MARK: - Extension For Functions
//===========================
extension GarageAddImageVC {
    
    private func initialSetup() {
        self.collViewSetUp()
        self.prepareMap()
        self.setAddress()
        self.saveContinueBtn.isEnabled = true
        logoImgView.image = GarageProfileModel.shared.logo
        garageName.text = GarageProfileModel.shared.serviceCenterName
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
    if !self.hasImageUploaded{
        self.showAlert(msg: LocalizedString.wait_Img_Upload.localized)
        return
    }
    self.captureImage(delegate: self)
    }
    
    func reloadCollectionViewWithUIUpdation(){
        if imagesArray.count > 2 {
            DispatchQueue.main.async {
                self.collViewHeightConst.constant = 90 * 2
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
        if !self.hasImageUploaded && (indexPath.row == self.imagesArray.count - 1){
            imageCell.activityIndictor.isHidden = false
            imageCell.activityIndictor.startAnimating()
        }else{
            imageCell.activityIndictor.isHidden = true
            imageCell.activityIndictor.stopAnimating()
        }
        var data: ImageModel?
        if !self.imagesArray.isEmpty && self.imagesArray.count <= 4 && indexPath.item < self.imagesArray.count {
            data = self.imagesArray[indexPath.item]
            if let imageUrl = data?.url {
                if imageUrl.isEmpty {
                    imageCell.mainImgView.image = data?.image ?? nil
                } else {
                    imageCell.mainImgView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "empty_album") , completed: nil)
                }
            }
            
        } else if !self.imagesArray.isEmpty && self.imagesArray.count == 5 && indexPath.item < self.imagesArray.count{
            data = self.imagesArray[indexPath.item]
            if let imageUrl = data?.url {
                    if imageUrl.isEmpty {
                        imageCell.mainImgView.image = data?.image ?? nil
                    } else {
                        imageCell.mainImgView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "empty_album") , completed: nil)
                    }
            }
        }else {
            imageCell.activityIndictor.isHidden = true
            imageCell.mainImgView.image = UIImage()
        }
        
        imageCell.addImgBtn.addTarget(self, action: #selector(addImageBtnTapped(_:)), for: .touchUpInside)

        if !self.imagesArray.isEmpty{
            
            if indexPath.item == self.imagesArray.count{
//                imageCell.addb.isHidden = true
                imageCell.addImgBtn.isHidden = false
            }else{
//                imageCell.crossBtn.isHidden = false
                imageCell.addImgBtn.isHidden = true
            }
        }else{
//            imageCell.crossBtn.isHidden = true
               imageCell.addImgBtn.isHidden = false
            
        }
        return imageCell
    }
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.mainCollView.frame.width / 3) - 5, height: 80.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}



// MARK: - UIImagePickerControllerDelegate
//===========================
extension GarageAddImageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate , RemovePictureDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        hasImageUploaded = false
        self.imagesArray.append(ImageModel(url: "", mediaType:"image", image: image ?? UIImage()))
        self.reloadCollectionViewWithUIUpdation()
        image?.upload(progress: { (progress) in
            printDebug(progress)
        }, completion: { (response,error) in
            if let url = response {
                self.hasImageUploaded = true
//                self.viewModel.userImageUrl = url
//                self.userProfileImgView.image = image
//                self.viewModel.image = self.userProfileImgView.image
            }
            if let _ = error{
//                self.showAlert(msg: LocalizedString.imageUploadingFailed.localized)
            }
        })
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func removepicture() {
//        self.userProfileImgView.image = #imageLiteral(resourceName: "icProfile")
//        self.viewModel.image = nil
//        self.viewModel.userImageUrl = ""
    }
}
