//
//  TyreBrandVC.swift
//  ArabianTyres
//
//  Created by Arvind on 17/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField


class TyreBrandVC: BaseVC {
   

    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var thePreferredLbl: UILabel!
    @IBOutlet weak var setYourPrefernceLbl: UILabel!
    @IBOutlet weak var submitBtn: AppButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tyreBrandCustomView: CustomTextView!
    @IBOutlet weak var countryOriginCustomView: CustomTextView!
    @IBOutlet weak var tBCustomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var countryOriginViewHeightConstraint: NSLayoutConstraint!

    
    
    // MARK: - Variables
    //===========================

    var placeHolderArr : [String] = [LocalizedString.enterVehicleMake.localized,
     LocalizedString.enterVehicleModel.localized,
     LocalizedString.enterModelYear.localized
    ]
   
    var titleArr : [String] = [LocalizedString.vehicleMake.localized,
                                 LocalizedString.vehicleModel.localized,
                                 LocalizedString.modelYear.localized
                                ]
    var brandListingArr :[String] = []
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        if !brandListingArr.isEmpty {
            if let tyreBrandCustomView = self.tyreBrandCustomView {
                tBCustomViewHeightConstraint.constant = tyreBrandCustomView.collView.contentSize.height + 38.0
            }
        }
    }
    // MARK: - IBActions
    //===========================
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        
    }
    
    @IBAction func submitBtnAction(_ sender: UIButton) {

    }
   
}

// MARK: - Extension For Functions
//===========================
extension TyreBrandVC {
    
    private func initialSetup() {
        setupTextFont()
        setupCustomView()
        countryOriginViewHeightConstraint.constant = 0.0
    }
    
    private func setupTextFont() {
        thePreferredLbl.text = LocalizedString.thePreferredOriginForMytyreWouldBe.localized
        setYourPrefernceLbl.text = LocalizedString.setYourPreferencesAmongTyreBrandOrCountryOrigin.localized
        submitBtn.setTitle(LocalizedString.submit.localized, for: .normal)

        thePreferredLbl.font = AppFonts.NunitoSansBold.withSize(21.0)
        setYourPrefernceLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        submitBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        
    }
    
    private func setupCustomView() {
        countryOriginCustomView.delegate = self
        tyreBrandCustomView.delegate = self
        tyreBrandCustomView.leftImgContainerView.isHidden = true
        countryOriginCustomView.leftImgContainerView.isHidden = true
        tyreBrandCustomView.txtViewEditable = false
        countryOriginCustomView.txtViewEditable = false
        tyreBrandCustomView.collView.registerCell(with: FacilityCollectionViewCell.self)
        tyreBrandCustomView.collView.delegate = self
        tyreBrandCustomView.collView.dataSource = self
    }
    
}

extension TyreBrandVC :UITextFieldDelegate {
    
}


//MARK:-CollectionView Delegate and DataSource
extension TyreBrandVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandListingArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: FacilityCollectionViewCell.self, indexPath: indexPath)
        cell.skillLbl.text = brandListingArr[indexPath.item]
        cell.cancelBtn.addTarget(self, action: #selector(cancelBtnTapped(_:)), for: .touchUpInside)
        cell.layoutSubviews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cardSizeForItemAt(collectionView,layout: collectionViewLayout,indexPath: indexPath)
    }
    
    private func cardSizeForItemAt(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        let textSize = brandListingArr[indexPath.row].sizeCount(withFont: AppFonts.NunitoSansSemiBold.withSize(12.0), boundingSize: CGSize(width: 10000.0, height: collectionView.frame.height))
        
        return CGSize(width: textSize.width + 60, height: 22.0)
    }

    @objc func cancelBtnTapped(_ sender : UIButton) {
        if let indexPath = self.tyreBrandCustomView.collView.indexPath(forItem: sender) {
            printDebug(indexPath)
            brandListingArr.remove(at: indexPath.item)
//            ProfileStepModel.shared.skills = selectedSkillArr
            if brandListingArr.isEmpty {
                tyreBrandCustomView.collView.isHidden = true
                tyreBrandCustomView.floatLbl.isHidden = true
            }
            tyreBrandCustomView.collView.reloadData()
            view.layoutIfNeeded()
            view.setNeedsLayout()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

extension TyreBrandVC : CustomTextViewDelegate{
    func shouldBegin(_ tView: UITextView) {
        switch tView {
       
        case tyreBrandCustomView.tView:
            AppRouter.goToBrandsListingVC(vc: self)
            
        case countryOriginCustomView.tView:
            break
            
        default:
            break
        }
    }
}

extension TyreBrandVC: BrandsListnig {
    func listing(_ data: [String]) {
        brandListingArr = data
        tyreBrandCustomView.collView.isHidden = brandListingArr.isEmpty
        tyreBrandCustomView.collView.reloadData()
    }

}
