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
    var dataArray:[DataValue] = []
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
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
        self.dataSetUp()
        self.collectionViewSetUp()
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
    
}

// MARK: - Extension For TableView
//===========================
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
        if !isUserLoggedin{
            showAlert(msg: "Under Development")
            return
        }
        switch dataArray[indexPath.row].name {
        case LocalizedString.tyre.localized:
            categoryType = .tyres
            TyreRequestModel.shared = TyreRequestModel()
             AppRouter.goToURTyreStep1VC(vc: self)
//            AppRouter.goToVehicleDetailForBatteryVC(vc: self)

        case LocalizedString.oil.localized:
            categoryType = .oil
            AppRouter.goToVehicleDetailForOilVC(vc: self)
            
        default:
            showAlert(msg: "Under Development")
        }
    }
    
}
