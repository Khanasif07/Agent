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
    }
  
    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        titleLbl.text = LocalizedString.ongoingServices.localized
    }
    
}
