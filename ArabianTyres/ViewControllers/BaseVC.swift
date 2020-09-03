//
//   Do any additional setup after loading the view.         self.navigationController?.navigationBar.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class BaseVC: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.toolbarTintColor = .white
        self.navigationController?.navigationBar.isHidden = true
    }
}
