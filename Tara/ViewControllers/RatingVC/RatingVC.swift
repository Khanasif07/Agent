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
    //==================
    @IBOutlet weak var txtViewCountLbl: UILabel!
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
    //==================
    let viewModel = RatingVM()
    var rating : String = ""
    var images : [String] = []
    var requestId : String = ""
    var ratingId : String = ""
    var garageName : String = ""
    var delegate : PickerDataDelegate?

    // MARK: - Lifecycle
    //==================
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
        if self.ratingId.isEmpty{
            viewModel.postRatingData(params: getDict(), loader: true)
        } else{
            viewModel.updateRatingData(params: getDictForUpdate(), loader: true)
        }
    }
    
    @IBAction func editLogoBtnAction(_ sender: UIButton) {
        self.captureImage(delegate: self,removedImagePicture: true)
    }
    
    @IBAction func starBtnsTapped(_ sender: UIButton) {
        for i in 0...starBtns.count - 1{
            if i <= sender.tag {
                starBtns[i].isSelected = true
                rating = (i+1).description
            }else {
                starBtns[i].isSelected = false
            }
        }
        printDebug(sender.tag)
        saveBtn.isEnabled = saveBtnStatus()
    }
}

// MARK: - Extension For Functions
//===========================
extension RatingVC {
    
    private func initialSetup() {
        editLogoBtn.setImage(nil, for: .normal)
        saveBtn.isEnabled = false
        viewModel.delegate = self
        setupTextAndFont()
        setupTextView()
        prefilledData()
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
        garageNameLbl.text = garageName + " Garage?"
        
    }
    
    private func prefilledData(){
        if !(viewModel.ratingModel?.images?.isEmpty ?? true) {
            imgView.contentMode = .scaleToFill
            dashedView.isHidden = true
            imgView.setImage_kf(imageString: viewModel.ratingModel?.images?.first ?? "", placeHolderImage: #imageLiteral(resourceName: "icImg"), loader: true)

        }else {
            imgView.contentMode = .center
            dashedView.isHidden = false
        }
        self.txtView.text = viewModel.ratingModel?.review ?? ""
        txtViewCountLbl.text = "\(viewModel.ratingModel?.review?.count ?? 0)" + "/250"
        
        for i in 0...starBtns.count - 1{
            if  i < (viewModel.ratingModel?.rating ??  0) {
                starBtns[i].isSelected = true
                rating = (i+1).description
            }
        }
        saveBtn.setTitle(self.ratingId.isEmpty ? "Save" : "Update", for: .normal)
        saveBtn.isEnabled = saveBtnStatus()
        txtView.textColor = AppColors.fontPrimaryColor
    }
    
    private func setupTextView(){
        txtView.delegate = self
        txtView.text = LocalizedString.typeHere.localized
    }
    
    private func getDict() -> JSONDictionary{
        let dict : JSONDictionary = [ApiKey.requestId : self.requestId ,
                                     ApiKey.rating : self.rating,
                                     ApiKey.review: txtView.text.byRemovingLeadingSpaces,
                                     ApiKey.images : self.images]
        return dict
    }
    
    private func getDictForUpdate() -> JSONDictionary{
        let dict : JSONDictionary = [ApiKey.ratingId : self.ratingId ,
                                     ApiKey.rating : self.rating,
                                     ApiKey.review: txtView.text.byRemovingLeadingSpaces,
                                     ApiKey.images : self.images]
        return dict
    }
    
    func saveBtnStatus() -> Bool{
        return !rating.isEmpty && !txtView.text.isEmpty && !(txtView.text == LocalizedString.typeHere.localized) //&& !images.isEmpty
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
        saveBtn.isEnabled = saveBtnStatus()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        txtViewCountLbl.text = "\(newText.count)" + "/250"
        return text.checkIfValidCharaters(.name) && newText.count < 250
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
                self.images.append(url)
                self.saveBtn.isEnabled = self.saveBtnStatus()
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
        dashedView.isHidden = false
        imgView.image = #imageLiteral(resourceName: "icImg")
        imgView.contentMode = .center
        editLogoBtn.setImage(nil, for: .normal)
    }
}

extension RatingVC : RatingVMDelegate{
    
    func ratingSuccess(msg: String) {
        self.delegate?.updateRatingStatus()
        self.delegate?.changeCarReceivedStatus()
        pop()
    }
    
    func updateRatingSuccess(msg: String) {
        self.delegate?.updateRatingStatus()
        pop()
    }
    
    func ratingFailed(msg: String) {
        CommonFunctions.showToastWithMessage(msg)
    }
}
