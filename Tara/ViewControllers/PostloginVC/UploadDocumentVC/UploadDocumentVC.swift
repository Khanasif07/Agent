//
//  UploadDocumentVC.swift
//  ArabianTyres
//
//  Created by Arvind on 12/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class UploadDocumentVC: BaseVC {
   
    enum Section :CaseIterable{
       
        case commericalRegister
        case vatCertificate
        case municipalityLicense
        case ownerId
        
        var text : String{
            switch self {
                
            case .commericalRegister:
                return LocalizedString.commercialRegister.localized
            case .vatCertificate:
                return LocalizedString.vatCertificate.localized
            case .municipalityLicense:
                return LocalizedString.municipalityLicense.localized
            case .ownerId:
                return LocalizedString.idOfTheOwner.localized
         
            }
        }
        
        var imgArr: [ImageModel] {
            switch self {
            case .commericalRegister:
                return GarageProfileModel.shared.commercialRegister
            case .vatCertificate:
                return GarageProfileModel.shared.vatCertificate
            case .municipalityLicense:
                return GarageProfileModel.shared.municipalityLicense
            case .ownerId:
                return GarageProfileModel.shared.ownerId
            }
        }
    }

    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var saveAndContinueBtn: AppButton!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var helpBtn: UIButton!

    // MARK: - Variables
    //===========================
    var sectionType : Section = .commericalRegister
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        saveAndContinueBtn.isEnabled = false
    }

    // MARK: - IBActions
    //===========================
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func saveAndContinueBtnAction(_ sender: UIButton) {
        AppRouter.goToAddAccountVC(vc: self, screenType: .garageRegistration)
    }
    
    @IBAction func helpBtnAction(_ sender: UIButton) {
        AppRouter.goToOneToOneChatVC(self, userId: AppConstants.adminId, requestId: "", name: LocalizedString.supportChat.localized, image: "", unreadMsgs: 0, isSupportChat: true,garageUserId: isCurrentUserType == .garage ? UserModel.main.id : "" )
    }
}

// MARK: - Extension For Functions
//===========================
extension UploadDocumentVC {
    
    private func initialSetup() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        setupTextFont()
    }
    
    private func setupTextFont() {
        headingLbl.text = LocalizedString.addFollowingGovtIssuedLicenceOrDocumentsHereForVerification.localized
        headingLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        titleLbl.font = AppFonts.NunitoSansBold.withSize(17.0)
        saveAndContinueBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(16.0)
        helpBtn.titleLabel?.font =  AppFonts.NunitoSansSemiBold.withSize(17.0)

        titleLbl.text = LocalizedString.govtIssuedDoc.localized
        saveAndContinueBtn.setTitle(LocalizedString.saveContinue.localized, for: .normal)
        helpBtn.setTitle(LocalizedString.help.localized, for: .normal)
        
    }
    
}


// MARK: - Extension For TableView
//===========================
extension UploadDocumentVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section.allCases.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: DocumentTableViewCell.self, indexPath: indexPath)
        let section = Section.allCases[indexPath.row]
        cell.bindData(section: section)
        
        cell.cancelBtnTapped = {[weak self] in
            guard let `self` = self else { return }
            self.removeImg(indexPath: indexPath.row,isFirstImg : true)
        }
        
        cell.uploadCancelBtnTapped = {[weak self] in
            guard let `self` = self else { return }
            self.removeImg(indexPath: indexPath.row,isFirstImg : false)
        }
        
        cell.uploadDoc = {[weak self] in
            guard let `self` = self else { return }
            self.sectionType = Section.allCases[indexPath.row]
            if let _ = self.sectionType.imgArr.firstIndex(where: { (model) -> Bool in
                return model.type != "pdf"
            }) {
                self.captureImage(delegate: self)
            }else{
                self.captureImage(delegate: self,docPickDelegate: self, isDocumentPick: true)
                
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func removeImg(indexPath: Int,isFirstImg : Bool) {
      
        switch  Section.allCases[indexPath] {
            
        case .commericalRegister:
            GarageProfileModel.shared.commercialRegister.remove(at: isFirstImg ? 0 : 1)
        case .vatCertificate:
            GarageProfileModel.shared.vatCertificate.remove(at: isFirstImg ? 0 : 1)
        case .municipalityLicense:
            GarageProfileModel.shared.municipalityLicense.remove(at: isFirstImg ? 0 : 1)
        case .ownerId:
            GarageProfileModel.shared.ownerId.remove(at: isFirstImg ? 0 : 1)
        }
        var status : Bool = false
        for section in Section.allCases  {
            if section.imgArr.count == 0 {
                status = false
                break
            }else {
                 status = true
                
            }
        }
        saveAndContinueBtn.isEnabled = status
        mainTableView.reloadData()
    }
}

extension UploadDocumentVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, RemovePictureDelegate {
    func removepicture() {
    }
     
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        CommonFunctions.showActivityLoader()
    
        image?.upload(progress: { (progress) in
            printDebug(progress)
        }, completion: { (response,error) in
            if let url = response {
                CommonFunctions.hideActivityLoader()
                self.saveImage(imgUrl: url, type: "image")
            }
            if let _ = error{
                self.showAlert(msg: "Image upload failed")
            }
        })
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func saveImage(imgUrl: String, type: String) {
        let imgModel = ImageModel(url: imgUrl, type: type)
        switch sectionType {
        case .commericalRegister:
            GarageProfileModel.shared.commercialRegister.append(imgModel)
        case .vatCertificate:
            GarageProfileModel.shared.vatCertificate.append(imgModel)
        case .municipalityLicense:
            GarageProfileModel.shared.municipalityLicense.append(imgModel)
        case .ownerId:
            GarageProfileModel.shared.ownerId.append(imgModel)
        }
        var status : Bool = false
        for section in Section.allCases  {
            if section.imgArr.count == 0 {
                status = false
                break
            }else {
                 status = true
                
            }
            
        }
        saveAndContinueBtn.isEnabled = status
        mainTableView.reloadData()
    }
}

extension UploadDocumentVC: UIDocumentPickerDelegate{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let myURL = urls.first else {
            return
        }
        CommonFunctions.showActivityLoader()
        AWSS3Manager.shared.uploadOtherFile(fileUrl: myURL, conentType: "pdf", progress: { (progress) in
            printDebug(progress)
            
        },  completion: { (response,error) in
            if let url = response {

                CommonFunctions.hideActivityLoader()
                self.saveImage(imgUrl: url, type: "pdf")
            }
            if let _ = error{
                self.showAlert(msg: "doc upload failed")
            }
        })
        print("import result : \(myURL)")
    }
}


