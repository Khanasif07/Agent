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
    @IBOutlet weak var saveAndContinueBtn: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var editLogoBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var customTView: CustomTextView!
    @IBOutlet weak var tViewHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Variables
    //===========================
   
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        let height = customTView.tView.text.heightOfText(self.customTView.tView.width, font: AppFonts.NunitoSansBold.withSize(16.0))
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
        self.pop()
    }
    
    @IBAction func saveAndContinueAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func editLogoBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    func changeBtnState(isHide: Bool){
        saveAndContinueBtn.backgroundColor = isHide ? AppColors.primaryBlueLightShade : AppColors.primaryBlueColor
        saveAndContinueBtn.setTitleColor(isHide ? AppColors.fontTertiaryColor : AppColors.backgrougnColor2, for: .normal)
        saveAndContinueBtn.isUserInteractionEnabled = !isHide
    }
}

// MARK: - Extension For Functions
//===========================
extension AddDetailVC {
    
    private func initialSetup() {
        self.tableViewSetUp()
        setupTextAndFont()
        customTView.delegate = self
        customTView.placeHolderTxt = LocalizedString.enterServiceCenterName.localized
        customTView.floatLbl.text = LocalizedString.serviceCenterName.localized
        customTView.rightImgContainerView.isHidden = true
        customTView.leftImgContainerView.isHidden = true
        changeBtnState(isHide: true)
    }
    
    private func tableViewSetUp(){
     
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
            customTView.floatLbl.text = LocalizedString.serviceCenterName.localized
        }
    }
    
    func textViewValueUpdated(_ tView : UITextView){
        if tView.text.count >= 3 {
            changeBtnState(isHide: false)
        }
        else {
            changeBtnState(isHide: true)
        }
    }
}
