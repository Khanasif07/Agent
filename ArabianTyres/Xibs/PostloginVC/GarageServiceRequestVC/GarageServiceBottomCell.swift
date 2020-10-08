//
//  GarageServiceBottomCell.swift
//  ArabianTyres
//
//  Created by Admin on 07/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class GarageServiceBottomCell: UITableViewCell {
    
    var selectImageArray: [UIImage] = [#imageLiteral(resourceName: "vehicle"),#imageLiteral(resourceName: "serviceHistory"),#imageLiteral(resourceName: "payment"),#imageLiteral(resourceName: "savedCard")]
    var brandDataArr : [PreferredBrand] = []
    
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var internalTableView: AGTableView!
    @IBOutlet weak var unitPriceLbl: UIButton!
    @IBOutlet weak var unitLbl: UIButton!
    @IBOutlet weak var brandsTitleLbl: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableViewSetUp()
        textSetUp()
        // Initialization code
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
    
    private func textSetUp(){
        self.brandsTitleLbl.setTitleColor(AppColors.fontTertiaryColor, for: .normal)
        self.unitLbl.setTitleColor(AppColors.fontTertiaryColor, for: .normal)
        self.unitPriceLbl.setTitleColor(AppColors.fontTertiaryColor, for: .normal)
    }
    
   
}


//MARK:- Table View Delegate and Data Source
//=========================================

extension GarageServiceBottomCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.brandDataArr.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: GarageServiceBrandsCell.self, indexPath: indexPath)
        if indexPath.row == self.brandDataArr.endIndex - 1{
            cell.dashViewHeightConst.constant = 0
            cell.dashView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
