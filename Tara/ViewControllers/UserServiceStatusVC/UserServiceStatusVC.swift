//
//  UserServiceStatusVC.swift
//  Tara
//
//  Created by Arvind on 11/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class UserServiceStatusVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!

    // MARK: - Variables
    //===========================
    var sectionArr : [CellType] = [.garageDetail ,.requestNumber,.none,.serviceDetail]
    let viewModel = UserServiceStatusVM()
    var requestId : String = ""
    
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
extension UserServiceStatusVC {
    
    private func initialSetup() {
        setupTextAndFont()
        setupTableView()
        viewModel.delegate = self
        viewModel.fetchRequestDetail(params: [ApiKey.requestId: self.requestId], loader: true)
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
        titleLbl.text = "Ongoing Service"
    }
}

extension UserServiceStatusVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? sectionArr.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch sectionArr[indexPath.row] {
            case .garageDetail, .requestNumber:
                let cell = tableView.dequeueCell(with: RequestDetailTableViewCell.self)
                cell.populateData(sectionArr[indexPath.row], model: viewModel.serviceDetailData ?? GarageRequestModel())
                return cell
                
            case .none:
                let cell = tableView.dequeueCell(with: DashedTableViewCell.self)
                return cell
                
            case .serviceDetail:
                let cell = tableView.dequeueCell(with: ServiceDetailTableViewCell.self)
                cell.bindDataForBookedRequestDetail(viewModel.serviceDetailData ?? GarageRequestModel())
                return cell
                
            default:
                return UITableViewCell()
                
            }
            
        }else {
            let cell = tableView.dequeueCell(with: ServiceStatusTableViewCell.self)
            cell.populateDataForUserService(status: viewModel.serviceDetailData?.serviceStatus ?? nil)
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

extension UserServiceStatusVC: UserServiceStatusVMDelegate {
    func serviceDetailSuccess(msg: String) {
        mainTableView.reloadData()
    }
    
    func serviceDetailFailed(msg: String) {
        CommonFunctions.showToastWithMessage(msg)
    }
    
    func markCarReceivedSuccess(msg: String){
        AppRouter.goToRatingVC(vc: self, requestId: self.requestId, garageName: viewModel.serviceDetailData?.garageName ?? "")
    }
    
    func markCarReceivedFailure(msg: String){
        CommonFunctions.showToastWithMessage(msg)
    }
}

extension UserServiceStatusVC {
    func updateStatus(cell: ServiceStatusTableViewCell) {
        cell.yesBtnTapped = { [weak self] in
            guard let `self` = self else { return }
            self.viewModel.carReceived(params: [ApiKey.requestId: self.requestId, ApiKey.status : true], loader: true)
        }
        
        cell.noBtnTapped = { [weak self] in
            guard let `self` = self else { return }
            printDebug("nothing to do")
        }
    }
}
