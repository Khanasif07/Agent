//
//  LoginVC.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import UIKit
import Foundation

class LoginVC: BaseVC {
    
    var viewModel = LoginViewModel()
    
    // MARK: - IBOutlets
    //===========================
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainTableView.reloadData()
    }
    
    // MARK: - IBActions
    //==========================
    
    @IBAction func skipLoginAndContinueAction(_ sender: UIButton) {
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension LoginVC {
    
    private func initialSetup() {
        self.viewModel.delegate = self
        self.tableViewSetUp()
    }
    
    public func tableViewSetUp(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.tableFooterView = footerView
        self.mainTableView.registerCell(with: LoginTopTableCell.self)
        self.mainTableView.registerCell(with: LoginSocialTableCell.self)
        self.mainTableView.registerCell(with: LoginEmailPhoneTableCell.self)
    }
    
    private func getDict() -> JSONDictionary{
        let dict : JSONDictionary = [ApiKey.email : self.viewModel.model.email,
                                     ApiKey.password : self.viewModel.model.password,
                                     ApiKey.device : [ApiKey.platform : "ios", ApiKey.token : DeviceDetail.deviceToken].toJSONString() ?? ""]
        return dict
    }
    
    private func signIn(){
        self.view.endEditing(true)
        if self.viewModel.checkSignInValidations(parameters: getDict()).status{
            self.viewModel.signIn(getDict())
        }else{
            if !self.viewModel.checkSignInValidations(parameters: getDict()).message.isEmpty{
                ToastView.shared.showLongToast(self.view, msg: self.viewModel.checkSignInValidations(parameters: getDict()).message)
            }
        }
    }
}

// MARK: - Extension For TableView
//===========================
extension LoginVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueCell(with: LoginTopTableCell.self, indexPath: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueCell(with: LoginEmailPhoneTableCell.self, indexPath: indexPath)
            cell.emailTxtField.delegate = self
            cell.passTxtField.delegate = self
            cell.signupBtnTapped = { [weak self]  (sender) in
                guard let `self` = self else { return }
                AppRouter.goToSignUpVC(vc: self)
            }
            cell.phoneNoBtnTapped = { [weak self]  (sender) in
                guard let `self` = self else { return }
                AppRouter.goToSignWithPhoneVC(vc: self)
            }
            cell.signInBtnTapped = { [weak self]  (sender) in
                guard let `self` = self else { return }
                self.signIn()
            }
            return cell
        default:
            let cell = tableView.dequeueCell(with: LoginSocialTableCell.self, indexPath: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Extension For TextField Delegate
//=========================================
extension LoginVC : UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        let cell = mainTableView.cell(forItem: textField) as? LoginEmailPhoneTableCell
        switch textField {
        case cell?.emailTxtField:
            self.viewModel.model.email = text
        default:
            self.viewModel.model.password = text
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cell = mainTableView.cell(forItem: textField) as? LoginEmailPhoneTableCell
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        switch textField {
        case cell?.emailTxtField:
            return (string.checkIfValidCharaters(.email) || string.isEmpty) && newString.length <= 50
        case cell?.passTxtField:
            return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 19
        default:
            return false
        }
    }
}

// MARK: - SignInVMDelegate
//=========================================
extension LoginVC: SignInVMDelegate {
    func willSignIn() {
    }
    
    func signInSuccess(userModel: UserModel) {
         ToastView.shared.showLongToast(self.view, msg: "")
    }
    
    func signInFailed(message: String) {
        ToastView.shared.showLongToast(self.view, msg: message)
    }
    
    func invalidInput(message: String) {
    }
}
