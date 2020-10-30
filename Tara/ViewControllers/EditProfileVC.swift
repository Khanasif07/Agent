//
//  EditProfileVC.swift
//  Tara
//
//  Created by Arvind on 30/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class EditProfileVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var mobileNoTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var editImgBtn: UIButton!
    @IBOutlet weak var saveBtn: AppButton!

    
    // MARK: - Variables
    //===========================
 
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_sender : UIButton) {
        pop()
    }
    
    @IBAction func saveBtnAction(_sender : UIButton) {
        
    }
    
    @IBAction func editBtnAction(_sender : UIButton) {
        
    }
    
}

extension EditProfileVC {
   
    private func initialSetup(){
        
    }
}
