//
//  GarageServiceCountryCell.swift
//  ArabianTyres
//
//  Created by Admin on 07/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class GarageServiceCountryCell: UITableViewCell {
    
    
    var countryNameArr : [PreferredBrand] = []{
        didSet{
            countryCollView.reloadData()
        }
    }
    var countryBtnTapped : ((String)->())?
    var indexPath: IndexPath?
    
    
    @IBOutlet weak var countryCollView: UICollectionView!
    @IBOutlet weak var titleLbl: UILabel!
    
     override func awakeFromNib() {
           super.awakeFromNib()
           countryCollView.registerCell(with: FacilityCollectionViewCell.self)
           countryCollView.delegate = self
           countryCollView.dataSource = self
       }
}


extension GarageServiceCountryCell : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countryNameArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: FacilityCollectionViewCell.self, indexPath: indexPath)
        cell.cancelBtn.isHidden = true
        cell.cancelBtnHeightConstraint.constant = 0.0
        cell.skillLbl.contentMode = .center
        cell.skillLbl.text = self.countryNameArr[indexPath.item].name
        cell.containerView.backgroundColor = self.indexPath == indexPath ? AppColors.appRedColor : .white
        cell.skillLbl.textColor = self.indexPath == indexPath ? .white : AppColors.fontTertiaryColor
        cell.layoutSubviews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = self.countryNameArr[indexPath.item].name
        let textSize = text.sizeCount(withFont: AppFonts.NunitoSansSemiBold.withSize(14.0), boundingSize: CGSize(width: 10000.0, height: 36.0))
        return CGSize(width: textSize.width + 20, height: 36.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexPath = indexPath
        collectionView.reloadData()
        countryBtnTapped?(self.countryNameArr[indexPath.item].name)
    }
}
