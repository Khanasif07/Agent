//
//  AddAccountVC.swift
//  ArabianTyres
//
//  Created by Arvind on 14/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

class AddAccountVC: BaseVC {
   
    enum PaymentDetail {
        case bankDetail
        case cardDetail
    }
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var helpBtn: UIButton!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var registerBtnAction: UIButton!

    
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
    }
  
    override func viewDidLayoutSubviews() {
       
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func helpBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func registerBtnAction(_ sender: UIButton) {
        self.pop()
    }

    
    func changeBtnState(isHide: Bool){
        registerBtnAction.backgroundColor = isHide ? AppColors.primaryBlueLightShade : AppColors.primaryBlueColor
        registerBtnAction.setTitleColor(isHide ? AppColors.fontTertiaryColor : AppColors.backgrougnColor2, for: .normal)
        registerBtnAction.isUserInteractionEnabled = !isHide
    }
}

// MARK: - Extension For Functions
//===========================
extension AddAccountVC {
    
    private func initialSetup() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.registerCell(with: AddAccountTableViewCell.self)
        setupTextAndFont()
        
    }
   
    private func setupTextAndFont(){
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        helpBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(17.0)
        registerBtnAction.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)

        titleLbl.text = LocalizedString.addAccounts.localized
        helpBtn.setTitle(LocalizedString.help.localized, for: .normal)
        registerBtnAction.setTitle(LocalizedString.saveContinue.localized, for: .normal)

    }
}

// MARK: - Extension For TableView
//===========================
extension AddAccountVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: AddAccountTableViewCell.self, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
