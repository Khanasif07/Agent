//
//  RatingVC.swift
//  ArabianTyres
//
//  Created by Arvind on 09/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class RatingVC: BaseVC {
 
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var overAllExpLbl: UILabel!
    @IBOutlet weak var garageNameLbl: UILabel!
    @IBOutlet weak var rateOutOfFiveLbl: UILabel!
    @IBOutlet weak var descWhyLbl: UILabel!
    @IBOutlet weak var uploadAnyPicLbl: UILabel!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var saveBtn: AppButton!
    @IBOutlet weak var editLogoBtn: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var dashedView: RectangularDashedView!
    @IBOutlet weak var containerView: UIView!

    @IBOutlet var starBtns: [UIButton]!
    
    
    // MARK: - Variables
    //===========================
    
    
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
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func cancelBtnAction(_ sender: Any) {
        pop()
    }
    
    @IBAction func saveBtnBtnAction(_ sender: Any) {
        pop()
    }
    
    @IBAction func editLogoBtnAction(_ sender: UIButton) {
        self.captureImage(delegate: self)
    }
    
    @IBAction func starBtnsTapped(_ sender: UIButton) {
        for i in 0...starBtns.count - 1{
            if i <= sender.tag {
                starBtns[i].isSelected = true

            }else {
                starBtns[i].isSelected = false
            }
        }
        printDebug(sender.tag)
    }
}

// MARK: - Extension For Functions
//===========================
extension RatingVC {
    
    private func initialSetup() {
        editLogoBtn.setImage(nil, for: .normal)
        setupTextAndFont()
        setupTextView()
        saveBtn.isEnabled = false
    }

    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        overAllExpLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        rateOutOfFiveLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        descWhyLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        uploadAnyPicLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        garageNameLbl.font = AppFonts.NunitoSansBold.withSize(21.0)

        titleLbl.text = LocalizedString.rateService.localized
        overAllExpLbl.text = LocalizedString.howWasOverAllExp.localized
        rateOutOfFiveLbl.text = LocalizedString.rateOutOfFive.localized
        descWhyLbl.text = LocalizedString.describeWhy.localized
        uploadAnyPicLbl.text = LocalizedString.uploadAnyPictureOfYourExperience.localized
        overAllExpLbl.text = LocalizedString.filters.localized

        
    }
    
    private func setupTextView(){
        txtView.delegate = self
        txtView.text = LocalizedString.typeHere.localized
    }

    
}

extension RatingVC : UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == LocalizedString.typeHere.localized {
            textView.text = ""
            textView.textColor = AppColors.fontPrimaryColor
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = AppColors.fontSecondaryColor
            textView.text = LocalizedString.typeHere.localized
            
        }
    }
}


 extension RatingVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, RemovePictureDelegate {
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        dashedView.isHidden = true
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