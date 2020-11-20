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
    @IBOutlet weak var myRatingLbl: UILabel!
    @IBOutlet weak var ratingValueLbl: UILabel!
    @IBOutlet weak var totalRatingLbl: UILabel!

    // MARK: - Variables
    //===========================
    var viewModel = GarageHomeVM()
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
        viewModel.getAdminId(dict: [:], loader: true)
    }
    
    @IBAction func reviewBtnAction(_ sender: UIButton) {
        AppRouter.goToReViewListingVC(vc: self, garageId: self.viewModel.garageHomeModel.garageId)
    }
}

// MARK: - Extension For Functions
//===========================
extension GarageHomeVC {
    
    private func initialSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(bidAcceptedRejected), name: Notification.Name.BidAcceptedRejected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(serviceRequestReceived), name: Notification.Name.ServiceRequestReceived, object: nil)
        self.viewModel.delegate = self
        self.viewModel.getGarageHomeData(params: [:],loader: true)
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
        self.dataArray = [GarageDataValue(requestCount: self.viewModel.garageHomeModel.acceptedRequets, name: LocalizedString.requestAccepted.localized,requestColor: UIColor(r: 6, g: 130, b: 191, alpha: 1.0),backgroundColor: UIColor(r: 230, g: 240, b: 245, alpha: 1.0) ),
                          GarageDataValue(requestCount: self.viewModel.garageHomeModel.newRequests, name: LocalizedString.newRequest.localized,requestColor: UIColor(r: 52 , g: 88, b: 158, alpha: 1.0),backgroundColor: UIColor(r: 230, g: 240, b: 245, alpha: 1.0)),
                          GarageDataValue(requestCount: 0, name: LocalizedString.service_sheduled_for_today.localized,requestColor: UIColor(r: 210, g: 103, b: 9, alpha: 1.0),backgroundColor: UIColor(r: 253 , g: 237, b: 223, alpha: 1.0)),GarageDataValue(requestCount: 0, name:LocalizedString.today_Revenue.localized,requestColor: UIColor(r: 44, g: 182, b: 16, alpha: 1.0),backgroundColor: UIColor(r: 239 , g: 246, b: 231, alpha: 1.0))]
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
    
    @objc func serviceRequestReceived() {
        self.viewModel.getGarageHomeData(params: [:])
    }
    
    @objc func  bidAcceptedRejected() {
        self.viewModel.getGarageHomeData(params: [:])
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


// MARK: - Extension For GarageHomeVMDelegate
//===========================
extension GarageHomeVC:  GarageHomeVMDelegate{
    
     func getAdminIdSuccess(id: String, name: String, image: String){
        AppRouter.goToOneToOneChatVC(self, userId: id, requestId: "", name: "Support Chat", image: image, unreadMsgs: 0, isSupportChat: true,garageUserId: isCurrentUserType == .garage ? UserModel.main.id : "")
    }
    
    func getAdminIdFailed(msg: String) {
        
    }
    
    func getGarageHomeDataSuccess(msg: String) {
        self.dataArray = [GarageDataValue(requestCount: self.viewModel.garageHomeModel.acceptedRequets, name: LocalizedString.requestAccepted.localized,requestColor: UIColor(r: 6, g: 130, b: 191, alpha: 1.0),backgroundColor: UIColor(r: 230, g: 240, b: 245, alpha: 1.0) ),
                          GarageDataValue(requestCount: self.viewModel.garageHomeModel.newRequests, name: LocalizedString.newRequest.localized,requestColor: UIColor(r: 52 , g: 88, b: 158, alpha: 1.0),backgroundColor: UIColor(r: 230, g: 240, b: 245, alpha: 1.0)),
                          GarageDataValue(requestCount: 0, name: LocalizedString.service_sheduled_for_today.localized,requestColor: UIColor(r: 210, g: 103, b: 9, alpha: 1.0),backgroundColor: UIColor(r: 253 , g: 237, b: 223, alpha: 1.0)),GarageDataValue(requestCount: 0, name:LocalizedString.today_Revenue.localized,requestColor: UIColor(r: 44, g: 182, b: 16, alpha: 1.0),backgroundColor: UIColor(r: 239 , g: 246, b: 231, alpha: 1.0))]
       
        ratingValueLbl.text = self.viewModel.garageHomeModel.averageRating.description
        totalRatingLbl.text = "(\(self.viewModel.garageHomeModel.ratingCount.description))"
        self.mainCollView.reloadData()
    }
    
    func getGarageHomeDataFailed(msg: String, error: Error) {
        ToastView.shared.showLongToast(self.view, msg: msg)
    }
}
