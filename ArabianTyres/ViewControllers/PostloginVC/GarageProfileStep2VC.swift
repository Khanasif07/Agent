//
//  GarageProfileStep2.swift
//  ArabianTyres
//
//  Created by Arvind on 15/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class GarageProfileStep2VC: BaseVC {

    // MARK: - IBOutlets
    //===========================

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var helpBtn: UIButton!
    @IBOutlet weak var saveAndContinueBtn: AppButton!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var customView : CustomTextView!
    @IBOutlet weak var customCollViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Variables
    //===========================
    var selectedSkillArr : [String] = []

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
        if !selectedSkillArr.isEmpty {
            if let customView = self.customView {
                customCollViewHeightConstraint.constant = customView.collView.contentSize.height + 38.0
            }
        }
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
    }


}

// MARK: - Extension For Functions
//===========================
extension GarageProfileStep2VC {

    private func initialSetup() {
        setupTextAndFont()
        setupCustomView()
        saveAndContinueBtn.isEnabled = false
    }

    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        headingLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        helpBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(17.0)
        saveAndContinueBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)

        titleLbl.text = LocalizedString.completeProfile.localized
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

        customView.collView.registerCell(with: FacilityCollectionViewCell.self)
        customView.collView.delegate = self
        customView.collView.dataSource = self
    }
}

extension GarageProfileStep2VC: CustomTextViewDelegate{
    func shouldBegin(_ tView: UITextView) {
        printDebug("should begin tapped")

    }
    
    func collViewTapped() {
        printDebug("collection view tapped")
    }
}


extension GarageProfileStep2VC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedSkillArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: FacilityCollectionViewCell.self, indexPath: indexPath)
        cell.skillLbl.text = selectedSkillArr[indexPath.item]
        cell.cancelBtn.addTarget(self, action: #selector(cancelBtnTapped(_:)), for: .touchUpInside)
        cell.layoutSubviews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cardSizeForItemAt(collectionView,layout: collectionViewLayout,indexPath: indexPath)
    }
    
    private func cardSizeForItemAt(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        let textSize = selectedSkillArr[indexPath.row].sizeCount(withFont: AppFonts.NunitoSansSemiBold.withSize(16.0), boundingSize: CGSize(width: 10000.0, height: collectionView.frame.height))
        
        return CGSize(width: textSize.width + 30, height: 24.0)
    }

    @objc func cancelBtnTapped(_ sender : UIButton) {
        if let indexPath = self.customView.collView.indexPath(forItem: sender) {
            printDebug(indexPath)
            selectedSkillArr.remove(at: indexPath.item)
            if selectedSkillArr.isEmpty {
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
