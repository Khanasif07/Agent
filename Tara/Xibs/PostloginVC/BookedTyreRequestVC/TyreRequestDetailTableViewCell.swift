//
//  TyreRequestDetailTableViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 06/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TyreRequestDetailTableViewCell: UITableViewCell {
    
    //MARK:-IBOutlets
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    //MARK:-Variables
    var sectionArr : [CellType] = []
   
    //MARK:-LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollView()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
    
    private func setupCollView() {
        collView.delegate = self
        collView.dataSource = self
        collView.registerCell(with: ServiceDetailCollectionViewCell.self)
        collView.registerCell(with: RequestDetailCollectionViewCell.self)
        collView.registerCell(with: DashedCollectionViewCell.self)
        
    }
}


//MARK:- Collection View Delegate and DataSource
extension TyreRequestDetailTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionArr.endIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sectionArr[indexPath.item] {
            
        case .none:
            let cell = collectionView.dequeueCell(with: DashedCollectionViewCell.self, indexPath: indexPath)
            return cell
        case .serviceDetail:
            let cell = collectionView.dequeueCell(with: ServiceDetailCollectionViewCell.self, indexPath: indexPath)
            return cell
        default:
            let cell = collectionView.dequeueCell(with: RequestDetailCollectionViewCell.self, indexPath: indexPath)
            cell.bindCell(sectionArr[indexPath.item])
            cell.bottomView.isHidden = sectionArr[indexPath.item] == .payAmount || sectionArr[indexPath.item] == .userDetail
            cell.helpBtn.isHidden = sectionArr[indexPath.item] != .userDetail 
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sectionArr[indexPath.item] {
        case .none:
            return CGSize(width: self.frame.width - 32, height: 25)
            default:
            return CGSize(width: self.frame.width - 32, height: 84)

        }
    }
}
