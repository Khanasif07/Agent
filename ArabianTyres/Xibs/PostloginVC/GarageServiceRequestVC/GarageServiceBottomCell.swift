//
//  GarageServiceBottomCell.swift
//  ArabianTyres
//
//  Created by Admin on 07/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class GarageServiceBottomCell: UITableViewCell {
    
    //MARK:-IBOutlet
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var internalTableView: AGTableView!
    @IBOutlet weak var unitPriceLbl: UILabel!
    @IBOutlet weak var unitLbl: UILabel!
    @IBOutlet weak var brandsTitleLbl: UILabel!
    
    //MARK:-Variables
    var countryBrandsSelected: ((_ SelectedIndexPath : IndexPath)->())?
    var brandDataArr : [PreferredBrand] = []
    var quantity: Int = 0
    
    //MARK:-Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        tableViewSetUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.internalTableView.layoutSubviews()
        self.superTableView?.beginUpdates()
        self.superTableView?.endUpdates()
    }
    
    private func tableViewSetUp(){
        self.internalTableView.isScrollEnabled = false
        self.internalTableView.registerCell(with: GarageServiceBrandsCell.self)
        self.internalTableView.estimatedRowHeight(88.0)
        self.internalTableView.delegate = self
        self.internalTableView.dataSource = self
    }
    
//    private func textSetUp(){
//        self.brandsTitleLbl.setTitleColor(AppColors.fontTertiaryColor, for: .normal)
//        self.unitLbl.setTitleColor(AppColors.fontTertiaryColor, for: .normal)
//        self.unitPriceLbl.setTitleColor(AppColors.fontTertiaryColor, for: .normal)
//    }
    
   
}


//MARK:- Table View Delegate and Data Source
//=========================================

extension GarageServiceBottomCell: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.brandDataArr.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: GarageServiceBrandsCell.self, indexPath: indexPath)
        cell.bindData(brandDataArr[indexPath.row])
        cell.unitLbl.text = quantity.description
        if indexPath.row == self.brandDataArr.endIndex - 1{
            cell.dashViewHeightConst.constant = 0
            cell.dashView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let handle = countryBrandsSelected{
            handle(indexPath)
        }
    }
}
