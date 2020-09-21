//
//  TyreRequestedVC.swift
//  ArabianTyres
//
//  Created by Arvind on 21/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation


import UIKit

class TyreRequestedVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var sizeOfTyreLbl: UILabel!
    @IBOutlet weak var originOfTyreLbl: UILabel!
    @IBOutlet weak var tyreBrandLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!

    @IBOutlet weak var tyreWidthLbl: UILabel!
    @IBOutlet weak var tyreProfileLbl: UILabel!
    @IBOutlet weak var tyreRimSizeLbl: UILabel!

    @IBOutlet weak var tyreWidthValueLbl: UILabel!
    @IBOutlet weak var tyreProfileValueLbl: UILabel!
    @IBOutlet weak var tyreRimSizeValueLbl: UILabel!
    @IBOutlet weak var tyreBrandCollView: UICollectionView!
    @IBOutlet weak var countryCollView: UICollectionView!
    @IBOutlet weak var tyreBrandCollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var countryCollViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var requestBtn: AppButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var editLogoBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var customTView: CustomTextView!
    @IBOutlet weak var tViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    //===========================
    var viewModel = GarageRegistrationVM()
    var dataArr = ["MRF", "Bridgestone", "Apollo", "United Kingdom","United Kingdom"]
    
    
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
        if !self.dataArr.isEmpty {
            self.tyreBrandCollViewHeightConstraint.constant = tyreBrandCollView.contentSize.height + 38.0
            
        }else {
            self.tyreBrandCollViewHeightConstraint.constant = 45.0
        }
        
        if !self.dataArr.isEmpty {
            self.countryCollViewHeightConstraint.constant = countryCollView.contentSize.height + 38.0
        }else {
            self.countryCollViewHeightConstraint.constant = 45.0
        }
        
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func requestBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    
    @IBAction func editLogoBtnAction(_ sender: UIButton) {
    
    }
    
}

// MARK: - Extension For Functions
//===========================
extension TyreRequestedVC {
    
    private func initialSetup() {
        setupTextAndFont()
        setupCollectionView()
    }
  
    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(21.0)
        sizeOfTyreLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        titleLbl.text = LocalizedString.addDetails.localized
    }
    
    private func setupCollectionView(){
        tyreBrandCollView.delegate = self
        countryCollView.delegate = self
        tyreBrandCollView.dataSource = self
        countryCollView.dataSource = self
        tyreBrandCollView.isScrollEnabled = false
        countryCollView.isScrollEnabled = false
        tyreBrandCollView.registerCell(with: FacilityCollectionViewCell.self)
        countryCollView.registerCell(with: FacilityCollectionViewCell.self)

    }

}

extension TyreRequestedVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueCell(with: FacilityCollectionViewCell.self, indexPath: indexPath)
           cell.cancelBtn.isHidden = true
           cell.cancelBtnHeightConstraint.constant = 0.0
           cell.skillLbl.contentMode = .center
           cell.skillLbl.text = dataArr[indexPath.item]
           cell.layoutSubviews()
           return cell
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return cardSizeForItemAt(collectionView,layout: collectionViewLayout,indexPath: indexPath)
       }
       
       private func cardSizeForItemAt(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
//           let arr = tyreBrandCustomView.collView == collectionView ? brandListingArr : countryListingArr
           let textSize = dataArr[indexPath.row].sizeCount(withFont: AppFonts.NunitoSansSemiBold.withSize(13.0), boundingSize: CGSize(width: 10000.0, height: collectionView.frame.height))
           
        return CGSize(width: textSize.width + 16, height: 34.0)
       }
    
}
