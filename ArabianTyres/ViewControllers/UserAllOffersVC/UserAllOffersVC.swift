//
//  UserAllOffersVC.swift
//  ArabianTyres
//
//  Created by Admin on 09/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class UserAllOffersVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    
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
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func filterBtnAction(_ sender: UIButton) {
         let scene = OfferFilterVC.instantiate(fromAppStoryboard: .GarageRequest)
         self.navigationController?.pushViewController(scene, animated: true)
    }
    
}

// MARK: - Extension For Functions
//===========================
extension UserAllOffersVC {
    
     private func initialSetup() {
           setupTextAndFont()
           setupTableView()
       }
       
       private func setupTableView() {
        mainTableView.contentInset = UIEdgeInsets(top: 0.0, left: 0, bottom: 0, right: 0)
           mainTableView.delegate = self
           mainTableView.dataSource = self
           mainTableView.registerCell(with: UserOffersTableCell.self)
       }
       
       private func setupTextAndFont(){
           titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
//           titleLbl.text = LocalizedString.tyreServiceRequest.localized
       }
}

// MARK: - Extension For TableView
//===========================
extension UserAllOffersVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: UserOffersTableCell.self, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppRouter.presentOfferDetailVC(vc: self)
    }
}
