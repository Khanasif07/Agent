//
//  ChangeLanguageVC.swift
//  Tara
//
//  Created by Arvind on 30/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ChangeLanguageVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var saveBtn: AppButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var englishBtn: UIButton!
    @IBOutlet weak var arabicBtn: UIButton!

    
    // MARK: - Variables
    //===========================
    var currentSelectedLang : AppLanguage{
        let language = AppUserDefaults.value(forKey: .language).intValue
        if let selectedLang = AppLanguage(rawValue: language) {
            return selectedLang
        } else{
            return .english
    
        }
    }
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_sender : Any) {
        pop()
    }

    @IBAction func saveBtnAction(_sender : UIButton) {
        if englishBtn.isSelected {
            AppUserDefaults.save(value: 0, forKey: .language)
        }else {
            AppUserDefaults.save(value: 1, forKey: .language)
            
        }
        setupTextFont()
    }

    @IBAction func englishBtnAction(_sender : UIButton) {
        arabicBtn.isSelected = false
        englishBtn.isSelected.toggle()
    }
    
    @IBAction func arabicBtnAction(_sender : UIButton) {
        englishBtn.isSelected = false
        arabicBtn.isSelected.toggle()
    }
    
    private func setupText(){
        titleLbl.text = LocalizedString.changeLanguage.localized
    }
}

extension ChangeLanguageVC {
   
    private func initialSetup(){
        setupTextFont()
        saveBtn.isEnabled = true
        if currentSelectedLang == .english {
            englishBtnAction(_sender: self.englishBtn)
        } else{
            arabicBtnAction(_sender:  self.arabicBtn)
        }
    }
    
    private func setupTextFont() {
        titleLbl.font = AppFonts.NunitoSansSemiBold.withSize(17.0)
        titleLbl.text = LocalizedString.changeLanguage.localized
        saveBtn.titleLabel?.font = AppFonts.NunitoSansSemiBold.withSize(16.0)
        saveBtn.setTitle(LocalizedString.save.localized, for: .normal)
    }
}

