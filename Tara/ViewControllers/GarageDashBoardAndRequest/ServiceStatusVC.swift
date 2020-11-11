//
//  ServiceStatusVC.swift
//  ArabianTyres
//
//  Created by Arvind on 07/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ServiceStatusVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!

    // MARK: - Variables
    //===========================
    var sectionArr : [CellType] = [.userDetail ,.none,.serviceDetail]
    let viewModel = ServiceStatusVM()
    var requestId : String = ""
    var serviceNo : String = ""
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_ sender: Any) {
        pop()
    }
}

// MARK: - Extension For Functions
//===========================
extension ServiceStatusVC {
    
    private func initialSetup() {
        setupTextAndFont()
        setupTableView()
        viewModel.delegate = self
        viewModel.fetchBookedRequestDetail(params: [ApiKey.requestId: self.requestId], loader: true)
    }
    
    private func setupTableView() {
        mainTableView.contentInset = UIEdgeInsets(top: 8.0, left: 0, bottom: 0, right: 0)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.registerCell(with: RequestDetailTableViewCell.self)
        mainTableView.registerCell(with: ServiceDetailTableViewCell.self)
        mainTableView.registerCell(with: DashedTableViewCell.self)
        mainTableView.registerCell(with: ServiceStatusTableViewCell.self)
    }
    
    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        titleLbl.text = "Service No. " + serviceNo
    }
}

extension ServiceStatusVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? sectionArr.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch sectionArr[indexPath.row] {
            case .userDetail:
                let cell = tableView.dequeueCell(with: RequestDetailTableViewCell.self)
                cell.populateData(sectionArr[indexPath.row], model: viewModel.bookedRequestDetail ?? GarageRequestModel())
                return cell
                
            case .none:
                let cell = tableView.dequeueCell(with: DashedTableViewCell.self)
                return cell
                
            case .serviceDetail:
                let cell = tableView.dequeueCell(with: ServiceDetailTableViewCell.self)
                cell.bindDataForBookedRequestDetail(viewModel.bookedRequestDetail ?? GarageRequestModel())
                return cell
                
            default:
                return UITableViewCell()
                
            }
            
        }else {
            let cell = tableView.dequeueCell(with: ServiceStatusTableViewCell.self)
            cell.populateData(status: viewModel.bookedRequestDetail?.serviceStatus ?? nil)
            updateStatus(cell: cell)
           
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension ServiceStatusVC: ServiceStatusVMDelegate {
    func updateServiceStatusSuccess(msg: String) {
        NotificationCenter.default.post(name: Notification.Name.UpdateServiceStatus, object: nil)
        mainTableView.reloadData()
    }
    
    func updateServiceStatusFailed(msg: String) {
        
    }
    
    func bookedRequestDetailSuccess(msg: String) {
        mainTableView.reloadData()
    }
    
    func bookedRequestDetailFailed(msg: String) {
        
    }
}

extension ServiceStatusVC {
    func updateStatus(cell: ServiceStatusTableViewCell) {
        cell.carReceivedUpdateBtnTapped = {[weak self] in
            guard let `self` = self else { return }
            AppRouter.openOtpPopUpVC(vc: self, requestByUser: self.viewModel.bookedRequestDetail?.userName ?? "",requestId: self.viewModel.bookedRequestDetail?.id ?? "") {
                self.viewModel.fetchBookedRequestDetail(params: [ApiKey.requestId: self.requestId], loader: true)
            }
        }
        
        cell.inProgressUpdateBtnTapped = {[weak self] in
            guard let `self` = self else { return }
            self.viewModel.updateServiceStatus(params: [ApiKey.requestId : self.viewModel.bookedRequestDetail?.id ?? "", ApiKey.status : "in_progress"],loader: true)
        }
        
        cell.completedUpdateBtnTapped = {
            [weak self] in
            guard let `self` = self else { return }
            self.viewModel.updateServiceStatus(params: [ApiKey.requestId : self.viewModel.bookedRequestDetail?.id ?? "", ApiKey.status : "completed"],loader: true)
        }
        
        cell.takenUpdateBtnTapped = { [weak self] in
            guard let `self` = self else { return }
            self.viewModel.updateServiceStatus(params: [ApiKey.requestId : self.viewModel.bookedRequestDetail?.id ?? "", ApiKey.status : "ready_to_be_taken"],loader: true)
        }
        
        cell.yesBtnTapped = { [weak self] in
            guard let `self` = self else { return }
            printDebug("nothing to do")
        }
        
        cell.noBtnTapped = { [weak self] in
            guard let `self` = self else { return }
            printDebug("nothing to do")
        }

    }
}
