//
//  OfferFilterVC.swift
//  ArabianTyres
//
//  Created by Arvind on 09/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

class OfferFilterVC: BaseVC {
 
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var applyFilterBtn: AppButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!

    // MARK: - Variables
    //===========================
    var sectionArr : [FilterScreen] = [.distance("","", false), .bidReceived("",false)]
    var onTapApply : (([FilterScreen])->())?
    let viewModel = SRFliterVM()
    var sliderHide: Bool = false

    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyFilterBtn.round(radius: 4.0)

    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func cancelBtnAction(_ sender: Any) {
        pop()
    }
    
    @IBAction func resetFilterAction(_ sender: UIButton) {
        
    }
    
    @IBAction func applyBtnAction(_ sender: Any) {
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
extension OfferFilterVC {
    
    private func initialSetup() {
        setupTextAndFont()
        setupTableView()
    }
    
    private func setupTableView() {
        mainTableView.contentInset = UIEdgeInsets(top: 8.0, left: 0, bottom: 0, right: 0)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.registerCell(with: OfferFilterTableViewCell.self)
    }
    
    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        titleLbl.text = LocalizedString.filter.localized
    }
    
    func updateDataSouce(_ filterValue:String , indexPath : IndexPath) {
        switch self.sectionArr[indexPath.section] {
        case .bidReceived(let txt, let hide) :
         self.sectionArr[indexPath.section] = .bidReceived(filterValue, hide)

        default:
            return
        }
        self.mainTableView.reloadData()
    }
    
    private func checkFilterStatus() -> (status: Bool, msg: String) {
        var flag = true
        var msg = ""
        for data in sectionArr{
            switch data {
                
            case .bidReceived(let arr, _):
                if arr.isEmpty {
                    flag = false
                    msg = "Please select Service Type"
                }
            default:
                break
            }
            if !flag {break}
        }
        return (flag,msg)
    }
}

extension OfferFilterVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
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
        
        cell.selectedDistance = { [weak self] (minValue, maxValue) in
            guard let `self` = self else {return}
            self.sectionArr[indexPath.section] = .distance(minValue, maxValue, self.sectionArr[indexPath.section].isHide)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = self.sectionArr[indexPath.section]
        if case .distance = type {
            return type.isHide ? 154.0 : 54.0
            
        }else {
            return type.isHide ? CGFloat(54 + type.fliterTypeArr.count * 54) : 54.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

