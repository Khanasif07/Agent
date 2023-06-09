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
    var revenue: Double
    var name:String
    var requestColor: UIColor
    var backgroundColor: UIColor
    
    
    init(requestCount:Int,revenue: Double,name:String,requestColor: UIColor,backgroundColor: UIColor) {
        self.requestCount = requestCount
        self.name = name
        self.revenue = revenue
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
       // viewModel.getAdminId(dict: [:], loader: true)
        AppRouter.goToOneToOneChatVC(self, userId: AppConstants.adminId, requestId: "", name: LocalizedString.supportChat.localized , image: "", unreadMsgs: 0, isSupportChat: true,garageUserId: isCurrentUserType == .garage ? UserModel.main.id : AppConstants.adminId)
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
        self.dataSetUp()
        self.tableViewSetUp()
        self.getCurrentTime()
        self.viewModel.getGarageHomeData(params: [:],loader: false)
        viewModel.getAdminId(dict: [:], loader: false)
    }
    
    private func dataSetUp(){
        if isUserLoggedin{
            self.titleLbl.text = LocalizedString.hi.localized + "\(UserModel.main.name)"
        } else {
            self.titleLbl.text = LocalizedString.hiUser.localized
        }
        
        self.currentDateLbl.textColor = AppColors.fontTertiaryColor
        self.myRatingLbl.textColor = AppColors.fontTertiaryColor
        self.ratingValueLbl.textColor = AppColors.fontTertiaryColor
        self.totalRatingLbl.textColor = AppColors.fontTertiaryColor

        self.dataArray = [GarageDataValue(requestCount: self.viewModel.garageHomeModel.acceptedRequets, revenue: 0.0, name: LocalizedString.requestAccepted.localized,requestColor: UIColor(r: 6, g: 130, b: 191, alpha: 1.0),backgroundColor: UIColor(r: 230, g: 240, b: 245, alpha: 1.0) ),
                          GarageDataValue(requestCount: self.viewModel.garageHomeModel.newRequests, revenue: 0.0, name: LocalizedString.newRequest.localized,requestColor: UIColor(r: 52 , g: 88, b: 158, alpha: 1.0),backgroundColor: UIColor(r: 230, g: 240, b: 245, alpha: 1.0)),
                          GarageDataValue(requestCount: 0, revenue: 0.0, name: LocalizedString.ongoingServices.localized,requestColor: UIColor(r: 210, g: 103, b: 9, alpha: 1.0),backgroundColor: UIColor(r: 253 , g: 237, b: 223, alpha: 1.0)),GarageDataValue(requestCount: 0, revenue: 0.0, name: LocalizedString.serviceCompleted.localized,requestColor: UIColor(r: 210, g: 103, b: 9, alpha: 1.0),backgroundColor: UIColor(r: 253 , g: 237, b: 223, alpha: 1.0)),
                          GarageDataValue(requestCount: 0, revenue: self.viewModel.garageHomeModel.revenue, name:LocalizedString.today_Revenue.localized,requestColor: UIColor(r: 210, g: 103, b: 9, alpha: 1.0),backgroundColor: UIColor(r: 239 , g: 246, b: 231, alpha: 1.0))]
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
        return (self.dataArray.endIndex - 1  == indexPath.row) ? CGSize(width: (collectionView.frame.width), height: 210)
             : CGSize(width: (collectionView.frame.width - 15.0) / 2, height: 210)
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
    }
    
}


// MARK: - Extension For GarageHomeVMDelegate
//===========================
extension GarageHomeVC:  GarageHomeVMDelegate{
    
     func getAdminIdSuccess(id: String, name: String, image: String){
        AppConstants.adminId = id
    }
    
    func getAdminIdFailed(msg: String) {
        ToastView.shared.showLongToast(self.view, msg: msg)
    }
    
    func getGarageHomeDataSuccess(msg: String) {
        self.dataArray = [GarageDataValue(requestCount: self.viewModel.garageHomeModel.acceptedRequets, revenue: 0.0, name: LocalizedString.requestAccepted.localized,requestColor: UIColor(r: 6, g: 130, b: 191, alpha: 1.0),backgroundColor: UIColor(r: 230, g: 240, b: 245, alpha: 1.0) ),
                          GarageDataValue(requestCount: self.viewModel.garageHomeModel.newRequests, revenue: 0.0, name: LocalizedString.newRequest.localized,requestColor: UIColor(r: 52 , g: 88, b: 158, alpha: 1.0),backgroundColor: UIColor(r: 230, g: 240, b: 245, alpha: 1.0)),
                          GarageDataValue(requestCount: self.viewModel.garageHomeModel.ongoingServices, revenue: 0.0, name: LocalizedString.ongoingServices.localized,requestColor: UIColor(r: 210, g: 103, b: 9, alpha: 1.0),backgroundColor: UIColor(r: 253 , g: 237, b: 223, alpha: 1.0)),GarageDataValue(requestCount: self.viewModel.garageHomeModel.servicesCompletedToday, revenue: 0.0, name: LocalizedString.serviceCompleted.localized,requestColor: UIColor(r: 44, g: 182, b: 16, alpha: 1.0),backgroundColor: UIColor(r: 239 , g: 246, b: 231, alpha: 1.0)),
                          GarageDataValue(requestCount: 0, revenue: self.viewModel.garageHomeModel.revenue, name: LocalizedString.today_Revenue.localized,requestColor:  UIColor(r: 44, g: 182, b: 16, alpha: 1.0),backgroundColor: UIColor(r: 253 , g: 219, b: 219, alpha: 1.0))]
       
        ratingValueLbl.text = self.viewModel.garageHomeModel.averageRating.truncate(places: 1).description
        totalRatingLbl.text = "(\(self.viewModel.garageHomeModel.ratingCount.description))"
        self.mainCollView.reloadData()
    }
    
    func getGarageHomeDataFailed(msg: String, error: Error) {
        ToastView.shared.showLongToast(self.view, msg: msg)
    }
}
