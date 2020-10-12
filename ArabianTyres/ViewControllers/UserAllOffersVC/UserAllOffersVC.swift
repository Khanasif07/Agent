//
//  UserAllOffersVC.swift
//  ArabianTyres
//
//  Created by Admin on 09/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class UserAllOffersVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
 
    // MARK: - Variables
    //===========================
    var requestId: String = ""
    let viewModel = UserAllOfferVM()
    
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
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func filterBtnAction(_ sender: UIButton) {
         let scene = OfferFilterVC.instantiate(fromAppStoryboard: .GarageRequest)
         self.navigationController?.pushViewController(scene, animated: true)
    }
    
}

// MARK: - Extension For Functions
//===========================
extension UserAllOffersVC {
    
    private func initialSetup() {
        setupTextAndFont()
        setupTableView()
        viewModel.delegate = self
        hitApi()
    }
    
    private func setupTableView() {
        mainTableView.contentInset = UIEdgeInsets(top: 0.0, left: 0, bottom: 0, right: 0)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.registerCell(with: UserOffersTableCell.self)
    }
    
    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        //           titleLbl.text = LocalizedString.tyreServiceRequest.localized
       }
    
    private func hitApi() {
        let dict : JSONDictionary = [ApiKey.page: "1",ApiKey.limit : "20", ApiKey.requestId : self.requestId]
        viewModel.getUserBidData(params: dict)
    }
}

// MARK: - Extension For TableView
//===========================
extension UserAllOffersVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userBidListingArr.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: UserOffersTableCell.self, indexPath: indexPath)
        cell.bindData(viewModel.userBidListingArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension UserAllOffersVC : UserAllOfferVMDelegate {
    func getUserBidDataSuccess(message: String){
        mainTableView.reloadData()
    }
    
    func getUserBidDataFailed(error:String){
        
    }
}
