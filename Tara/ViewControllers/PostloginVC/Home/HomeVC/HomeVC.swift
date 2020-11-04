//
//  HomeVC.swift
//  ArabianTyres
//
//  Created by Admin on 08/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

struct DataValue{
    var image:UIImage
    var name:String
    var productColor: UIColor
    
    init(image:UIImage,name:String,productColor: UIColor) {
        self.image = image
        self.name = name
        self.productColor = productColor
    }
}


class HomeVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var mainCollView: UICollectionView!
    
    // MARK: - Variables
    //===========================
    var viewModel = LocationPopUpVM()
    var dataArray:[DataValue] = []
    
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
        self.tabBarController?.tabBar.isHidden = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainCollView.reloadData()
    }
    // MARK: - IBActions
    //===========================
    
    
}

// MARK: - Extension For Functions
//===========================
extension HomeVC {
    
    private func initialSetup() {
        viewModel.delegate = self
        self.dataSetUp()
        self.collectionViewSetUp()
        self.isComeFromGuestUser()
    }
    
    private func dataSetUp(){
        if isUserLoggedin{
            self.userNameLbl.text = "Hi, " + "\(UserModel.main.name)"
        } else {
             self.userNameLbl.text = "Hi, User"
        }
        self.dataArray = [DataValue(image: #imageLiteral(resourceName: "maskGroup"), name: LocalizedString.tyre.localized,productColor: UIColor(r: 230, g: 240, b: 245, alpha: 1.0)),
                     DataValue(image: #imageLiteral(resourceName: "oil"), name: LocalizedString.oil.localized,productColor: UIColor(r: 233 , g: 235, b: 239, alpha: 1.0)),
                     DataValue(image: #imageLiteral(resourceName: "battery"), name: LocalizedString.battery.localized,productColor: UIColor(r: 253, g: 237, b: 223, alpha: 1.0))]
    }
    
    private func collectionViewSetUp(){
        mainCollView.delegate = self
        mainCollView.dataSource = self
        mainCollView.registerCell(with: HomeCollectionCell.self)
    }
    
    public func isComeFromGuestUser(){
        if !TyreRequestModel.shared.quantity.isEmpty {
            if !UserModel.main.phoneNoAdded && isUserLoggedin {
                self.showAlertWithAction(title: "", msg: "To continue performing this action, please complete your profile", cancelTitle: "Cancel", actionTitle: LocalizedString.ok.localized, actioncompletion: {
                    AppRouter.goToEditProfileVC(vc: self, model: UserModel.main, isEditProfileFrom: .home)
                })
                return
            }
            switch categoryType {
            case .tyres:
                self.viewModel.postTyreRequest(dict: TyreRequestModel.shared.getTyreRequestDict())
            case .battery:
                self.viewModel.postBatteryRequest(dict: TyreRequestModel.shared.getBatteryRequestDict())
            default:
                self.viewModel.postOilRequest(dict: TyreRequestModel.shared.getBatteryRequestDict())
            }
        }
    }
    
}

// MARK: - Extension For Collection View
//=======================================
extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollView.dequeueCell(with: HomeCollectionCell.self, indexPath: indexPath)
        cell.cellImageView.image = dataArray[indexPath.row].image
        cell.cellLabel.text = dataArray[indexPath.row].name
        cell.cellLabelBackGroundView.backgroundColor = dataArray[indexPath.row].productColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 40) / 2, height: 210)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //bw two lines spacing
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TyreRequestModel.shared = TyreRequestModel()
        if isUserLoggedin {
            if !UserModel.main.phoneNoAdded {
                self.showAlertWithAction(title: "", msg: "To continue performing this action, please complete your profile", cancelTitle: "Cancel", actionTitle: LocalizedString.ok.localized, actioncompletion: {
                    AppRouter.goToEditProfileVC(vc: self, model: UserModel.main, isEditProfileFrom: .home)
                })
                return
            }
        }
        switch dataArray[indexPath.row].name {
        case LocalizedString.tyre.localized:
            categoryType = .tyres
            AppRouter.goToURTyreStep1VC(vc: self)
        case LocalizedString.oil.localized:
            categoryType = .oil
            AppRouter.goToVehicleDetailForOilVC(vc: self)
        case LocalizedString.battery.localized:
            categoryType = .battery
            AppRouter.goToVehicleDetailForBatteryVC(vc: self)
        default:
            showAlert(msg: "Under Development")
        }
    }
}

// MARK: - Extension For LocationPopUpVMDelegate
//===========================
extension HomeVC:LocationPopUpVMDelegate {
    func postTyreRequestSuccess(message: String){
          AppRouter.showSuccessPopUp(vc: self, title: "Successfully Requested", desc: "Your request for tyre service has been submitted successfully.")
    }
    func postTyreRequestFailed(error:String){
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    func postBatteryRequestSuccess(message: String){
          AppRouter.showSuccessPopUp(vc: self, title: "Successfully Requested", desc: "Your request for battery service has been submitted successfully.")
    }
    func postBatteryRequestFailed(error:String){
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    func postOilRequestSuccess(message: String){
          AppRouter.showSuccessPopUp(vc: self, title: "Successfully Requested", desc: "Your request for oil service has been submitted successfully.")
    }
    func postOilRequestFailed(error:String){
        ToastView.shared.showLongToast(self.view, msg: error)
    }
}

// MARK: - SuccessPopupVCDelegate
//===============================
extension HomeVC: SuccessPopupVCDelegate {
    func okBtnAction() {
        self.dismiss(animated: true) {
            TyreRequestModel.shared = TyreRequestModel()
            self.navigationController?.popToViewControllerOfType(classForCoder: HomeVC.self)
        }
    }
}
// MARK: - EditProfileVCDelegate
//===============================

extension HomeVC: EditProfileVCDelegate {
    func editProfileSuccess(){
        
    }
}
