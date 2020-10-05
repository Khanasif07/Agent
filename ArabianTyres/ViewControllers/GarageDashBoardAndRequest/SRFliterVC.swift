//
//  SRFliterVC.swift
//  ArabianTyres
//
//  Created by Arvind on 05/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SRFliterVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var filterLbl: UILabel!
    @IBOutlet weak var canceBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var mainTableView: UITableView!

    
    // MARK: - Variables
    //===========================
    
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        tableViewSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyBtnAction(_ sender: UIButton) {
        
    }
}

// MARK: - Extension For Functions
//===========================
extension SRFliterVC {
    
    private func initialSetup() {
        setupTextAndFont()
    }
    
    private func setupTextAndFont() {
        
        filterLbl.text = LocalizedString.filter.localized
        canceBtn.setTitle(LocalizedString.cancel.localized, for: .normal)
        applyBtn.setTitle(LocalizedString.apply.localized, for: .normal)
  
        filterLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        canceBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(17.0)
        applyBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(17.0)

    }
}
