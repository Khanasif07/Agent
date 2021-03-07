//
//  ReportPopupVC.swift
//  Tara
//
//  Created by Arvind on 11/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

protocol PickerDataDelegate {
    func selectedReason(str: String)
    func changeCarReceivedStatus()
    func updateRatingStatus()
}

extension PickerDataDelegate {
    func selectedReason(str: String){}
    func changeCarReceivedStatus(){}
    func updateRatingStatus(){}
}


class ReportPopupVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var doneBtn: UIButton!

    // MARK: - Variables
    //=================
      
    var dataArr : [String] = [LocalizedString.notSatisfying.localized,
                              LocalizedString.threatsOfVoilance.localized,
                              LocalizedString.defamation.localized,
                              LocalizedString.obscenity.localized,
                              LocalizedString.inappropriateReview.localized]
    
    var pickerSelectedValue : String = ""
    var delegate :PickerDataDelegate?
    
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
        
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func cancelBtnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        dismiss(animated: true) {
            if self.pickerSelectedValue.isEmpty {
                self.pickerSelectedValue = self.dataArr[0]
            }
            self.delegate?.selectedReason(str: self.pickerSelectedValue)
        }
    }
}

extension ReportPopupVC :UIPickerViewDelegate, UIPickerViewDataSource{
    
    func initialSetup() {
        pickerView.delegate = self
        pickerView.dataSource = self
        setupText()
    }
    
    func setupText() {
        doneBtn.setTitle(LocalizedString.done.localized, for: .normal)
        titleLbl.text = LocalizedString.reasonOfReport.localized
      
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataArr[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerSelectedValue = dataArr[row] as String
    }
}
