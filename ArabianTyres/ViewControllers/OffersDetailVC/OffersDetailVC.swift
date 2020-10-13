//
//  OffersDetailVC.swift
//  ArabianTyres
//
//  Created by Admin on 12/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class OffersDetailVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var unitLbl: UILabel!
    @IBOutlet weak var unitPriceLbl: UILabel!
    @IBOutlet weak var brandsLbl: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var acceptBtn: AppButton!
    @IBOutlet weak var rejectBtn: AppButton!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func acceptBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func rejectBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func crossBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Extension For Functions
//===========================
extension OffersDetailVC {
    
    private func initialSetup() {
        acceptBtn.isEnabled = true
        rejectBtn.isBorderSelected = true
        setupTextAndFont()
        setupTableView()
    }
    
    private func setupTableView() {
        mainTableView.contentInset = UIEdgeInsets(top: 0.0, left: 0, bottom: 0, right: 0)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.registerCell(with: OffersDetailTableCell.self)
        mainTableView.tableHeaderView = headerView
    }
    
    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        [totalPriceLbl,unitLbl,unitPriceLbl,brandsLbl].forEach({$0?.textColor = AppColors.fontTertiaryColor})
        //           titleLbl.text = LocalizedString.tyreServiceRequest.localized
    }
}

// MARK: - Extension For TableView
//===========================
extension OffersDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: OffersDetailTableCell.self, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
