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
        
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet var footerView: UIView!
    
    // MARK: - Variables
    //===========================
    var viewModel = LoginViewModel()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        self.mainTableView.reloadData()
    }
    
    // MARK: - IBActions
    //==========================
    
    @IBAction func skipLoginAndContinueAction(_ sender: UIButton) {
//        AppUserDefaults.save(value: "guest", forKey: .currentUserType)
//        AppRouter.goToUserHome()

        AppRouter.goToGarageProfileStep2VC(vc: self)
        
    }
}

// MARK: - Extension For Functions
//===========================
extension LoginVC {
    
    private func initialSetup() {
        self.viewModel.delegate = self
        self.tableViewSetUp()
        if let cell = mainTableView.cellForRow(at: IndexPath(item: 2, section: 0)) as? LoginSocialTableCell{
            AppleLoginController.shared.apploginButton(stackAppleLogin: cell.socialBtnStackView, vc: self)
        }
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
    
    private func getDictForSendOtp() -> JSONDictionary{
        let dict : JSONDictionary = [ApiKey.phoneNo : UserModel.main.phoneNo,
                                     ApiKey.countryCode : UserModel.main.countryCode,
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
    
    private func showEmailVerificationPopUp(){
        self.showAlertWithAction(title: "Verify Email", msg: "A verification link will be send to your email address", cancelTitle: LocalizedString.cancel.localized, actionTitle: LocalizedString.send.localized, actioncompletion: {
           }){self.dismiss(animated: true, completion: nil)}
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
                guard let navController = self.navigationController?.viewControllers else { return }
                for nav in navController {
                    if nav is SignUpVC{
                        self.pop()
                        return
                    }
                }
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
            cell.forgotPassBtnTapped = { [weak self]  (sender) in
            guard let `self` = self else { return }
                AppRouter.goToSignWithPhoneVC(vc: self,loginOption: .forgotPassword)
            }
            return cell
        default:
            return getSocialLoginCell(tableView, indexPath: indexPath)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func getSocialLoginCell(_ tableView: UITableView , indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: LoginSocialTableCell.self, indexPath: indexPath)
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
    
    private func signInBtnStatus()-> Bool{
          return !self.viewModel.model.email.isEmpty && !self.viewModel.model.password.isEmpty
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
            cell?.signInBtn.isEnabled = signInBtnStatus()
        default:
            self.viewModel.model.password = text
            cell?.signInBtn.isEnabled = signInBtnStatus()
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
    
    func signInSuccess(userModel: UserModel) {
         AppRouter.goToUserHome()
    }
    
    func signInFailed(message: String) {
        ToastView.shared.showLongToast(self.view, msg: message)
    }
    
    func emailNotVerified(message: String){
        ToastView.shared.showLongToast(self.view, msg: message)
    }

}

extension LoginVC: AppleSignInProtocal {
    
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
