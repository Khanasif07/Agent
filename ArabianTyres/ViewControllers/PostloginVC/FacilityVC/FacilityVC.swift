//
//  FacilityVC.swift
//  ArabianTyres
//
//  Created by Arvind on 16/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

protocol FacilitiesDelegate: class {
    func setData(dataArr : [FacilityModel])
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
            self.delegate?.setData(dataArr: self.selectedItemArr)
        }
    }

    @IBAction func clearAllAction(_ sender: UIButton) {
        viewModel.facilityDataArr.map{($0.updateModel())}
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
            return viewModel.facilityDataArr[section].category.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueHeaderFooter(with: FacilityTableHeaderView.self)
        view.categoryName.text = viewModel.facilityDataArr[section].name
        view.checkBtn.isSelected = viewModel.facilityDataArr[section].isSubCategorySelected
        view.cellBtnTapped = { [weak self] in
        guard let `self` = self else {return}
            self.viewModel.facilityDataArr[section].isSelected.toggle()
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
        cell.cellBtnTapped = {[weak self] in
            guard let `self` = self else {return}

            self.viewModel.facilityDataArr[indexPath.section].isSubCategorySelected = true
            if self.viewModel.facilityDataArr[indexPath.section].isSubCategorySelected {
                self.selectedItemArr.append(self.viewModel.facilityDataArr[indexPath.section])
            }else {
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
        mainTableView.reloadData()
    }
    
    func getfacilityFailure(){
        
    }
}