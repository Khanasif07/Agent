//
//  OfferFilterVC.swift
//  ArabianTyres
//
//  Created by Arvind on 09/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

class OfferFilterVC: BaseVC {
 
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!

    // MARK: - Variables
    //===========================
    var sectionArr : [CellType] = [.distance, .bidReceived]
    let viewModel = SRFliterVM()
    var sliderHide: Bool = false

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
    @IBAction func cancelBtnAction(_ sender: Any) {
        pop()
    }
    
    @IBAction func applyBtnAction(_ sender: Any) {
           pop()
       }
}

// MARK: - Extension For Functions
//===========================
extension OfferFilterVC {
    
    private func initialSetup() {
        setupTextAndFont()
        setupTableView()
        viewModel.initialData()
    }
    
    private func setupTableView() {
        mainTableView.contentInset = UIEdgeInsets(top: 8.0, left: 0, bottom: 0, right: 0)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.registerCell(with: OfferFilterTableViewCell.self)
        mainTableView.registerCell(with: ServiceStatusTableViewCell.self)
    }
    
    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        titleLbl.text = LocalizedString.filter.localized
    }
}

extension OfferFilterVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
  
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return CGFloat.leastNonzeroMagnitude
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: OfferFilterTableViewCell.self, indexPath: indexPath)
        cell.sectionType = sectionArr[indexPath.section]
        
        if sectionArr[indexPath.section] == .bidReceived {
            cell.configCell(catgory: self.viewModel.catgories[indexPath.section])
            cell.cellBtnTapped = { [weak self] in
                guard let `self` = self else {return}
                self.viewModel.catgories[indexPath.section].isSelected.toggle()
                self.mainTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        else {
            cell.cellBtnTapped = { [weak self] in
                guard let `self` = self else {return}
                self.sliderHide.toggle()
                self.mainTableView.reloadData()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sectionArr[indexPath.section] == .distance  {
            return self.sliderHide ? 54.0 : 154.0
        }else {
            let model = viewModel.catgories[indexPath.section]
            return model.isSelected ? CGFloat(54 + model.subCat.count * 54) : 54.0
       }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

