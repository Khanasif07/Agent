//
//  GarageAllRequestVC.swift
//  ArabianTyres
//
//  Created by Admin on 05/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class GarageAllRequestVC: BaseVC {
    
    //MARK: ENUM
       //==========
       enum SelectedVC {
           case goingEventsVC
           case myEventsVC
       }
       
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bookedRequestBtn: UIButton!
    @IBOutlet weak var allRequestBtn: UIButton!
    @IBOutlet weak var filterBtn: UIButton!
    
    
    // MARK: - Variables
    //===========================
    var selectedVC          : SelectedVC = .goingEventsVC
    var allRequestVC        : AllRequestVC!
    var bookedRequestVC     : BookedRequestVC!
    var filterArr : [FilterScreen] = [.allRequestServiceType([],false), .allRequestByStatus([],false)]

    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           allRequestBtn.layer.cornerRadius = 4
           bookedRequestBtn.layer.cornerRadius = 4
           if #available(iOS 11.0, *) {
               bookedRequestBtn.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
               allRequestBtn.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
           }
           allRequestBtn.clipsToBounds = true
           bookedRequestBtn.clipsToBounds = true
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        if allRequestVC.filterApplied {
            if !allRequestVC.clearFilterOnTabChange {
                filterBtn.isSelected = allRequestVC.filterApplied
                allRequestVC.clearFilterOnTabChange = !allRequestVC.clearFilterOnTabChange
            } else {
                allRequestVC.filterApplied = false
                filterBtn.isSelected = allRequestVC.filterApplied
                filterArr = [.allRequestServiceType([],false), .allRequestByStatus([],false)]
                allRequestVC.hitApi()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: - IBActions
    //===========================
    @IBAction func allRequestButtonTapped(_ sender: UIButton) {
          self.view.endEditing(true)
          self.mainScrollView.setContentOffset(CGPoint.zero, animated: true)
          self.view.layoutIfNeeded()
          
      }
      
      @IBAction func bookedButtonTapped(_ sender: UIButton) {
          self.view.endEditing(true)
          self.mainScrollView.setContentOffset(CGPoint(x: UIScreen.width, y: 0), animated: true)
          self.view.layoutIfNeeded()
          
      }
      
    @IBAction func filterBtnAction(_ sender: UIButton) {
        allRequestVC.clearFilterOnTabChange = false
        AppRouter.goToSRFliterVC(vc: self, filterArr: filterArr) { [weak self] (filterData, isReset) in
            if isReset {
                self?.allRequestVC.viewModel.currentPage = 1
                self?.allRequestVC.filterApplied = true
                self?.allRequestVC.getFilterData(data: filterData,loader: true)
            }else {
                self?.allRequestVC.filterApplied = false
                self?.allRequestVC.hitApi(loader: true)
            }
            self?.filterArr = filterData
            self?.allRequestVC.filterArr = filterData
        }
    }
}

// MARK: - Extension For Functions
//===========================
extension GarageAllRequestVC {
    
    private func initialSetup() {
        self.configureScrollView()
        self.instantiateViewController()
        self.backgroundView.backgroundColor = AppColors.fontPrimaryColor
        self.titleLbl.text = LocalizedString.requests.localized
        self.allRequestBtn.setTitle(LocalizedString.allRequests.localized, for: .normal)
        self.bookedRequestBtn.setTitle(LocalizedString.bookedRequests.localized, for: .normal)
        self.mainScrollView.delegate = self
    }
    
    private func configureScrollView(){
        self.mainScrollView.contentSize = CGSize(width: 2 * UIScreen.width, height: 1)
        self.mainScrollView.isPagingEnabled = true
    }
    
    private func instantiateViewController() {
        //instantiate the AllRequestVC
        self.allRequestVC = AllRequestVC.instantiate(fromAppStoryboard: .Garage)
        self.allRequestVC.view.frame.origin = CGPoint(x: 0, y: 0)
        self.mainScrollView.frame = self.allRequestVC.view.frame
        self.mainScrollView.addSubview(self.allRequestVC.view)
        self.addChild(self.allRequestVC)
        
        allRequestVC.clearFilter = {
            self.filterBtn.isSelected = false
            self.filterArr = [.allRequestServiceType([],false), .allRequestByStatus([],false)]
            
        }
        
        //instantiate the AppliedJobVC
        self.bookedRequestVC = BookedRequestVC.instantiate(fromAppStoryboard: .Garage)
        self.bookedRequestVC.view.frame.origin =   CGPoint(x: UIScreen.width, y: 0)
        self.mainScrollView.frame = self.bookedRequestVC.view.frame
        self.mainScrollView.addSubview(self.bookedRequestVC.view)
        self.addChild(self.bookedRequestVC)
        
    }
    
}


//    MARK:- ScrollView delegate
//    ==========================
extension GarageAllRequestVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.setButtonColor()
    }
    
    func setButtonColor(){
        if self.mainScrollView.contentOffset.x <= UIScreen.width/2 {
            self.allRequestBtn.backgroundColor = AppColors.appRedColor
            self.allRequestBtn.setTitleColor(.white, for: .normal)
            self.bookedRequestBtn.backgroundColor = .white
            self.bookedRequestBtn.setTitleColor(.black, for: .normal)
        }
        else {
            self.bookedRequestBtn.setTitleColor(.white, for: .normal)
            self.bookedRequestBtn.backgroundColor = AppColors.appRedColor
            self.allRequestBtn.setTitleColor(.black, for: .normal)
            self.allRequestBtn.backgroundColor = .white
        }
    }
}
