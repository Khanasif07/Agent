//
//  UserChatVC.swift
//  ArabianTyres
//
//  Created by Admin on 27/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class UserChatVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var searchTextField: ATCTextField!
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
    
    
}

// MARK: - Extension For Functions
//===========================
extension UserChatVC {
    
    private func initialSetup() {
        
    }
}

// MARK: - Extension For TableView
//===========================
extension UserChatVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
