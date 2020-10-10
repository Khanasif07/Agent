//
//  MyServiceFilterVC.swift
//  ArabianTyres
//
//  Created by Arvind on 09/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class MyServiceFilterVC: BaseVC {
    
    // MARK: - IBOutlets
    //==================
    @IBOutlet weak var filterLbl: UILabel!
    @IBOutlet weak var canceBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var mainTableView: UITableView!

    // MARK: - Variables
    //===================
    let viewModel = SRFliterVM()
    var sectionArr : [CellType] = [.distance, .bidReceived]

    // MARK: - Lifecycle
    //===================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        tableViewSetup()
        viewModel.initialData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func applyBtnAction(_ sender: UIButton) {
        
    }
}

// MARK: - Extension For Functions
//===========================
extension MyServiceFilterVC {
    
    private func initialSetup() {
        setupTextAndFont()
        viewModel.initialData()
    }
    
    private func tableViewSetup() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.contentInset = UIEdgeInsets(top: 8.0, left: 0, bottom: 0, right: 0)
        mainTableView.registerCell(with: OfferFilterTableViewCell.self)
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

extension MyServiceFilterVC :UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.catgories.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 300.0
//    }
//
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = viewModel.catgories[indexPath.section]
        return model.isSelected ? CGFloat(54 + model.subCat.count * 54) : 54.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: OfferFilterTableViewCell.self, indexPath: indexPath)
        cell.configCell(catgory: self.viewModel.catgories[indexPath.section])
       
        cell.cellBtnTapped = { [weak self] in
            guard let `self` = self else {return}
            self.viewModel.catgories[indexPath.section].isSelected.toggle()
            self.mainTableView.reloadRows(at: [indexPath], with: .automatic)
//            cell.collView.reloadData()
        }
        return cell
    }
}
