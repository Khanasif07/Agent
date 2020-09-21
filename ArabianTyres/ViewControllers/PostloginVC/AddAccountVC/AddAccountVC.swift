//
//  AddAccountVC.swift
//  ArabianTyres
//
//  Created by Arvind on 14/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

class AddAccountVC: BaseVC {
  
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var helpBtn: UIButton!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var registerBtn: AppButton!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var privacyPolicyLbl: UILabel!
    @IBOutlet weak var iAgreeToLbl: UILabel!
    @IBOutlet weak var andLbl: UILabel!
    @IBOutlet weak var termAndConditionLbl: UILabel!

    // MARK: - Variables
    //===========================
    var bankDetailAdded = false
    var viewModel = GarageRegistrationVM()

    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        viewModel.setGarageRegistration(params: GarageProfileModel.shared.getGarageProfileDict())
    }

     @IBAction func checkBtnAction(_ sender: UIButton) {
        checkBtn.isSelected.toggle()
        registerBtn.isEnabled = checkBtn.isSelected
    }
    
    private func addTabGesture() {
        let termAndConditionTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTermAndConditionTap(_:)))
        termAndConditionLbl.isUserInteractionEnabled = true
        termAndConditionLbl.addGestureRecognizer(termAndConditionTap)
        
        let privacyPolicyTap = UITapGestureRecognizer(target: self, action: #selector(self.handleprivacyPolicyTap(_:)))
        privacyPolicyLbl.isUserInteractionEnabled = true
        privacyPolicyLbl.addGestureRecognizer(privacyPolicyTap)
    }
    
    @objc func handleTermAndConditionTap(_ sender: UITapGestureRecognizer) {
        printDebug("term and condition tap")
    }
    
    @objc func handleprivacyPolicyTap(_ sender: UITapGestureRecognizer) {
        printDebug("privacy policy tap")

    }
    
}

// MARK: - Extension For Functions
//===========================
extension AddAccountVC {
    
    private func initialSetup() {
        viewModel.delegate = self
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.registerCell(with: AddAccountTableViewCell.self)
        mainTableView.registerCell(with: LinkAccountTableViewCell.self)
        registerBtn.isEnabled = false
        setupTextAndFont()
        addTabGesture()
        bankDetailAdded = fillDataStatus()
    }
   
    private func setupTextAndFont(){
        privacyPolicyLbl.font = AppFonts.NunitoSansBold.withSize(12.0)
        andLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        termAndConditionLbl.font = AppFonts.NunitoSansBold.withSize(12.0)
        iAgreeToLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        helpBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(17.0)
        registerBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)

        titleLbl.text = LocalizedString.addAccounts.localized
        helpBtn.setTitle(LocalizedString.help.localized, for: .normal)
        registerBtn.setTitle(LocalizedString.register.localized, for: .normal)
        privacyPolicyLbl.text = LocalizedString.privacyPolicy.localized
        andLbl.text = LocalizedString.and.localized
        termAndConditionLbl.text = LocalizedString.terms_Condition.localized
        iAgreeToLbl.text = LocalizedString.iAgreeTo.localized
    }
}

// MARK: - Extension For TableView
//================================
extension AddAccountVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if bankDetailAdded {
            let cell = tableView.dequeueCell(with: LinkAccountTableViewCell.self, indexPath: indexPath)
            cell.popluateData()
            cell.editBtnTapped = {[weak self] in
                guard let `self` = self else {return}
                AppRouter.goToAddAccountDetailVC(vc: self)
            }
            return cell

        }else {
            let cell = tableView.dequeueCell(with: AddAccountTableViewCell.self, indexPath: indexPath)
            cell.bindData(text: LocalizedString.addBankAccountDetails.localized)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            bankDetailAdded ? () : AppRouter.goToAddAccountDetailVC(vc: self)
    }
}


extension AddAccountVC: BankDetail{
    func BankDetailAdded() {
        bankDetailAdded = true
        registerBtn.isEnabled = checkBtn.isSelected
        mainTableView.reloadData()
    }
}

extension AddAccountVC: GarageRegistrationVMDelegate {
    func garageRegistrationSuccess(msg: String) {
        CommonFunctions.showToastWithMessage(msg)
        AppRouter.goToRegistraionPendingVC(vc: self, screenType: .accept)
    }
    
    func garageRegistrationFailed(msg: String) {
        CommonFunctions.showToastWithMessage(msg)
    }
 
    private func fillDataStatus()-> Bool{
        return !GarageProfileModel.shared.bankName.isEmpty && !GarageProfileModel.shared.accountNumber.isEmpty && !GarageProfileModel.shared.confirmAccountNumber.isEmpty
    }
}
