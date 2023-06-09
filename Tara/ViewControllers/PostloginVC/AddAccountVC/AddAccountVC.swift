//
//  AddAccountVC.swift
//  ArabianTyres
//
//  Created by Arvind on 14/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

class AddAccountVC: BaseVC {
  
    enum ScreenType {
        case garageProfile
        case garageRegistration
    }
    
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
    @IBOutlet weak var lblContainerView: UIStackView!
    @IBOutlet weak var privacyPolicyBottomView: UIView!
    @IBOutlet weak var termAndConditionBottomView: UIView!

    // MARK: - Variables
    //===========================
    var bankDetailAdded = false
    var viewModel = GarageRegistrationVM()
    var screenType : ScreenType = .garageRegistration

    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setPreFillData()
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
        AppRouter.goToOneToOneChatVC(self, userId: AppConstants.adminId, requestId: "", name: LocalizedString.supportChat.localized, image: "", unreadMsgs: 0, isSupportChat: true,garageUserId: isCurrentUserType == .garage ? UserModel.main.id : AppConstants.adminId )
    }
    
    @IBAction func registerBtnAction(_ sender: UIButton) {
        if screenType == .garageRegistration {
            viewModel.setGarageRegistration(params: GarageProfileModel.shared.getGarageProfileDict())
        }else {
            viewModel.garageProfile(params: GarageProfileModel.shared.getCompleteProfileDict())
        }
    }

     @IBAction func checkBtnAction(_ sender: UIButton) {
        checkBtn.isSelected.toggle()
        registerBtn.isEnabled = checkBtn.isSelected && bankDetailAdded
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
    
    func setPreFillData() {
        if screenType == .garageProfile {
            bankDetailAdded = true
            registerBtn.isEnabled = true
            mainTableView.reloadData()
        }
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
        if screenType == .garageRegistration {
            titleLbl.text = LocalizedString.addAccounts.localized
            registerBtn.setTitle(LocalizedString.register.localized, for: .normal)
            helpBtn.setTitle(LocalizedString.help.localized, for: .normal)

        }else {
            privacyPolicyBottomView.isHidden = true
            termAndConditionBottomView.isHidden = true
            checkBtn.isHidden = true
            lblContainerView.isHidden = true
            
            titleLbl.text = fromGarage == .editGarageProfile ? "Edit Profile" : LocalizedString.completeProfile.localized
            registerBtn.setTitle(LocalizedString.submit.localized, for: .normal)
            helpBtn.setTitle(nil, for: .normal) 
            helpBtn.setImage(#imageLiteral(resourceName: "group3887"), for: .normal)
        }
        privacyPolicyLbl.font = AppFonts.NunitoSansBold.withSize(12.0)
        andLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        termAndConditionLbl.font = AppFonts.NunitoSansBold.withSize(12.0)
        iAgreeToLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        helpBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        registerBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)

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
                AppRouter.goToAddAccountDetailVC(vc: self, screenType: self.screenType)
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
        bankDetailAdded ? () : AppRouter.goToAddAccountDetailVC(vc: self, screenType: screenType)
    }
}


extension AddAccountVC: BankDetail{
    func BankDetailAdded() {
        bankDetailAdded = true
        registerBtn.isEnabled = screenType == .garageProfile ? true : checkBtn.isSelected
        mainTableView.reloadData()
    }
}

extension AddAccountVC: GarageRegistrationVMDelegate {
    
    func garageRegistrationSuccess(msg: String) {
        AppRouter.goToRegistraionPendingVC(vc: self, screenType: .pending, msg: "", reason: [""], time: "Just now")
    }
    
    func garageRegistrationFailed(msg: String) {
        CommonFunctions.showToastWithMessage(msg)
    }
 
    private func fillDataStatus()-> Bool{
        return !GarageProfileModel.shared.bankName.isEmpty && !GarageProfileModel.shared.accountNumber.isEmpty && !GarageProfileModel.shared.confirmAccountNumber.isEmpty
    }
    
    func completeProfileSuccess(msg: String){
        if fromGarage == .editGarageProfile {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: GarageProfileVC.self) {
                    guard let vc = controller as? GarageProfileVC else {return}
                    vc.hitProfileApi()
                    _ =  self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        else {
            AppUserDefaults.save(value: "2", forKey: .currentUserType)
            AppRouter.goToGarageHome()
        }
    }
    
    func completeProfileFailure(msg: String){
         CommonFunctions.showToastWithMessage(msg)
    }
}
