//
//  BookedTyreRequestVC.swift
//  ArabianTyres
//
//  Created by Arvind on 06/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

class BookedTyreRequestVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!

    // MARK: - Variables
    //===========================
    var sectionArr : [CellType] = [.created, .accepted,.payAmount,.none,.serviceDetail]
    var requestId : String = ""
    let viewModel = BookedTyreRequestVM()
    
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
    @IBAction func crossBtnAction(_ sender: Any) {
        pop()
//        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension For Functions
//===========================
extension BookedTyreRequestVC {
    
    private func initialSetup() {
        viewModel.delegate = self
        setupTextAndFont()
        setupTableView()
        viewModel.fetchBookedRequestDetail(params: [ApiKey.requestId: self.requestId], loader: true)
     
    }
    
    private func setupTableView() {
        mainTableView.contentInset = UIEdgeInsets(top: 8.0, left: 0, bottom: 0, right: 0)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.registerCell(with: RequestDetailTableViewCell.self)
        mainTableView.registerCell(with: DashedTableViewCell.self)
        mainTableView.registerCell(with: ServiceDetailTableViewCell.self)

        mainTableView.registerCell(with: TyreRequestLocationTableViewCell.self)
    }
    
    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        titleLbl.text =  self.viewModel.requestType == .tyres ? LocalizedString.tyreServiceRequest.localized : self.viewModel.requestType == .battery ? LocalizedString.batteryServiceRequest.localized : LocalizedString.oilServiceRequest.localized
    }
}

extension BookedTyreRequestVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? sectionArr.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch sectionArr[indexPath.row] {
           
            case .created, .accepted, .payAmount:
                let cell = tableView.dequeueCell(with: RequestDetailTableViewCell.self)
//                cell.bindCell(sectionArr[indexPath.row], model: viewModel.bookedRequestDetail ?? GarageRequestModel())
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
            
            let cell = tableView.dequeueCell(with: TyreRequestLocationTableViewCell.self)
            cell.startServiceBtnTapped = {[weak self] in
                self?.showAlert(msg: LocalizedString.underDevelopment.localized)
            }
            cell.chatBtnTapped = {[weak self] in
                self?.showAlert(msg: LocalizedString.underDevelopment.localized)
            }
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

extension BookedTyreRequestVC : BookedTyreRequestVMDelegate{
    func bookedRequestDetailSuccess(msg: String) {
        mainTableView.reloadData()
    }
    
    func bookedRequestDetailFailed(msg: String) {
        CommonFunctions.showToastWithMessage(msg)
    }
}

