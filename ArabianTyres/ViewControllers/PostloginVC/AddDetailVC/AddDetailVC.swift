//
//  AddDetailVC.swift
//  ArabianTyres
//
//  Created by Arvind on 10/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class AddDetailVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var helpBtn: UIButton!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var garageDetailLbl: UILabel!
    @IBOutlet weak var addLogoLbl: UILabel!
    @IBOutlet weak var saveAndContinueBtn: AppButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var editLogoBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var customTView: CustomTextView!
    @IBOutlet weak var tViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    //===========================
    var viewModel = GarageRegistrationVM()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        let height = customTView.tView.text.heightOfText(self.customTView.tView.width + 36, font: AppFonts.NunitoSansBold.withSize(16.0))
        printDebug(height)
        tViewHeightConstraint.constant = height + 32
        self.view.layoutIfNeeded()
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func helpBtnAction(_ sender: UIButton) {
//        self.pop()
    }
    
    @IBAction func saveAndContinueAction(_ sender: UIButton) {
       if GarageProfileModel.shared.logoUrl.isEmpty {
        CommonFunctions.showToastWithMessage(LocalizedString.uploadGarageLogo.localized)
        }
       else {
        AppRouter.goToGarageAddLocationVC(vc: self)
        }
    }
    
    @IBAction func editLogoBtnAction(_ sender: UIButton) {
        self.captureImage(delegate: self)
    }
    
}

// MARK: - Extension For Functions
//===========================
extension AddDetailVC {
    
    private func initialSetup() {
        editLogoBtn.setImage(nil, for: .normal)
        setupTextAndFont()
        customTView.delegate = self
        customTView.charLimit = 40
        customTView.placeHolderTxt = LocalizedString.enterServiceCenterName.localized
        customTView.floatLbl.text = LocalizedString.serviceCenterNames.localized
        customTView.rightImgContainerView.isHidden = true
        customTView.leftImgContainerView.isHidden = true
        saveAndContinueBtn.isEnabled = false
    }
  
    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        helpBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(17.0)
        headingLbl.font =  AppFonts.NunitoSansBold.withSize(21.0)
        garageDetailLbl.font =  AppFonts.NunitoSansBold.withSize(14.0)
        addLogoLbl.font =  AppFonts.NunitoSansSemiBold.withSize(12.0)
        saveAndContinueBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)

        
        titleLbl.text = LocalizedString.addDetails.localized
        helpBtn.setTitle(LocalizedString.help.localized, for: .normal)
        headingLbl.text = LocalizedString.thisAllAboutMyServiceCenter.localized
        garageDetailLbl.text = LocalizedString.addFollowingGarageDetails.localized
        addLogoLbl.text = LocalizedString.addLogo.localized
        saveAndContinueBtn.setTitle(LocalizedString.saveContinue.localized, for: .normal)

    }
    
}

extension AddDetailVC : CustomTextViewDelegate {
    
    func shouldBegin(_ tView: UITextView) {
        tView.textColor = AppColors.fontPrimaryColor
        customTView.floatLbl.isHidden = false
        if tView.text == LocalizedString.enterServiceCenterName.localized {
            tView.text = ""
        }
    }
    
    func endEditing(_ tView : UITextView) {
        if tView.text == ""{
            customTView.floatLbl.isHidden = true
            customTView.placeHolderTxt = LocalizedString.enterServiceCenterName.localized
            customTView.floatLbl.text = LocalizedString.serviceCenterNames.localized
        }
    }
    
    func textViewValueUpdated(_ tView : UITextView){
        if tView.text.count >= 3 {
            GarageProfileModel.shared.serviceCenterName = tView.text
            saveAndContinueBtn.isEnabled = true
        }
        else {
            saveAndContinueBtn.isEnabled = false
        }
    }
}

 extension AddDetailVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, RemovePictureDelegate {
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        CommonFunctions.showActivityLoader()
         editLogoBtn.setImage(#imageLiteral(resourceName: "vector"), for: .normal)
         imgView.contentMode = .scaleToFill
         imgView.image = image
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
        imgView.image = #imageLiteral(resourceName: "icImg")
        imgView.contentMode = .center
        editLogoBtn.setImage(nil, for: .normal)
    }
}
