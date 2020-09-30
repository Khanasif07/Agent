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
    var locationValue =  CLLocationCoordinate2D(latitude: GarageProfileModel.shared.latitude, longitude: GarageProfileModel.shared.longitude)
    let markerView = UIImageView(frame:CGRect(x: 0, y: 0, width: 21, height: 21))
    var gmssMarker = GMSMarker()
    var getLocation: ((CLLocationCoordinate2D,String)->())?
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
        if !self.hasImageUploaded{
             ToastView.shared.showLongToast(self.view, msg: LocalizedString.wait_Img_Upload.localized)
            return
        }
        if GarageProfileModel.shared.serviceCenterImages.isEmpty{
            ToastView.shared.showLongToast(self.view, msg: "please upload atlest one image")
            return
        }
        AppRouter.goToUploadDocumentVC(vc: self)
    }
    
    @IBAction func helpBtnAction(_ sender: UIButton) {
        showAlert(msg: LocalizedString.underDevelopment.localized)
    }
}

// MARK: - Extension For Functions
//===========================
extension GarageAddImageVC {
    
    private func initialSetup() {
        self.collViewSetUp()
        self.prepareMap()
        self.setAddress()
        self.reloadCollectionViewWithUIUpdation()
        self.saveContinueBtn.isEnabled = true
        logoImgView.image = GarageProfileModel.shared.logo
        garageName.text = GarageProfileModel.shared.serviceCenterName
    }
    
    private func prepareMap() {
        self.mapView.isMyLocationEnabled = true
        self.mapView.delegate = self
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
    
    @objc private func crossImageBtnTapped(_ sender: UIButton) {
        if !self.hasImageUploaded{
            self.showAlert(msg: LocalizedString.wait_Img_Upload.localized)
            return
        }
        if let index = self.mainCollView.indexPath(forItem: sender){
            if GarageProfileModel.shared.serviceCenterImages.endIndex > index.item {
                GarageProfileModel.shared.serviceCenterImages.remove(at: index.item)
            }
        }
        self.reloadCollectionViewWithUIUpdation()
    }
    
   @objc private func addImageBtnTapped(_ sender: UIButton) {
    if !self.hasImageUploaded{
        self.showAlert(msg: LocalizedString.wait_Img_Upload.localized)
        return
    }
    self.captureImage(delegate: self)
    }
    
    func reloadCollectionViewWithUIUpdation(){
        if GarageProfileModel.shared.serviceCenterImages.endIndex > 2 {
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
}

//MARK:-
//=====
extension GarageAddImageVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let imagesArray = GarageProfileModel.shared.serviceCenterImages
        if !imagesArray.isEmpty && imagesArray.count <= 4{
            return imagesArray.count + 1
        }else if imagesArray.count == 5{
            return imagesArray.count
        }else{
            return 1
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let imagesArray = GarageProfileModel.shared.serviceCenterImages
        let imageCell = collectionView.dequeueCell(with: AddImageCollCell.self, indexPath: indexPath)
        imageCell.crossBtn.addTarget(self, action: #selector(crossImageBtnTapped(_:)), for: .touchUpInside)
        imageCell.addImgBtn.addTarget(self, action: #selector(addImageBtnTapped(_:)), for: .touchUpInside)
        if !self.hasImageUploaded && (indexPath.row == imagesArray.count - 1){
            imageCell.activityIndictor.isHidden = false
            imageCell.activityIndictor.startAnimating()
        }else{
            imageCell.activityIndictor.isHidden = true
            imageCell.activityIndictor.stopAnimating()
        }
        var data: ImageModel?
        if !imagesArray.isEmpty && imagesArray.count <= 4 && indexPath.item < imagesArray.count {
            data = imagesArray[indexPath.item]
            if let imageUrl = data?.url {
                if imageUrl.isEmpty {
                    imageCell.mainImgView.image = data?.image ?? nil
                } else {
                    imageCell.mainImgView.setImage_kf(imageString: imageUrl, placeHolderImage: #imageLiteral(resourceName: "icUnCheck"))
                }
            }
            
        } else if !imagesArray.isEmpty && imagesArray.count == 5 && indexPath.item < imagesArray.count{
            data = imagesArray[indexPath.item]
            if let imageUrl = data?.url {
                if imageUrl.isEmpty {
                    imageCell.mainImgView.image = data?.image ?? nil
                } else {
                    imageCell.mainImgView.setImage_kf(imageString: imageUrl, placeHolderImage: #imageLiteral(resourceName: "icUnCheck"))
                }
            }
        }else {
            imageCell.activityIndictor.isHidden = true
            imageCell.mainImgView.image = UIImage()
        }
        if !imagesArray.isEmpty{
            if indexPath.item == imagesArray.count{
                imageCell.crossBtn.isHidden = true
                imageCell.addImgBtn.isHidden = false
                imageCell.dataContainerView.isHidden = false
            }else{
                imageCell.crossBtn.isHidden = false
                imageCell.addImgBtn.isHidden = true
                imageCell.dataContainerView.isHidden = true
            }
        }else{
            imageCell.crossBtn.isHidden = true
            imageCell.addImgBtn.isHidden = false
            imageCell.dataContainerView.isHidden = false
            
        }
        return imageCell
    }
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: ((self.mainCollView.frame.width - 24.0) / 3), height: 85.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}


// MARK: - UIImagePickerControllerDelegate
//===========================
extension GarageAddImageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate , RemovePictureDelegate {
    func removepicture() {
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        hasImageUploaded = false
        GarageProfileModel.shared.serviceCenterImages.append(ImageModel(url: "", mediaType: "image", image: image ?? UIImage()))
        self.reloadCollectionViewWithUIUpdation()
        image?.upload(progress: { (progress) in
            printDebug(progress)
        }, completion: { (response,error) in
            if let url = response {
                self.hasImageUploaded = true
                let lastIndex = GarageProfileModel.shared.serviceCenterImages.endIndex
                GarageProfileModel.shared.serviceCenterImages[lastIndex-1].url = url
                DispatchQueue.main.async {
                    self.mainCollView.reloadData()
                }
            }
            if let _ = error{
                DispatchQueue.main.async {
                    self.mainCollView.reloadData()
                }
                self.showAlert(msg: LocalizedString.imageUploadingFailed.localized)
            }
        })
        picker.dismiss(animated: true, completion: nil)
    }
  
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
   
}
