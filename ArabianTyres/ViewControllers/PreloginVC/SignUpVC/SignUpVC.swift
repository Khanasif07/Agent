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
            cell.confirmPassTxtField.delegate = self
            cell.passTxtField.delegate = self
            cell.emailIdTxtField.delegate = self
            cell.mobNoTxtField.delegate = self
            cell.signInBtnTapped = { [weak self]  (sender) in
                guard let `self` = self else { return }
                self.navigationController?.popViewController(animated: true)
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
            self.viewModel.model.password = text
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && (string == " ") {
            return false
        }
        return true
    }
}
