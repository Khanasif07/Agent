//
//  FacilityVC.swift
//  ArabianTyres
//
//  Created by Arvind on 16/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

protocol FacilitiesDelegate: class {
    func setData(dataArr : [FacilityModel], brandAndServiceArr : [String])
}

class FacilityVC: BaseVC {

    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var clearAllBtn: UIButton!
    @IBOutlet weak var mainTableView: UITableView!

    // MARK: - Variables
    //===========================
    var viewModel = GarageRegistrationVM()
    var selectedItemArr : [FacilityModel] = []
    weak var delegate : FacilitiesDelegate?
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - IBActions
    //===========================

    @IBAction func cancelBtnAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func doneBtnAction(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate?.setData(dataArr: self.selectedItemArr, brandAndServiceArr: self.viewModel.getBrandAndServiceName(data: self.selectedItemArr))
        }
    }

    @IBAction func clearAllAction(_ sender: UIButton) {
        viewModel.facilityDataArr.map{($0.updateModel())}
        selectedItemArr.removeAll()
        mainTableView.reloadData()
    }
}

// MARK: - Extension For Functions
//===========================
extension FacilityVC {

    private func initialSetup() {
        self.hitApi()
        viewModel.delegate = self
        setupTextAndFont()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.registerHeaderFooter(with: FacilityTableHeaderView.self)
        mainTableView.registerCell(with: FacilityTableViewCell.self)
    }

    private func setupTextAndFont(){
        cancelBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(17.0)
        doneBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(17.0)
        clearAllBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(12.0)

        cancelBtn.setTitle(LocalizedString.cancel.localized, for: .normal)
        doneBtn.setTitle(LocalizedString.done.localized, for: .normal)
        clearAllBtn.setTitle(LocalizedString.clearAll.localized, for: .normal)

    }
    
    private func hitApi(){
        viewModel.fetchFacilityList(params: [ApiKey.page: "1",ApiKey.limit : "20"])
    }
}


// MARK: - Extension For TableView
//===========================
extension FacilityVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.facilityDataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.facilityDataArr[section].isSelected {
            return viewModel.facilityDataArr[section].subCategory.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueHeaderFooter(with: FacilityTableHeaderView.self)
        view.categoryName.text = viewModel.facilityDataArr[section].name
        view.arrowImg.isHidden = viewModel.facilityDataArr[section].subCategory.count == 0
        view.checkBtn.isSelected = viewModel.facilityDataArr[section].isSubCategorySelected
        view.arrowImg.isHighlighted = viewModel.facilityDataArr[section].isSelected
        view.cellBtnTapped = { [weak self] in
        guard let `self` = self else {return}
           
            if self.viewModel.facilityDataArr[section].subCategory.count == 0 {
                if !self.viewModel.facilityDataArr[section].isSelected {
                    self.selectedItemArr.append(self.viewModel.facilityDataArr[section])
                }else {
                    self.selectedItemArr.removeAll{($0.id == self.viewModel.facilityDataArr[section].id)}

                }
                self.viewModel.facilityDataArr[section].isSelected.toggle()
                self.viewModel.facilityDataArr[section].isSubCategorySelected.toggle()
            }else {
                self.viewModel.facilityDataArr[section].isSelected.toggle()
            }
            
            self.mainTableView.reloadData()
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: FacilityTableViewCell.self, indexPath: indexPath)
//               cell.checkBtn.isSelected = viewModel.facilityDataArr[indexPath.section].category[indexPath.row].isSelected

        cell.subCategoryName.text = viewModel.facilityDataArr[indexPath.section].subCategory[indexPath.row].name

//        cell.subCategoryName.text = viewModel.facilityDataArr[indexPath.section].category[indexPath.row].name
        cell.checkBtn.isSelected = viewModel.facilityDataArr[indexPath.section].subCategory[indexPath.row].isSelected
        
        cell.cellBtnTapped = { [weak self] in
            guard let `self` = self else {return}
            let txt = self.viewModel.facilityDataArr[indexPath.section].subCategory[indexPath.row].name +  " (\(self.viewModel.facilityDataArr[indexPath.section].name))"
         
            self.viewModel.facilityDataArr[indexPath.section].subCategory[indexPath.row].isSelected.toggle()
            if let _ = self.viewModel.facilityDataArr[indexPath.section].subCategory.firstIndex(where: { (model) -> Bool in
                return model.isSelected
                
            }) {
                if !self.viewModel.facilityDataArr[indexPath.section].isSubCategorySelected {
                    self.selectedItemArr.append(self.viewModel.facilityDataArr[indexPath.section])

                }
                self.viewModel.facilityDataArr[indexPath.section].isSubCategorySelected = true
            
            }else {
                self.viewModel.facilityDataArr[indexPath.section].isSubCategorySelected = false
                self.selectedItemArr.removeAll{($0.id == self.viewModel.facilityDataArr[indexPath.section].id)}
            }
            self.mainTableView.reloadData()
        }
        cell.bottomView.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension FacilityVC :GarageRegistrationVMDelegate{
  
  func getfacilitySuccess(){
            if !selectedItemArr.isEmpty {
                for (indexx,item) in viewModel.facilityDataArr.enumerated() {
                    if let firstIndex = self.selectedItemArr.firstIndex(where: { (model) -> Bool in
                        return model.id == item.id
                    }){
                        viewModel.facilityDataArr[indexx].isSubCategorySelected = true
                        viewModel.facilityDataArr[indexx].isSelected = true
//                        for (index, data) in viewModel.facilityDataArr[indexx].subCategory.enumerated(){
//                            if let firstIndexx = self.selectedItemArr[firstIndex].subCategory.firstIndex(where: { (model) -> Bool in
//                                return model.id == data.id
//                            }){
//                                viewModel.facilityDataArr[indexx].subCategory[firstIndex].isSelected = true
//                            }
//                        }
                        
                        viewModel.facilityDataArr[indexx].subCategory = self.selectedItemArr[firstIndex].subCategory
                        }
                    }
                }
            mainTableView.reloadData()
        }
    
    func getfacilityFailure(){
        
    }
}
