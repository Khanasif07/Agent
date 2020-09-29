//
//  RegistraionPendingVC.swift
//  ArabianTyres
//
//  Created by Arvind on 11/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit



class RegistraionPendingVC: BaseVC {
    
    enum ScreenType {
        case pending
        case rejected
        case accept
    }
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var subHeadingLbl: UILabel!
    @IBOutlet weak var completeProfileBtn: UIButton!
    @IBOutlet weak var viewTutorailBtn: UIButton!

    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var mobileNotVerifyLbl: UILabel!
    @IBOutlet weak var inappropriateLbl: UILabel!
    @IBOutlet weak var bottomStackView: UIStackView!

    // MARK: - Variables
    //===========================
    var screenType : ScreenType = .pending
    var message: String = ""
    var reason : String = ""
    var time :  String = ""
    var registerBtnTapped:(()->())?
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

   
    // MARK: - IBActions
    //===========================
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        switch screenType {
        case .pending:
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: ProfileSettingVC.self) {
                    _ =  self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        case .rejected:
            self.pop()
        case .accept:
            self.pop()
        }
        
    }
    
    @IBAction func completeProfileBtnAction(_ sender: UIButton) {
        switch screenType {
        case .pending:
            break
        case .rejected:
            self.pop(animated: false)
            registerBtnTapped?()
        case .accept:
            AppRouter.goToCompleteProfileStep1VC(vc: self)
        }
    }
    
    @IBAction func viewTutorailBtnAction(_ sender: UIButton) {
 
      }
}

// MARK: - Extension For Functions
//===========================
extension RegistraionPendingVC {
    
    private func initialSetup() {
        setupTextAndFont()
        switch screenType {
            
        case .pending:
            viewTutorailBtn.isHidden = true
            bottomStackView.isHidden = true
            completeProfileBtn.isHidden = true
            subHeadingLbl.text = LocalizedString.yourRegistrationRequestIsStillUnder.localized
            imgView.image = #imageLiteral(resourceName: "group3874")
            let date = time.toDate(dateFormat: Date.DateFormat.givenDateFormat.rawValue) ?? Date()
            if time == "Just now" {
                headingLbl.text = "We’ve received your registration request Just now"
            }else {
                headingLbl.text = "We’ve received your registration request \(date.timeAgoSince)."
            }

        case .rejected:
            viewTutorailBtn.isHidden = true
            bottomStackView.isHidden = false
            let date = (time).breakCompletDate(outPutFormat: Date.DateFormat.profileFormat.rawValue, inputFormat: Date.DateFormat.yyyyMMddTHHmmsssssz.rawValue)
             headingLbl.text = "Your Registration Request\nmade on \(date) has been Rejected\ndue to following reasons: "
            emailLbl.text = reason
            subHeadingLbl.isHidden = true
            completeProfileBtn.isHidden = false
            completeProfileBtn.setTitle(LocalizedString.registerAgain.localized, for: .normal)
            imgView.image = #imageLiteral(resourceName: "group3873")

        case .accept:
            viewTutorailBtn.isHidden = false
            bottomStackView.isHidden = true
            subHeadingLbl.isHidden = true
            completeProfileBtn.isHidden = false
            let date = (time).breakCompletDate(outPutFormat: Date.DateFormat.profileFormat.rawValue, inputFormat: Date.DateFormat.yyyyMMddTHHmmsssssz.rawValue)
           
            headingLbl.text = "Your Registration Request\nmade on \(date) has been Accepted.\nKindly complete your profile"
//            headingLbl.text = LocalizedString.yourRegRequestHasBeenAccepted.localized
            completeProfileBtn.setTitle(LocalizedString.completeProfile.localized, for: .normal)
            imgView.image = #imageLiteral(resourceName: "group3875")

        }
        mobileNotVerifyLbl.isHidden = true
        inappropriateLbl.isHidden = true

    
//        headingLbl.text = message
    }

    private func setupTextAndFont(){
        nameLbl.text = "Hi! " + UserModel.main.name
        nameLbl.font = AppFonts.NunitoSansBold.withSize(21.0)
        headingLbl.font = AppFonts.NunitoSansRegular.withSize(15.0)
        subHeadingLbl.font = AppFonts.NunitoSansRegular.withSize(15.0)
        
        emailLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        mobileNotVerifyLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        inappropriateLbl.font = AppFonts.NunitoSansBold.withSize(14.0)

        viewTutorailBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        viewTutorailBtn.setTitle(LocalizedString.viewTutorial.localized, for: .normal)
        completeProfileBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        completeProfileBtn.setTitle(LocalizedString.saveContinue.localized, for: .normal)

    }
    
}

