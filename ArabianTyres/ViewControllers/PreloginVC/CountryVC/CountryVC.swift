//
//  CountryVC.swift
//  ArabianTyres
//
//  Created by Admin on 07/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class CountryVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var countrySeacrhBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dropDownbutton: UIButton!
    
    // MARK: - Variables
    //===========================
    var viewModel = CountryVM()
    var countryDelegate: CountryDelegate?
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        countrySeacrhBar.delegate = self
        initialSetup()
        viewModel.getCountyData()
        self.dropDownbutton.tintColor = AppColors.fontPrimaryColor
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func droDownButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension for functions
//====================================
extension CountryVC {
    
    private func initialSetup() {
        tableView.registerCell(with: CountryCodeTableCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK:- UISearchBarDelegate
//==========================
extension CountryVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchCountry = searchText
        tableView.reloadData()
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
}

//MARK:-  UITableViewDelegate
//===========================
extension CountryVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell =  tableView.cellForRow(at: indexPath) as? CountryCodeTableCell else{ return }
        cell.countryCodeLabel.textColor = AppColors.fontPrimaryColor
        cell.countryNameLabel.textColor = AppColors.fontPrimaryColor
        //
        countryDelegate?.sendCountryCode(code: "+" + "\(cell.countryCodeLabel.text ?? "+1")")
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:-  UITableViewDataSource
//==========================
extension CountryVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchedCountry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: CountryCodeTableCell.self, indexPath: indexPath)
        if let name = viewModel.searchedCountry[indexPath.row][CountryVM.CountryKeys.name.rawValue], let code =   viewModel.searchedCountry[indexPath.row][CountryVM.CountryKeys.code.rawValue]{
            cell.countryNameLabel.text = name
            cell.countryCodeLabel.text = code
        }
        return cell
    }
}

