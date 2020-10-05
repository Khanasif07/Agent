//
//  OngoingServiceListingVC.swift
//  ArabianTyres
//
//  Created by Arvind on 30/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class OngoingServiceListingVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var listingTableView: UITableView!
    
    // MARK: - Variables
    //===========================

    
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

    }
    
    // MARK: - IBActions
    //===========================
}

// MARK: - Extension For Functions
//===========================
extension OngoingServiceListingVC {
    
    private func initialSetup() {
        setupTextAndFont()
        setupTableView()
    }
    
    private func setupTableView() {
        listingTableView.delegate = self
        listingTableView.dataSource = self
        listingTableView.registerCell(with: ServiceListingTableViewCell.self)
    }
    
    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        titleLbl.text = LocalizedString.ongoingServices.localized
    }
}

extension OngoingServiceListingVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: ServiceListingTableViewCell.self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

