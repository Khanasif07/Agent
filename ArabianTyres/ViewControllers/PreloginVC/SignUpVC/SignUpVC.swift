//
//  SignUpVC.swift
//  ArabianTyres
//
//  Created by Admin on 04/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

//
//  LoginVC.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import UIKit
import Foundation

class SignUpVC: BaseVC {
    
    var viewModel = SignUpViewModel()
    // MARK: - IBOutlets
    //===========================
    
    @IBOutlet weak var skipSignUpBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet var footerView: UIView!
    
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
    @IBAction func skipLoginAndContinueAction(_ sender: UIButton) {
   }
    
    
}

// MARK: - Extension For Functions
//===========================
extension SignUpVC {
    
    private func initialSetup() {
        self.viewModel.delegate = self
        self.tableViewSetUp()
        self.setUpButton()
    }
    
    public func tableViewSetUp(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.tableHeaderView = headerView
        self.mainTableView.tableFooterView = footerView
        self.mainTableView.registerCell(with: LoginSocialTableCell.self)
        self.mainTableView.registerCell(with: SignUpTopCell.self)
    }
    
    private func setUpButton(){
    self.skipSignUpBtn.setTitle(LocalizedString.skip_signup_continue.localized, for: .normal)
    }
    
    private func getDict() -> JSONDictionary{
        let dict : JSONDictionary = self.viewModel.model.getSignUpModelDict()
        return dict
    }
    
    private func signUp(){
        self.view.endEditing(true)
        if self.viewModel.checkSignupValidations(parameters: getDict()).status{
            self.viewModel.signUp(getDict())
        }else{
            if !self.viewModel.checkSignupValidations(parameters: getDict()).message.isEmpty{
                ToastView.shared.showLongToast(self.view, msg: self.viewModel.checkSignupValidations(parameters: getDict()).message)
            }
        }
    }
}

// MARK: - Extension For TableView
//===========================
extension SignUpVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueCell(with: SignUpTopCell.self, indexPath: indexPath)
            [cell.nameTxtField,cell.emailIdTxtField,cell.mobNoTxtField,cell.passTxtField,cell.confirmPassTxtField].forEach({$0?.delegate = self})
            cell.signInBtnTapped = { [weak self]  (sender) in
                guard let `self` = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            cell.signUpBtnTapped = { [weak self]  (sender) in
                guard let `self` = self else { return }
                self.signUp()
            }
            cell.countryPickerTapped = { [weak self]  (sender) in
                guard let `self` = self else { return }
                AppRouter.showCountryVC(vc: self)
            }
            return cell
        default:
            let cell = tableView.dequeueCell(with: LoginSocialTableCell.self, indexPath: indexPath)
            cell.loginSocialLbl.text = LocalizedString.signup_with_social_accounts.localized
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Extension For TextField Delegate
//====================================
extension SignUpVC : UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        let cell = mainTableView.cell(forItem: textField) as? SignUpTopCell
        switch textField {
        case cell?.emailIdTxtField:
            self.viewModel.model.email = text
        case cell?.nameTxtField:
            self.viewModel.model.name = text
        case cell?.mobNoTxtField:
            self.viewModel.model.phoneNo = text
        case cell?.passTxtField:
            self.viewModel.model.password = text
        default:
            self.viewModel.model.confirmPasssword = text
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cell = mainTableView.cell(forItem: textField) as? SignUpTopCell
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        switch textField {
        case cell?.nameTxtField:
            return (string.checkIfValidCharaters(.name) || string.isEmpty) && newString.length <= 50
        case cell?.mobNoTxtField:
            return (string.checkIfValidCharaters(.mobileNumber) || string.isEmpty) && newString.length <= 16
        case cell?.emailIdTxtField:
            return (string.checkIfValidCharaters(.email) || string.isEmpty) && newString.length <= 50
        case cell?.passTxtField:
            return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 19
        case cell?.confirmPassTxtField:
            return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 19
        default:
            return false
        }
    }
}


// MARK: - CountryDelegate
//=========================
extension SignUpVC : CountryDelegate{
    func sendCountryCode(code: String) {
        let cell = mainTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SignUpTopCell
        self.viewModel.model.countryCode = code
        cell?.countryCodeLbl.text = code
    }
}

// MARK: - CountryDelegate
//=========================
extension SignUpVC: SignUpVMDelegate{
    func willSignUp() {
        
    }
    
    func signUpSuccess(message: String) {
        ToastView.shared.showLongToast(self.view, msg: message)
        AppRouter.goToOtpVerificationVC(vc: self, phoneNo: self.viewModel.model.phoneNo, countryCode: self.viewModel.model.countryCode)
    }
    
    func signUpFailed(message: String) {
        ToastView.shared.showLongToast(self.view, msg: message)
    }
    
    func invalidInput(message: String) {
        
    }
}
