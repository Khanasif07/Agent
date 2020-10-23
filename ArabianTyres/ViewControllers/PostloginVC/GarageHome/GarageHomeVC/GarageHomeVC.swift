//
//  GarageHomeVC.swift
//  ArabianTyres
//
//  Created by Admin on 21/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

struct GarageDataValue{
    var requestCount:Int
    var name:String
    var requestColor: UIColor
    var backgroundColor: UIColor
    init(requestCount:Int,name:String,requestColor: UIColor,backgroundColor: UIColor) {
        self.requestCount = requestCount
        self.name = name
        self.requestColor = requestColor
        self.backgroundColor = backgroundColor
    }
}

class GarageHomeVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var mainCollView: UICollectionView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var currentDateLbl: UILabel!
    
    // MARK: - Variables
    //===========================
    var timer = Timer()
    var dataArray:[GarageDataValue] = []
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func chatBtnAction(_ sender: UIButton) {
        showAlert(msg: "Under Development")
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension GarageHomeVC {
    
    private func initialSetup() {
        self.dataSetUp()
        self.tableViewSetUp()
        self.getCurrentTime()
    }
    
    private func dataSetUp(){
        if isUserLoggedin{
            self.titleLbl.text = "Hi, " + "\(UserModel.main.name)"
        } else {
            self.titleLbl.text = "Hi, User"
        }
        self.currentDateLbl.textColor = AppColors.fontTertiaryColor
        self.dataArray = [GarageDataValue(requestCount: 25, name: LocalizedString.requestAccepted.localized,requestColor: UIColor(r: 6, g: 130, b: 191, alpha: 1.0),backgroundColor: UIColor(r: 230, g: 240, b: 245, alpha: 1.0) ),
                          GarageDataValue(requestCount: 70, name: LocalizedString.newRequest.localized,requestColor: UIColor(r: 52 , g: 88, b: 158, alpha: 1.0),backgroundColor: UIColor(r: 230, g: 240, b: 245, alpha: 1.0)),
                          GarageDataValue(requestCount: 10, name: LocalizedString.service_sheduled_for_today.localized,requestColor: UIColor(r: 210, g: 103, b: 9, alpha: 1.0),backgroundColor: UIColor(r: 253 , g: 237, b: 223, alpha: 1.0)),GarageDataValue(requestCount: 200, name:LocalizedString.today_Revenue.localized,requestColor: UIColor(r: 44, g: 182, b: 16, alpha: 1.0),backgroundColor: UIColor(r: 239 , g: 246, b: 231, alpha: 1.0))]
    }
    
    private func tableViewSetUp(){
        mainCollView.delegate = self
        mainCollView.dataSource = self
        mainCollView.registerCell(with: GarageHomeCollCell.self)
    }
    
    private func getCurrentTime() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.currentTime) , userInfo: nil, repeats: true)
    }
    
    @objc func currentTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.DateFormat.hhmma.rawValue
        let currentDate = Date().convertToDefaultString()
        self.currentDateLbl.text = formatter.string(from: Date()) + ", " + currentDate
    }
    
}


// MARK: - Extension For TableView
//===========================
extension GarageHomeVC : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.dataArray.endIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollView.dequeueCell(with: GarageHomeCollCell.self, indexPath: indexPath)
        cell.populateData(model: self.dataArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 15.0) / 2, height: 210)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //bw two lines spacing
        return 16.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showAlert(msg: "Under Development")
    }
    
}
