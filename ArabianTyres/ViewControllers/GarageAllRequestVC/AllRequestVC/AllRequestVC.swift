//
//  AllRequestVC.swift
//  ArabianTyres
//
//  Created by Admin on 05/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import UIKit

class AllRequestVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var viewModel = AllRequestVM()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        hitApi()
    }
    
    // MARK: - IBActions
    //===========================
    
    
}

// MARK: - Extension For Functions
//===========================
extension AllRequestVC {
    
    private func initialSetup() {
        viewModel.delegate = self
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerCell(with: ServiceRequestTableCell.self)
    }
    
    private func hitApi(){
        viewModel.getGarageRequestData(params: [ApiKey.page:"1", ApiKey.limit: "20"])
    }
}

// MARK: - Extension For TableView
//===========================
extension AllRequestVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: ServiceRequestTableCell.self, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          AppRouter.goToGarageServiceRequestVC(vc: self)
    }
}

extension AllRequestVC : AllRequestVMDelegate {
    func getGarageListingDataSuccess(message: String) {
        
    }
    
    func getGarageListingDataFailed(error: String) {
        
    }
}
