//
//  GarageProfileStep2.swift
//  ArabianTyres
//
//  Created by Arvind on 15/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SwiftyJSON
import SkyFloatingLabelTextField
//import TTRangeSlider

class GarageProfileStep2VC: BaseVC {

    // MARK: - IBOutlets
    //===========================

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var helpBtn: UIButton!
    @IBOutlet weak var saveAndContinueBtn: AppButton!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var mainCollView: UICollectionView!
    @IBOutlet weak var collViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var customView : CustomTextView!
    @IBOutlet weak var customCollViewHeightConstraint: NSLayoutConstraint!
  
    // MARK: - Variables
    //===========================
    var selectedFacilitiesArr : [FacilityModel] = []
    var serviceImagesArray = [String]()
    var imagesArray : [ImageModel] = []
    var selectBrandAndServiceArr : [String] = []
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        if !selectBrandAndServiceArr.isEmpty {
            if let customView = self.customView {
                customCollViewHeightConstraint.constant = customView.collView.contentSize.height + 38.0
            }
        }else{
                customCollViewHeightConstraint.constant = 60.0
        }
    }

    // MARK: - IBActions
    //===========================

    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }

    @IBAction func helpBtnAction(_ sender: UIButton) {
        showAlert(msg: LocalizedString.underDevelopment.localized)
    }
    
    @IBAction func saveAndContinueAction(_ sender: UIButton) {
        if selectBrandAndServiceArr.isEmpty {
            CommonFunctions.showToastWithMessage(LocalizedString.pleaseSelectServices.localized)
            return
        }
        if GarageProfileModel.shared.serviceCenterImages.isEmpty {
            CommonFunctions.showToastWithMessage(LocalizedString.pleaseSelectServiceCenterImage.localized)
            return
        }
        AppRouter.goToAddAccountVC(vc: self, screenType: .garageProfile)
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
    @objc func addImageBtnTapped(_ sender: UIButton) {
       if !self.hasImageUploaded{
           self.showAlert(msg: LocalizedString.wait_Img_Upload.localized)
           return
       }
       self.captureImage(delegate: self)
    }
    
    func getBrandAndServiceName(data : [JSONDictionary])-> [String] {
        var arr : [String] = []
        data.forEach { (element) in
            selectedFacilitiesArr.append(FacilityModel(element))
            if let brands = JSON(element[ApiKey.brands]).array {
                let serviceName = JSON(element[ApiKey.serviceName]).stringValue ?? ""
                if brands.isEmpty {
                    arr.append(serviceName)
                }else {
                    brands.forEach { (brand) in
                        let brandName = JSON(brand[ApiKey.brandName]).stringValue ?? ""
                        let txt = brandName + " (\(serviceName))"
                        arr.append(txt)
                    }
                }
            }
        }
        return arr
    }
}

// MARK: - Extension For Functions
//===========================
extension GarageProfileStep2VC {

    private func initialSetup() {
        setupTextAndFont()
        setupCustomView()
        saveAndContinueBtn.isEnabled = true
        self.collViewSetUp()
        handleRangeSlider()
        setPreFilledData()
    }
    
    private func handleRangeSlider(){
//        rangeSlider.minLabelFont = AppFonts.NunitoSansSemiBold.withSize(12.0)
//        rangeSlider.maxLabelFont = AppFonts.NunitoSansSemiBold.withSize(12.0)
//        rangeSlider.handleImage = #imageLiteral(resourceName: "slider")
//        rangeSlider.delegate = self
//        rangeSlider.minValue = 500
//        rangeSlider.maxValue = 2500
//        rangeSlider.selectedMinimum = 500
//        rangeSlider.selectedMaximum = 800
//        rangeSlider.selectedHandleDiameterMultiplier = 1
//        let formatter = NumberFormatter()
//        formatter.positiveSuffix = "SAR"
//        rangeSlider.numberFormatterOverride = formatter
    }
    
    
    private func setupTextAndFont(){
//        serviceCenterNameLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        headingLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        helpBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(17.0)
        saveAndContinueBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)

//        serviceCenterNameLbl.text = LocalizedString.installationPriceRange.localized
        titleLbl.text = fromGarage == .editGarageProfile ? "Edit Profile" : LocalizedString.completeProfile.localized
        headingLbl.text = LocalizedString.serviceCenterImage.localized
        helpBtn.setTitle(LocalizedString.help.localized, for: .normal)
        saveAndContinueBtn.setTitle(LocalizedString.saveContinue.localized, for: .normal)

    }

    private func setupCustomView(){
        customView.placeHolderTxt = LocalizedString.selectServiceCenterFacility.localized
        customView.floatLbl.text = LocalizedString.serviceCenterFacility.localized
        customView.leftImgContainerView.isHidden = true
        customView.rightImgView.image = #imageLiteral(resourceName: "group3689")
        customView.delegate = self
        customView.txtViewEditable = false
        customView.collView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()

        customView.collView.registerCell(with: FacilityCollectionViewCell.self)
        customView.collView.delegate = self
        customView.collView.dataSource = self
    }
    
    private func collViewSetUp(){
        mainCollView.dataSource = self
        mainCollView.delegate = self
        mainCollView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        mainCollView.registerCell(with: AddImageCollCell.self)
        mainCollView.isScrollEnabled = false
    }
    
    private func setPreFilledData(){
        mainCollView.dataSource = self
        imagesArray = GarageProfileModel.shared.serviceCenterImages
        if !GarageProfileModel.shared.services.isEmpty {
            selectBrandAndServiceArr = getBrandAndServiceName(data: GarageProfileModel.shared.services)
            customView.collView.isHidden = selectBrandAndServiceArr.isEmpty
            customView.floatLbl.isHidden = selectBrandAndServiceArr.isEmpty
            view.layoutIfNeeded()
            view.setNeedsLayout()
            mainCollView.reloadData()
        }
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
}

extension GarageProfileStep2VC: CustomTextViewDelegate{
    func shouldBegin(_ tView: UITextView) {
        AppRouter.goToFacilityVC(vc: self,data : [], brandAndServiceArr: [])
    }
    
    func collViewTapped(listingType: ListingType) {
        AppRouter.goToFacilityVC(vc: self,data : selectedFacilitiesArr, brandAndServiceArr: selectBrandAndServiceArr)
    }
}

extension GarageProfileStep2VC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == customView.collView {
            return selectBrandAndServiceArr.count

        }else {
            let imagesArray = GarageProfileModel.shared.serviceCenterImages
            if !imagesArray.isEmpty && imagesArray.count <= 4{
                return imagesArray.count + 1
            }else if imagesArray.count == 5{
                return imagesArray.count
            }else{
                return 1
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == customView.collView {
            let cell = collectionView.dequeueCell(with: FacilityCollectionViewCell.self, indexPath: indexPath)
            cell.skillLbl.text = selectBrandAndServiceArr[indexPath.item]
            cell.cancelBtn.addTarget(self, action: #selector(cancelBtnTapped(_:)), for: .touchUpInside)
            cell.layoutSubviews()
            return cell
                   
        }else {
            let imagesArray = GarageProfileModel.shared.serviceCenterImages
            let imageCell = collectionView.dequeueCell(with: AddImageCollCell.self, indexPath: indexPath)
                   imageCell.crossBtn.addTarget(self, action: #selector(crossImageBtnTapped(_:)), for: .touchUpInside)
            
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
                    
                    imageCell.addImgBtn.addTarget(self, action: #selector(addImageBtnTapped(_:)), for: .touchUpInside)

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
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == customView.collView {
            return cardSizeForItemAt(collectionView,layout: collectionViewLayout,indexPath: indexPath)

        }else {
            return CGSize(width: (self.mainCollView.frame.width / 3) - 5, height: 80.0)
        }
    }
    
    private func cardSizeForItemAt(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        
        let textSize = selectBrandAndServiceArr[indexPath.item].sizeCount(withFont: AppFonts.NunitoSansSemiBold.withSize(12.0), boundingSize: CGSize(width: 10000.0, height: collectionView.frame.height))
        
        return CGSize(width: textSize.width + 34, height: 24.0)
    }

    @objc func cancelBtnTapped(_ sender : UIButton) {
        if let indexPath = self.customView.collView.indexPath(forItem: sender) {
            printDebug(indexPath)
            updateSelectedModel(index: indexPath.item)
            selectBrandAndServiceArr.remove(at: indexPath.item)
            if selectBrandAndServiceArr.isEmpty {
                customView.collView.isHidden = true
                customView.floatLbl.isHidden = true
            }
            customView.collView.reloadData()
            view.layoutIfNeeded()
            view.setNeedsLayout()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

//extension GarageProfileStep2VC : TTRangeSliderDelegate{
//    func didEndTouches(in sender: TTRangeSlider!) {
//        GarageProfileModel.shared.maxInstallationPrice = Int(sender.selectedMaximum.rounded())
//        GarageProfileModel.shared.minInstallationPrice = Int(sender.selectedMinimum.rounded())
//        printDebug(sender.selectedMinimum.rounded())
//        printDebug(sender.selectedMaximum.rounded())
//    }
//}

// MARK: - UIImagePickerControllerDelegate
//===========================
extension GarageProfileStep2VC: UIImagePickerControllerDelegate, UINavigationControllerDelegate , RemovePictureDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        hasImageUploaded = false
        GarageProfileModel.shared.serviceCenterImages.append(ImageModel(url: "", type: "image", image: image ?? UIImage()))
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
                self.showAlert(msg: LocalizedString.imageUploadingFailed.localized)
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


extension GarageProfileStep2VC: FacilitiesDelegate {
    func setData(dataArr: [FacilityModel], brandAndServiceArr: [String]) {
        selectedFacilitiesArr = dataArr
        selectBrandAndServiceArr = brandAndServiceArr
        customView.collView.isHidden = selectedFacilitiesArr.isEmpty
        customView.floatLbl.isHidden = selectedFacilitiesArr.isEmpty
        customView.collView.reloadData()
        view.layoutIfNeeded()
        view.setNeedsLayout()
        GarageProfileModel.shared.services.removeAll()
        selectedFacilitiesArr.forEach { (model) in
            GarageProfileModel.shared.services.append(model.getSelectedService())
        }
    }
    
    func updateSelectedModel(index: Int) {
        let arr = selectBrandAndServiceArr[index].split(separator: "(")
        if arr.count == 2 {
            var serviceName = arr[1]
            serviceName.removeLast()
            var brandName = arr[0]
            brandName.removeLast()

            for (indexx,item) in selectedFacilitiesArr.enumerated() {
                if item.name == serviceName {
                    if let firstIndex = item.subCategory.firstIndex(where: { (model) -> Bool in
                        return model.name == brandName
                    }) {
                        selectedFacilitiesArr[indexx].subCategory[firstIndex].isSelected = false
                    }
                    if let _ = item.subCategory.firstIndex(where: { (model) -> Bool in
                        return model.isSelected
                    }){
                        
                    }else {
                        selectedFacilitiesArr.remove(at: indexx)
                    }
                    break
                }
            }
        }else {
            if let firstIndex = selectedFacilitiesArr.firstIndex(where: { (model) -> Bool in
                return model.name == selectBrandAndServiceArr[index]
            }){
                selectedFacilitiesArr.remove(at: firstIndex)

            }
        }
    }
}
