//
//  GarageRegistrationVC.swift
//  ArabianTyres
//
//  Created by Arvind on 10/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

class GarageRegistrationVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var startRegistraionBtn: AppButton!
    @IBOutlet weak var headingLbl: UILabel!

    
    // MARK: - Variables
    //===========================
   
    var headingArr = [LocalizedString.garageLogo.localized,
                      LocalizedString.authorisedNameOfServiceCenter.localized,
                      LocalizedString.locationOfYourServiceCenter.localized,
                      LocalizedString.imagesOfyourServiceCenter.localized,
                      LocalizedString.govtIssuedlicensesandDocuments.localized
                     ]
  
    var subHeading = [LocalizedString.garageLogoDesc.localized,
                      LocalizedString.authorisedNameOfServiceCenterDesc.localized,
                      LocalizedString.locationOfYourServiceCenterDesc.localized,
                      LocalizedString.imagesOfyourServiceCenterDesc.localized,
                      LocalizedString.govtIssuedlicensesandDocumentsDesc.localized
    ]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.mainTableView.reloadData()
    }
    
    // MARK: - IBActions
    //===========================
    
    
    @IBAction func startRegistraionAction(_ sender: UIButton) {
        AppRouter.goToAddDetailVC(vc: self)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
}

// MARK: - Extension For Functions
//===========================
extension GarageRegistrationVC {
    
    private func initialSetup() {
        self.tableViewSetUp()
        setupTextAndFont()
        GarageProfileModel.shared = GarageProfileModel()
    }
    
    private func tableViewSetUp(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
    }
    
    private func setupTextAndFont(){
        startRegistraionBtn.isEnabled = true
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        startRegistraionBtn.titleLabel?.font =  AppFonts.NunitoSansBold.withSize(16.0)
        headingLbl.font =  AppFonts.NunitoSansBold.withSize(21.0)
        
        titleLbl.text = LocalizedString.garageRegistration.localized
        startRegistraionBtn.setTitle(LocalizedString.startRegistration.localized, for: .normal)
        headingLbl.text = LocalizedString.requirementToRegister.localized

    }
    
}

// MARK: - Extension For TableView
//===========================
extension GarageRegistrationVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: GarageRegistrationDetailCell.self, indexPath: indexPath)
        cell.populateData(heading: headingArr[indexPath.row], subHeading: subHeading[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


