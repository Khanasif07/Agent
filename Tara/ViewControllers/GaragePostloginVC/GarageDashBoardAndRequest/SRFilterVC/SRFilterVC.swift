//
//  SRFliterVC.swift
//  ArabianTyres
//
//  Created by Arvind on 05/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SRFilterVC: BaseVC {
    
    // MARK: - IBOutlets
    //==================
    @IBOutlet weak var filterLbl: UILabel!
    @IBOutlet weak var canceBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var mainTableView: UITableView!

    // MARK: - Variables
    //===================
    let viewModel = SRFliterVM()
    var sectionArr : [FilterScreen] = [.allRequestServiceType([],false), .allRequestByStatus([],false)]
    var onTapApply : (([FilterScreen], Bool)->())?
    var isResetSelected: Bool = false
    
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
    
    @IBAction func resetBtnAction(_ sender: UIButton) {
        isResetSelected = true
        var hideStatus: [FilterScreen] = []
        for type in sectionArr  {
            switch type {
            case .allRequestServiceType(_,let hide):
                hideStatus.append(.allRequestServiceType([], hide))
            case .allRequestByStatus(_,let hide):
                hideStatus.append(.allRequestByStatus([], hide))
            default:
                break
            }
        }
        sectionArr = hideStatus
        mainTableView.reloadData()
    }
    
    @IBAction func applyBtnAction(_ sender: UIButton) {
        if isResetSelected {
            onTapApply?(sectionArr, false)
            self.pop()
            return
        }
//        let result = checkFilterStatus()
//        if result.status {
            onTapApply?(sectionArr, true)
            self.pop()
//        }else {
//            CommonFunctions.showToastWithMessage(result.msg)
//        }
    }
}

// MARK: - Extension For Functions
//===========================
extension SRFilterVC {
    
    private func initialSetup() {
        setupTextAndFont()
    }
    
    private func tableViewSetup() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.contentInset = UIEdgeInsets(top: 8.0, left: 0, bottom: 0, right: 0)
        mainTableView.registerCell(with: OfferFilterTableViewCell.self)
    }
    
    private func setupTextAndFont() {
        
        filterLbl.text = LocalizedString.filters.localized
        canceBtn.setTitle(LocalizedString.cancel.localized, for: .normal)
        applyBtn.setTitle(LocalizedString.applyFilters.localized, for: .normal)
  
        filterLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        canceBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(17.0)
        applyBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(17.0)

    }
    
    func updateDataSouce(_ filterValue:String , indexPath : IndexPath) {
        var data: [String] = []
        isResetSelected = false
        switch self.sectionArr[indexPath.section] {
        case .allRequestServiceType(let arr, let hide) :
            if arr.contains(filterValue) {
                guard let firstIndex = arr.firstIndex(of: filterValue) else {return}
                data = arr
                data.remove(at: firstIndex)
                self.sectionArr[indexPath.section] = .allRequestServiceType(data, hide)
            }else {
                data = arr
                data.append(filterValue)
                self.sectionArr[indexPath.section] = .allRequestServiceType(data, hide)
            }
        case .allRequestByStatus(let arr, let hide) :
            if arr.contains(filterValue) {
                guard let firstIndex = arr.firstIndex(of: filterValue) else {return}
                data = arr
                data.remove(at: firstIndex)
                self.sectionArr[indexPath.section] = .allRequestByStatus(data, hide)
            }else {
                data = arr
                data.append(filterValue)
                self.sectionArr[indexPath.section] = .allRequestByStatus(data, hide)
            }
        default:
            return
        }
        self.mainTableView.reloadData()
    }
    
    private func checkFilterStatus() -> (status: Bool, msg: String) {
        var flag : [Bool] = [true,true]
        var msg = ""
        for data in sectionArr{
            switch data {
                
            case .allRequestServiceType(let str, _):
                if str.isEmpty {
                    flag[0] = false
                    msg = "Please select Any Filter"
                }
                break
                
            case .allRequestByStatus(let str, _):
                if str.isEmpty {
                    flag[1] = false
                    msg = "Please select Any Filter"
                }
                break
            default:
                break
            }
        }
        return (flag.contains(true),msg)
    }
}

extension SRFilterVC :UITableViewDelegate,UITableViewDataSource{
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
            self.updateDataSouce(requestAndStatusType,indexPath : indexPath)
        }
        
        return cell
    }
}
