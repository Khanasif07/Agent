//
//  OfferFilterTableViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 09/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class OfferFilterTableViewCell: UITableViewCell {
   
    //MARK:- IBOutlets
    @IBOutlet weak var addImgView : UIImageView!
    @IBOutlet weak var categoryLbl : UILabel!
    @IBOutlet weak var cellBtn : UIButton!
    @IBOutlet weak var bottomView : UIView!
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var collView : UICollectionView!
    
    //MARK:-Variables
    var cellBtnTapped : (()->())?
    var selectedDateData : ((Date,Date) -> ())?
    var selectedByStatusData : ((String) -> ())?
    var selectedDistance: ((String,String) -> ())?
    var sectionType: FilterScreen = .distance("","", false) {
        didSet {
            categoryLbl.text = sectionType.text
            addImgView.isHighlighted = sectionType.isHide
            collView.reloadData()
        }
    }
    
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
        cellBtnTapped?()
    }
    
    private func setupCollView() {
        collView.delegate = self
        collView.dataSource = self
        collView.registerCell(with: DistanceSliderCollViewCell.self)
        collView.registerCell(with: FilterCollectionViewCell.self)
        collView.registerCell(with: ByDateCollectionViewCell.self)

    }
}

//MARK:- Collection View Delegate and DataSource
extension OfferFilterTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionType.fliterTypeArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sectionType {
            
        case .date(let fromDate,let toDate,_):
            let cell = collectionView.dequeueCell(with: ByDateCollectionViewCell.self, indexPath: indexPath)
            if let fDate = fromDate, let tDate = toDate {
                cell.fromDate = fDate
                cell.toDate = tDate
            }else {
                cell.fromDate = nil
                cell.toDate = nil
            }
            
            cell.txtFieldData = {[weak self] (fromDate, toDate) in
                self?.selectedDateData?(fromDate, toDate)
            }
            return cell
            
        case .distance(let minValue,let maxValue,_):
            let cell = collectionView.dequeueCell(with: DistanceSliderCollViewCell.self, indexPath: indexPath)
           
            cell.rangeSlider.selectedMinimum = minValue.isEmpty ? 1 : (minValue as NSString).floatValue
            cell.rangeSlider.selectedMaximum = maxValue.isEmpty ? 5 : (maxValue as NSString).floatValue

            cell.sliderValueChanged = {[weak self] (sliderMinValue,sliderMaxValue )in
                self?.selectedDistance?(sliderMinValue, sliderMaxValue)
            }
           
            return cell
            
        case .byServiceType(let arr, _), .byStatus(let arr, _) :
            let cell = collectionView.dequeueCell(with: FilterCollectionViewCell.self, indexPath: indexPath)
            cell.subCategoryName.text = sectionType.fliterTypeArr[indexPath.item]
            cell.checkImgView.isHighlighted = arr.contains(sectionType.apiValue[indexPath.item])
            cell.lineView.isHidden = sectionType.fliterTypeArr.count - 1 == indexPath.item
            return cell
            
        case .allRequestByStatus(let arr, _), .allRequestServiceType(let arr, _) :
            let cell = collectionView.dequeueCell(with: FilterCollectionViewCell.self, indexPath: indexPath)
            cell.subCategoryName.text = sectionType.fliterTypeArr[indexPath.item]
            cell.checkImgView.isHighlighted = arr.contains(sectionType.apiValue[indexPath.item])
            cell.lineView.isHidden = sectionType.fliterTypeArr.count - 1 == indexPath.item
            return cell
            
        case .bidReceived(let txt, _):
            let cell = collectionView.dequeueCell(with: FilterCollectionViewCell.self, indexPath: indexPath)
            cell.setupForOfferFilter()
            cell.subCategoryName.text = sectionType.fliterTypeArr[indexPath.item]
            cell.checkImgView.isHighlighted = txt == sectionType.apiValue[indexPath.item]
            cell.lineView.isHidden = sectionType.fliterTypeArr.count - 1 == indexPath.item
            return cell
     
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sectionType {
            
        case .date(_,_,_), .distance(_,_,_):
            return CGSize(width: self.frame.width - 32, height: 100.0)
        default:
            return CGSize(width: self.frame.width - 32, height: 54)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = sectionType.apiValue[indexPath.item]
        selectedByStatusData?(type)
    }
}

