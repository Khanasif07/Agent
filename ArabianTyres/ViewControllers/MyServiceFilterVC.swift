//
//  MyServiceFilterVC.swift
//  ArabianTyres
//
//  Created by Arvind on 09/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class MyServiceFilterVC: BaseVC {
    
    // MARK: - IBOutlets
    //==================
    @IBOutlet weak var filterLbl: UILabel!
    @IBOutlet weak var canceBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===================
    let viewModel = SRFliterVM()
    var sectionArr : [FilterScreen] = [.byServiceType("",false), .byStatus("",false), .date(Date(),Date(),false)]
    var onTapApply : (([FilterScreen])->())?
    
    // MARK: - Lifecycle
    //===================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        tableViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func applyBtnAction(_ sender: UIButton) {
        let result = checkFilterStatus()
        
        if result.status {
            onTapApply?(sectionArr)
            self.pop()
        }else {
            CommonFunctions.showToastWithMessage(result.msg)
        }
    }
}

// MARK: - Extension For Functions
//===========================
extension MyServiceFilterVC {
    
    private func initialSetup() {
        setupTextAndFont()
        viewModel.initialData()
    }
    
    private func tableViewSetup() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.contentInset = UIEdgeInsets(top: 8.0, left: 0, bottom: 0, right: 0)
        mainTableView.registerCell(with: OfferFilterTableViewCell.self)
    }
    
    private func setupTextAndFont() {
        
        filterLbl.text = LocalizedString.filter.localized
        canceBtn.setTitle(LocalizedString.cancel.localized, for: .normal)
        applyBtn.setTitle(LocalizedString.apply.localized, for: .normal)
        
        filterLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        canceBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(17.0)
        applyBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(17.0)
        
    }
    
    private func checkFilterStatus() -> (status: Bool, msg: String) {
        var flag = true
        var msg = ""
        for data in sectionArr{
            switch data {
                
            case .byServiceType(let str, _):
                if str.isEmpty {
                    flag = false
                    msg = "Please select Service Type"
                }
            case .byStatus(let str, _):
                if str.isEmpty {
                    flag = false
                    msg = "Please select Status Type"
                }
                
            case .date(let fromDate, let toDate, _):
                if fromDate == nil {
                    flag = false
                    msg = "Please select from date"
                }
                if toDate == nil {
                    flag = false
                    msg = "Please select to date"
                }
                
            default:
                break
            }
            if !flag {break}
        }
        return (flag,msg)
    }
}

extension MyServiceFilterVC :UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArr.endIndex
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = self.sectionArr[indexPath.section]
        if case .date = type {
            return type.isHide ? 154.0 : 54.0
            
        }else {
            return type.isHide ? CGFloat(54 + type.fliterTypeArr.count * 54) : 54.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: OfferFilterTableViewCell.self, indexPath: indexPath)
        cell.sectionType = sectionArr[indexPath.section]
        
        cell.cellBtnTapped = { [weak self] in
            guard let `self` = self else {return}
            self.sectionArr[indexPath.section] = self.sectionArr[indexPath.section].isSelected
            self.mainTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        cell.selectedByStatusData = { [weak self] (requestAndStatusType) in
            guard let `self` = self else {return}
            switch self.sectionArr[indexPath.section] {
            case .byServiceType(_, let hide) :
                self.sectionArr[indexPath.section] = .byServiceType(requestAndStatusType, hide)
                
            case .byStatus(_, let hide) :
                self.sectionArr[indexPath.section] = .byStatus(requestAndStatusType, hide)
                
            default:
                return
            }
            self.mainTableView.reloadData()
            
        }
        
        cell.selectedDateData = { [weak self] (fromDate,toDate) in
            guard let `self` = self else {return}
            self.sectionArr[indexPath.section] = .date(fromDate, toDate, self.sectionArr[indexPath.section].isHide)
        }
        return cell
    }
}