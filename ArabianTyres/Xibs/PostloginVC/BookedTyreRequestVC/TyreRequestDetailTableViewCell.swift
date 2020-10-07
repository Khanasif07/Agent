//
//  TyreRequestDetailTableViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 06/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//
enum CellType : CaseIterable{
  
    case created
    case accepted
    case payAmount
    case none
    case serviceDetail
    
    var text: String {
        switch self {
            
        case .created:
            return LocalizedString.requestCreatedBy.localized
        case .accepted:
            return LocalizedString.requestAcceptedOn.localized
        case .payAmount:
            return LocalizedString.paybleAmount.localized
        case .serviceDetail:
            return LocalizedString.serviceDetails.localized
            
        default:
            return ""
        }
    }
    
    var image: UIImage? {
        switch self {
            
        case .created:
            return #imageLiteral(resourceName: "profileSelected")
        case .accepted:
            return  #imageLiteral(resourceName: "subtract")
        case .payAmount:
            return  #imageLiteral(resourceName: "icAtm")
        default :
            return nil
        }
    }
}

import UIKit

class TyreRequestDetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var collView: ASDynamicCollectionView!
    @IBOutlet weak var containerView: UIView!
    
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
        return CellType.allCases.endIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch CellType.allCases[indexPath.item] {
            
        case .none:
            let cell = collectionView.dequeueCell(with: DashedCollectionViewCell.self, indexPath: indexPath)
            return cell
        case .serviceDetail:
            let cell = collectionView.dequeueCell(with: ServiceDetailCollectionViewCell.self, indexPath: indexPath)
            return cell
        default:
            let cell = collectionView.dequeueCell(with: RequestDetailCollectionViewCell.self, indexPath: indexPath)
            cell.bindCell(CellType.allCases[indexPath.item])
            cell.bottomView.isHidden = CellType.allCases[indexPath.item] == .payAmount
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch CellType.allCases[indexPath.item] {
        case .none:
            return CGSize(width: self.frame.width - 32, height: 25)
            default:
            return CGSize(width: self.frame.width - 32, height: 84)

        }
    }
}
