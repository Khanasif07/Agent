//
//  GarageCustomerRatingVC.swift
//  Tara
//
//  Created by Arvind on 11/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class GarageCustomerRatingVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!

    // MARK: - Variables
    //===========================
    var sectionArr : [CellType] = [.userDetail ,.serviceOn,.none,.serviceDetail]
    let viewModel = GarageCustomerRatingVM()
    var requestId : String = ""
    var reasonOfReport : String = ""
    var name :String = ""
    var screenType: ServiceCompletedVC.ScreenType = .serviceComplete
    
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
    @IBAction func cancelBtnAction(_ sender: Any) {
        pop()
    }
}

// MARK: - Extension For Functions
//===========================
extension GarageCustomerRatingVC {
    
    private func initialSetup() {
        setupTextAndFont()
        setupTableView()
        viewModel.delegate = self
        hitApi()
    }
    
    private func setupTableView() {
        mainTableView.contentInset = UIEdgeInsets(top: 8.0, left: 0, bottom: 0, right: 0)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.registerCell(with: RequestDetailTableViewCell.self)
        mainTableView.registerCell(with: ServiceDetailTableViewCell.self)
        mainTableView.registerCell(with: DashedTableViewCell.self)
        mainTableView.registerCell(with: ReviewAndRatingTableViewCell.self)
        
    }
    
    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        titleLbl.text = name
    }
    private func hitApi(){
        if screenType == .serviceComplete {
            viewModel.fetchCustomerRatingDetail(params: [ApiKey.requestId: self.requestId], loader: true)
            
        }
        else {
            viewModel.fetchServiceHistoryDetail(params: [ApiKey.requestId: self.requestId], loader: true)
        }
    }
}

extension GarageCustomerRatingVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? sectionArr.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch sectionArr[indexPath.row] {
            case .userDetail, .serviceOn:
                let cell = tableView.dequeueCell(with: RequestDetailTableViewCell.self)
                cell.helpBtnTapped = { [weak self] in
                    guard let `self` = self else {return}
                    AppRouter.goToOneToOneChatVC(self, userId: AppConstants.adminId, requestId: "", name: "Support Chat", image: "", unreadMsgs: 0, isSupportChat: true,garageUserId: isCurrentUserType == .garage ? UserModel.main.id : "")
                }
                cell.populateData(sectionArr[indexPath.row], model: viewModel.garageCompletedDetail ?? GarageRequestModel())
                return cell
                
            case .none:
                let cell = tableView.dequeueCell(with: DashedTableViewCell.self)
                return cell
                
            case .serviceDetail:
                let cell = tableView.dequeueCell(with: ServiceDetailTableViewCell.self)
                cell.bindDataForBookedRequestDetail(viewModel.garageCompletedDetail ?? GarageRequestModel())
                return cell
                
            default:
                return UITableViewCell()
                
            }
            
        }else {
            let cell = tableView.dequeueCell(with: ReviewAndRatingTableViewCell.self)
            cell.bindData(viewModel.garageCompletedDetail ?? GarageRequestModel(),screenType: self.screenType)
            cell.reportReviewBtnTapped = { [weak self] in
                guard let `self` = self else { return }
                AppRouter.goToReportPopupVC(vc: self)
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

extension GarageCustomerRatingVC : GarageCustomerRatingVMDelegate, PickerDataDelegate {
    
    func selectedReason(str: String) {
        viewModel.postReportReview(params: [ApiKey.reviewId: viewModel.garageCompletedDetail?.ratingId ?? "", ApiKey.reason: str], loader: true)
    }
    
    func customerRatingSuccess(msg: String) {
        mainTableView.reloadData()
    }
    
    func customerRatingFailure(msg: String) {
        CommonFunctions.showToastWithMessage(msg)
    }
    
    func reportReviewSuccess(msg: String) {
        mainTableView.reloadData()
    }
    
    func reportReviewFailure(msg: String) {
        CommonFunctions.showToastWithMessage(msg)
    }
    
}
