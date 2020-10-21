//
//  BankListingVC.swift
//  ArabianTyres
//
//  Created by Admin on 17/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import UIKit

class BankListingVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var searchTxtField: ATCTextField!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: - Variables
    //===========================
    var viewModel = BankListingVM()
    var bankDelegate: BankListingVMDelegate?
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        viewModel.searchBank = sender.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        mainTableView.reloadData()
    }
}

// MARK: - Extension for functions
//====================================
extension BankListingVC {
    
    private func initialSetup() {
        self.textFieldSetUp()
        mainTableView.registerCell(with: BankListingTableCell.self)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        viewModel.getBankData()
    }
    
    private func textFieldSetUp(){
        let show1 = UIButton()
        show1.isSelected = false
        self.searchTxtField.setButtonToRightView(btn: show1, selectedImage: #imageLiteral(resourceName: "icon"), normalImage: #imageLiteral(resourceName: "icon"), size: CGSize(width: 30, height: 30))
    }
}


// MARK: - Extension For TableView
//===========================
extension BankListingVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.searchedBank.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: BankListingTableCell.self, indexPath: indexPath)
        if let name = viewModel.searchedBank[indexPath.row][BankListingVM.BankKeys.name.rawValue], let code =   viewModel.searchedBank[indexPath.row][BankListingVM.BankKeys.code.rawValue]{
            cell.bankNameLbl.text = name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell =  tableView.cellForRow(at: indexPath) as? BankListingTableCell else{ return }
        bankDelegate?.sendBankCode(code: "\(cell.bankNameLbl.text ?? "")")
        self.dismiss(animated: true, completion: nil)
    }
}
