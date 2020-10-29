//
//  BookedRequestVC.swift
//  ArabianTyres
//
//  Created by Admin on 05/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit
import DZNEmptyDataSet

class BookedRequestVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var mainTableView: UITableView!
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    
    
}

// MARK: - Extension For Functions
//===========================
extension BookedRequestVC {
    
    private func initialSetup() {
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.emptyDataSetSource = self
        self.mainTableView.emptyDataSetDelegate = self
        self.mainTableView.registerCell(with: BookedRequestTableCell.self)
    }
}

// MARK: - Extension For TableView
//===========================
extension BookedRequestVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: BookedRequestTableCell.self, indexPath: indexPath)
        cell.startServiceBtnTapped = {[weak self] in
            self?.showAlert(msg: LocalizedString.underDevelopment.localized)
        }
        cell.chatBtnTapped = {[weak self] in
            self?.showAlert(msg: LocalizedString.underDevelopment.localized)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppRouter.goToBookedTyreRequestVC(vc: self)
    }
}

//MARK: DZNEmptyDataSetSource and DZNEmptyDataSetDelegate
//================================
extension BookedRequestVC : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return  #imageLiteral(resourceName: "layerX00201")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var emptyData = "No data found"
//        emptyData = viewModel.garageRequestListing.endIndex == 0 ? "No data found" : ""
    
        return NSAttributedString(string: emptyData, attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontTertiaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(18)])
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldBeForced(toDisplay scrollView: UIScrollView!) -> Bool {
        return false
    }
}
