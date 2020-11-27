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
    @IBOutlet weak var editLogoBtn: UIButton!
    @IBOutlet weak var dashedView: RectangularDashedView!

    // MARK: - Variables
    //===========================
    var viewModel = ProfileVM()
    var locationValue =  CLLocationCoordinate2D(latitude: GarageProfileModel.shared.latitude, longitude: GarageProfileModel.shared.longitude)
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    private var locationManager = CLLocationManager()
    let markerView = UIImageView(frame:CGRect(x: 0, y: 0, width: 21, height: 21))
    var gmssMarker = GMSMarker()
    var getLocation: ((CLLocationCoordinate2D,String)->())?
    var currentZoomLevel: Float = 14.0
    private var mapPermission: Bool = false
    private var isMarkerAnimation : Bool = false
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true

    }
    // MARK: - IBActions
    //===========================
    
    @IBAction func saveContinueAction(_ sender: UIButton) {
        GarageProfileModel.shared.latitude = latitude
        GarageProfileModel.shared.longitude = longitude
        GarageProfileModel.shared.address = liveAddress
        AppRouter.goToGarageProfileStep2VC(vc: self)
    }
    
    @IBAction func editLogoBtnAction(_ sender: UIButton) {
        self.captureImage(delegate: self)
    }
    
    @IBAction func currentLocationBtnAction(_ sender: UIButton) {
        isMapLocationEnable()
    }
    
    @IBAction func helpBtnAction(_ sender: UIButton) {
        AppRouter.goToOneToOneChatVC(self, userId: AppConstants.adminId, requestId: "", name: "Support Chat", image: "", unreadMsgs: 0, isSupportChat: true,garageUserId: isCurrentUserType == .garage ? UserModel.main.id : "" )
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        pop()
    }
    
    private func isMapLocationEnable() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                openSettingApp(message: "")
            case .authorizedAlways, .authorizedWhenInUse:
                CommonFunctions.delay(delay: 0.1) {
                    self.didTapMyLocationButton(for: self.mapView)
                }
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
    }

}


// MARK: - Extension For Functions
//===========================
extension CompleteProfileStep1 {
    
    private func initialSetup() {
        self.setUpTextField()
        self.prepareMap()
       // self.setAddress()
        self.mapView.isMyLocationEnabled = true
        viewModel.delegate = self
        titleLbl.text = fromGarage == .editGarageProfile ? "Edit Profile" : "Complete Profile"
        saveContinueBtn.isEnabled = addBtnStatus()
        self.viewModel.getMyProfileData(params: [:])
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
        //        self.addressTxtField.selectedTitle = LocalizedString.mobileNo.localized
        [nameTxtField,distTxtField,addressTxtField].forEach({$0?.lineColor = AppColors.fontTertiaryColor})
        [nameTxtField,distTxtField,addressTxtField].forEach({$0?.selectedLineColor = AppColors.fontTertiaryColor})
        [nameTxtField,distTxtField,addressTxtField].forEach({$0?.selectedTitleColor = AppColors.fontTertiaryColor})
        [nameTxtField,distTxtField,addressTxtField].forEach({$0?.placeholderColor = AppColors.fontSecondaryColor})
        [nameTxtField,distTxtField,addressTxtField].forEach({$0?.delegate = self})
        self.saveContinueBtn.setTitle(LocalizedString.saveContinue.localized, for: .normal)
//        self.saveContinueBtn.isEnabled = false
    }
    
    private func prepareMap() {
//        self.mapView.isMyLocationEnabled = true
//        self.mapView.settings.myLocationButton = true
        self.mapView.delegate = self
      //  self.locationManager.delegate = self
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
    
    private func locationButtonTapped() {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    //OPEN SETTING
    func openSettingApp(message: String) {
//        self.showAlert(title: "", msg: message) {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
//        }
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
    
    func setPreFillData() {
        logoImgView.contentMode = .scaleToFill
        logoImgView.setImage_kf(imageString: GarageProfileModel.shared.logoUrl, placeHolderImage: #imageLiteral(resourceName: "icImg"), loader: true)
        dashedView.isHidden = true
        liveAddress = GarageProfileModel.shared.address
        addressTxtField.text = GarageProfileModel.shared.address
        nameTxtField.text = GarageProfileModel.shared.serviceCenterName
        distTxtField.text = GarageProfileModel.shared.serviceCenterDist
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
        if let location  = locations.last {
            self.locationValue = location.coordinate
            isMarkerAnimation = false
            self.moveMarker(coordinate: locationValue)
            self.setAddress()
        }
        locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if isMarkerAnimation {
            self.isMarkerAnimation = false
            self.locationValue = mapView.projection.coordinate(for: mapView.center)
            self.moveMarker(coordinate: locationValue)
            self.setAddress()
        }
        currentZoomLevel = position.zoom
    }
    
    @discardableResult  func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        guard let lat = mapView.myLocation?.coordinate.latitude,
            let lng = mapView.myLocation?.coordinate.longitude else { return false }
        self.isMarkerAnimation = false
        self.locationValue = CLLocationCoordinate2D.init(latitude: lat, longitude: lng)
        moveMarker(coordinate:  self.locationValue)
        self.setAddress()
        return true
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
        if let address =  place.formattedAddress {
            self.isMarkerAnimation =  false
            self.locationValue = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            self.addressTxtField.text = address
            
            self.latitude = place.coordinate.latitude
            self.longitude = place.coordinate.longitude
            liveAddress = address
            moveMarker(coordinate: CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
        }
        viewController.dismiss(animated: true)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}


extension CompleteProfileStep1: UIImagePickerControllerDelegate,UINavigationControllerDelegate, RemovePictureDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        CommonFunctions.showActivityLoader()
        editLogoBtn.setImage(#imageLiteral(resourceName: "vector"), for: .normal)
        logoImgView.contentMode = .scaleToFill
        logoImgView.image = image
        dashedView.isHidden = true
        image?.upload(progress: { (progress) in
            printDebug(progress)
        }, completion: { (response,error) in
            if let url = response {
                CommonFunctions.hideActivityLoader()
                GarageProfileModel.shared.logo = image
                GarageProfileModel.shared.logoUrl = url
            }
            if let _ = error{
                self.showAlert(msg: "Image upload failed")
            }
        })
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func removepicture() {
        
    }
}

extension CompleteProfileStep1 : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {return}
        switch textField {
        case nameTxtField:
            GarageProfileModel.shared.serviceCenterName = text
        case addressTxtField:
            GarageProfileModel.shared.address = text
        case distTxtField:
            GarageProfileModel.shared.serviceCenterDist = text
        default:
            break
        }
        saveContinueBtn.isEnabled = addBtnStatus()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case addressTxtField:
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            present(acController, animated: true, completion: nil)
            return false
        default:
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          let currentText = textField.text ?? ""
         guard let stringRange = Range(range, in: currentText) else { return false }
         let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
         return updatedText.count <= 40
    }
    
    private func addBtnStatus()-> Bool{
        return !GarageProfileModel.shared.serviceCenterName.isEmpty && !GarageProfileModel.shared.address.isEmpty && !GarageProfileModel.shared.serviceCenterDist.isEmpty
    }
}

extension CompleteProfileStep1 :ProfileVMDelegate{
    
    func getProfileDataSuccess(msg: String) {
        setPreFillData()
    }
    
    func getProfileDataFailed(msg: String, error: Error) {
        
    }
}

