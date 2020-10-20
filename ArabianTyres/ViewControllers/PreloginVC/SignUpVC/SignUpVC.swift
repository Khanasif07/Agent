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
    
    // MARK: - IBOutlets
    //===========================
    
    @IBOutlet weak var skipSignUpBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet var footerView: UIView!
    
    // MARK: - Variables
    //===========================
    var viewModel = SignUpViewModel()

    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .lightContent
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func skipLoginAndContinueAction(_ sender: UIButton) {
        AppUserDefaults.save(value: "guest", forKey: .currentUserType)
        AppRouter.goToUserHome()
   }
    
    
}

// MARK: - Extension For Functions
//===========================
extension SignUpVC {
    
    private func initialSetup() {
        self.viewModel.delegate = self
        self.tableViewSetUp()
        self.setUpButton()
        AppleLoginController.shared.delegate = self
        if let cell = mainTableView.cellForRow(at: IndexPath(item: 1, section: 0)) as? LoginSocialTableCell{
            AppleLoginController.shared.apploginButton(stackAppleLogin: cell.socialBtnStackView, vc: self)
        }
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
    
    private func signUpBtnStatus()-> Bool{
        return !self.viewModel.model.name.isEmpty && !self.viewModel.model.email.isEmpty && !self.viewModel.model.phoneNo.isEmpty && !self.viewModel.model.password.isEmpty && !self.viewModel.model.confirmPasssword.isEmpty
    }
    
    private func getDictForSendOtp() -> JSONDictionary{
     let dict : JSONDictionary = [ApiKey.phoneNo : UserModel.main.phoneNo,
                                  ApiKey.countryCode : UserModel.main.countryCode,
                                     ApiKey.device : [ApiKey.platform : "ios", ApiKey.token : DeviceDetail.deviceToken].toJSONString() ?? ""]
        return dict
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
                guard let navController = self.navigationController?.viewControllers else { return }
                for nav in navController {
                    if nav is LoginVC{
                        self.pop()
                        return
                    }
                }
                AppRouter.goToLoginVC(vc: self)
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
            cell.googleBtnTapped = {[weak self] in
                guard let self = `self` else { return }
                GoogleLoginController.shared.login(fromViewController: self, success: { [weak self] (model) in
                    guard let _ = self else {return}
                    printDebug(model)
                    self?.hitSocialLoginAPI(name: model.name, email: model.email, socialId: model.id, socialType: "google", phoneNo: "", profilePicture: model.image?.description ?? "")
                }) { (error) in
                    printDebug(error.localizedDescription)
                }
            }
            
            cell.fbBtnTapped = { [weak self] in
                guard let self = `self` else { return }
                FacebookController.shared.getFacebookUserInfo(fromViewController: self, isSilentLogin: false, success: { [weak self] (model) in
                    guard let _ = self else {return}
                    printDebug(model)
                    self?.hitSocialLoginAPI(name: model.name, email: model.email, socialId: model.id, socialType: "facebook", phoneNo: "", profilePicture: model.picture?.description ?? "")
                    }, failure: { (error) in
                        printDebug(error?.localizedDescription.description)
                })

            }

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
            cell?.signUpBtn.isEnabled = signUpBtnStatus()
        case cell?.nameTxtField:
            self.viewModel.model.name = text
            cell?.signUpBtn.isEnabled = signUpBtnStatus()
        case cell?.mobNoTxtField:
            self.viewModel.model.phoneNo = text
            cell?.signUpBtn.isEnabled = signUpBtnStatus()
        case cell?.passTxtField:
            self.viewModel.model.password = text
            cell?.signUpBtn.isEnabled = signUpBtnStatus()
        default:
            self.viewModel.model.confirmPasssword = text
            cell?.signUpBtn.isEnabled = signUpBtnStatus()
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
            return (string.checkIfValidCharaters(.mobileNumber) || string.isEmpty) && newString.length <= 10
        case cell?.emailIdTxtField:
            return (string.checkIfValidCharaters(.email) || string.isEmpty) && newString.length <= 50
        case cell?.passTxtField:
            return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 25
        case cell?.confirmPassTxtField:
            return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 25
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
    func sendOtpForSocialLoginSuccess(message: String) {
        AppRouter.goToOtpVerificationVC(vc: self, phoneNo: UserModel.main.phoneNo, countryCode: UserModel.main.countryCode)
    }
    
    func sendOtpForSocialLoginFailed(message: String) {
         ToastView.shared.showLongToast(self.view, msg: message)
    }
    
    func socailLoginApiSuccessWithoutPhoneNo(message: String) {
        AppRouter.goToSignWithPhoneVC(vc: self,loginOption: .socialUser)
    }
    
    func socailLoginApiSuccessWithoutVerifyPhoneNo(message: String) {
        self.viewModel.sendOtp(params: getDictForSendOtp())
    }
    
    func socailLoginApiSuccess(message: String) {
        AppRouter.goToUserHome()
    }
    
    func socailLoginApiFailure(message: String) {
        ToastView.shared.showLongToast(self.view, msg: message)
    }
    
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


extension SignUpVC: AppleSignInProtocal {
    func getAppleLoginData(loginData: JSONDictionary) {
        self.hitSocialLoginAPI(name: loginData[ApiKey.name] as? String ?? "", email: loginData[ApiKey.email] as? String ?? "" , socialId: loginData[ApiKey.socialId] as? String ?? "", socialType: "apple", phoneNo: "", profilePicture: "")
    }
    
    func getSocialParams(name : String , email : String , socialId : String , socialType : String ,phoneNo: String ,profilePicture : String) -> JSONDictionary{
        
        let dict : JSONDictionary = [ApiKey.socialType: socialType,
                                     ApiKey.socialId: socialId,
                                     ApiKey.name: name,
                                     ApiKey.email: email ,
                                     ApiKey.phoneNo: phoneNo,
                                     ApiKey.image: profilePicture,
                                     ApiKey.countryCode : "",
                                     ApiKey.device : [ApiKey.platform: "ios", ApiKey.token: DeviceDetail.deviceToken].toJSONString() ?? ""]
        return dict
    }

    func hitSocialLoginAPI(name : String , email : String , socialId : String , socialType : String ,phoneNo: String, profilePicture : String){
         viewModel.socailLoginApi(parameters: getSocialParams(name : name , email : email , socialId : socialId , socialType : socialType ,phoneNo: phoneNo ,profilePicture : profilePicture))
        
     }
}
