//
//  URTyreSizeVC.swift
//  ArabianTyres
//
//  Created by Admin on 21/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class URTyreSizeVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bottomDescLbl: UILabel!
    @IBOutlet weak var topDescLbl: UILabel!
    @IBOutlet weak var proceedBtn: AppButton!
    @IBOutlet weak var mainTableView: UITableView!
    
    
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupTextAndFonts()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func proccedBtnAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name.SelectedTyreSizeSuccess, object: nil)
        self.navigationController?.popViewControllers(controllersToPop: 2, animated: true)
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
   
    
}

// MARK: - Extension For Functions
//===========================
extension URTyreSizeVC {
    
    private func initialSetup() {
        self.proceedBtn.isEnabled = true
        mainTableView.registerCell(with: URTyreSizeTableCell.self)
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    private func setupTextAndFonts() {
        switch categoryType{
            
        case .oil:
            proceedBtn.setTitle(LocalizedString.next.localized, for: .normal)
            titleLbl.text = LocalizedString.selectViscosity.localized
            topDescLbl.text = LocalizedString.weHaveFoundSutiableOilViscosity.localized
            bottomDescLbl.text = LocalizedString.pleaseSelectAnyViscosityToProceed.localized
        case .tyres:
            proceedBtn.setTitle(LocalizedString.proceed.localized, for: .normal)
            titleLbl.text = LocalizedString.selectTyreSize.localized
            topDescLbl.text = LocalizedString.weHaveFoundSutiableTyreForYourVehicleAsPerTheProvidedDetails.localized
            bottomDescLbl.text = LocalizedString.pleaseSelectAnyTyreToProceed.localized

        case .battery:
            titleLbl.text = LocalizedString.alert.localized
            
        }
    }

}

// MARK: - Extension For TableView
//===========================
extension URTyreSizeVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: URTyreSizeTableCell.self, indexPath: indexPath)
        cell.bindData(categoryType: categoryType)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
