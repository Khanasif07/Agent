//
//  FilterTableViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 06/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

class FilterTableViewCell: UITableViewCell {
    
    //MARK:- IBOutlets

    @IBOutlet weak var addImgView : UIImageView!
    @IBOutlet weak var categoryLbl : UILabel!
    @IBOutlet weak var cellBtn : UIButton!
    @IBOutlet weak var bottomView : UIView!
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var collView : UICollectionView!

    var cellBtnTapped : (()->())?
    var subCatName = ["Tyre Service","Oil Sevice", "Battery Service"]
    var subCatArr :[SubCatModel] = []
    
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollView()
        categoryLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
    
    @IBAction func cellBtnAction(_ sender: UIButton) {
        cellBtn.isSelected.toggle()
        addImgView.isHighlighted.toggle()
        cellBtnTapped?()
    }
    
    private func setupCollView() {
        collView.delegate = self
        collView.dataSource = self
        collView.registerCell(with: FilterCollectionViewCell.self)
    }

}
//MARK:- Collection View Delegate and DataSource
extension FilterTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subCatArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: FilterCollectionViewCell.self, indexPath: indexPath)
        cell.subCategoryName.text = subCatArr[indexPath.item].name
        cell.lineView.isHidden = subCatArr.endIndex - 1 == indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width - 32, height: 54)
    }
}
