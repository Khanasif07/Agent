//
//  LoginVC.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import UIKit

class LoginVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet var footerView: UIView!
    
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
    @IBAction func skipLoginAndContinueAction(_ sender: UIButton) {
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension LoginVC {
    
    private func initialSetup() {
        self.tableViewSetUp()
    }
    
    public func tableViewSetUp(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.tableFooterView = footerView
        self.mainTableView.registerCell(with: LoginTopTableCell.self)
        self.mainTableView.registerCell(with: LoginSocialTableCell.self)
        self.mainTableView.registerCell(with: LoginEmailPhoneTableCell.self)
    }
}

// MARK: - Extension For TableView
//===========================
extension LoginVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueCell(with: LoginTopTableCell.self, indexPath: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueCell(with: LoginEmailPhoneTableCell.self, indexPath: indexPath)
            return cell
        default:
            let cell = tableView.dequeueCell(with: LoginSocialTableCell.self, indexPath: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
