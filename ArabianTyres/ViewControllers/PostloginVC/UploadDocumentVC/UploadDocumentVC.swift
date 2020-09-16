//
//  UploadDocumentVC.swift
//  ArabianTyres
//
//  Created by Arvind on 12/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class UploadDocumentVC: BaseVC {
   
    enum Section :CaseIterable{
        case commericalRegister
        case vatCertificate
        case municipalityLicense
        case ownerId
        
        var text : String{
            switch self {
                
            case .commericalRegister:
                return LocalizedString.commercialRegister.localized
            case .vatCertificate:
                return LocalizedString.vatCertificate.localized
            case .municipalityLicense:
                return LocalizedString.municipalityLicense.localized
            case .ownerId:
                return LocalizedString.idOfTheOwner.localized
         
            }
        }
    }
    
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var saveAndContinueBtn: UIButton!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var helpBtn: UIButton!



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
    
    @IBAction func saveAndContinueBtnAction(_ sender: UIButton) {
      print("save and Continue btn tapped")
    }
    
    @IBAction func helpBtnAction(_ sender: UIButton) {
        print("help btn tapped")

    }
}

// MARK: - Extension For Functions
//===========================
extension UploadDocumentVC {
    
    private func initialSetup() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        setupTextFont()
    }
    
    private func setupTextFont() {
        headingLbl.text = LocalizedString.addFollowingGovtIssuedLicenceOrDocumentsHereForVerification.localized
        headingLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        saveAndContinueBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        helpBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(17.0)

        titleLbl.text = LocalizedString.govtIssuedDoc.localized
        saveAndContinueBtn.setTitle(LocalizedString.saveContinue.localized, for: .normal)
        helpBtn.setTitle(LocalizedString.help.localized, for: .normal)
        
    }
    
}


// MARK: - Extension For TableView
//===========================
extension UploadDocumentVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section.allCases.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: DocumentTableViewCell.self, indexPath: indexPath)
        cell.bindData(text: Section.allCases[indexPath.row].text)
        cell.cancelBtnTapped = {[weak self] in
            guard let `self` = self else { return }
            cell.cancelBtn.isHidden = true
            cell.docImgView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}