//
//  URTyreSizeVC.swift
//  ArabianTyres
//
//  Created by Admin on 21/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class URTyreSizeVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bottomDescLbl: UILabel!
    @IBOutlet weak var topDescLbl: UILabel!
    @IBOutlet weak var proceedBtn: AppButton!
    @IBOutlet weak var mainTableView: UITableView!
    
    
    // MARK: - Variables
    //===========================
    var viewModel = URTyreSizeVM()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupTextAndFonts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        proceedBtn.round(radius: 4.0)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func proccedBtnAction(_ sender: UIButton) {
        switch categoryType{
        case .oil:
             AppRouter.goToOilBrandsVC(vc: self)
            
        case .tyres:
            NotificationCenter.default.post(name: Notification.Name.SelectedTyreSizeSuccess, object: nil)
            self.navigationController?.popViewControllers(controllersToPop: 2, animated: true)
        case .battery:
            break
        }
        
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension URTyreSizeVC {
    
    private func initialSetup() {
        tableViewSetUp()
        self.viewModel.delegate = self
        self.viewModel.getTyreSizeListingData(dict: [ApiKey.makeId:TyreRequestModel.shared.makeId,ApiKey.modelName:TyreRequestModel.shared.modelName,ApiKey.year: TyreRequestModel.shared.year])
    }
    
    private func tableViewSetUp(){
        self.proceedBtn.isEnabled = false
        mainTableView.registerCell(with: URTyreSizeTableCell.self)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.emptyDataSetSource = self
        mainTableView.emptyDataSetDelegate = self
    }
    
    private func setupTextAndFonts() {
        switch categoryType{
            
        case .oil:
            proceedBtn.setTitle(LocalizedString.next.localized, for: .normal)
            titleLbl.text = LocalizedString.selectViscosity.localized
            topDescLbl.text = LocalizedString.weHaveFoundSutiableOilViscosity.localized
            bottomDescLbl.text = LocalizedString.pleaseSelectAnyViscosityToProceed.localized
        case .tyres:
            proceedBtn.setTitle(LocalizedString.proceed.localized, for: .normal)
            titleLbl.text = LocalizedString.selectTyreSize.localized
            topDescLbl.text = LocalizedString.weHaveFoundSutiableTyreForYourVehicleAsPerTheProvidedDetails.localized
            bottomDescLbl.text = LocalizedString.pleaseSelectAnyTyreToProceed.localized

        case .battery:
            titleLbl.text = LocalizedString.alert.localized
            
        }
    }

}

// MARK: - Extension For TableView
//===========================
extension URTyreSizeVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.tyreSizeListings.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: URTyreSizeTableCell.self, indexPath: indexPath)
        cell.bindData(categoryType: categoryType)
        let isPowerSelected = self.viewModel.selectedtyreSizeListings.contains(where: {$0.rimSize == self.viewModel.tyreSizeListings[indexPath.row].rimSize})
        if self.viewModel.tyreSizeListings.endIndex  > 0  {
            cell.populateData(isPowerSelected: isPowerSelected,model: self.viewModel.tyreSizeListings[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if self.viewModel.selectedtyreSizeListings.contains(self.viewModel.tyreSizeListings[indexPath.row]) {} else {
            self.viewModel.selectedtyreSizeListings.removeAll()
            self.viewModel.selectedtyreSizeListings.append(self.viewModel.tyreSizeListings[indexPath.row])
            TyreRequestModel.shared.width = "\(self.viewModel.tyreSizeListings[indexPath.row].width)"
            TyreRequestModel.shared.profile = "\(self.viewModel.tyreSizeListings[indexPath.row].profile)"
            TyreRequestModel.shared.rimSize = "\(self.viewModel.tyreSizeListings[indexPath.row].rimSize)"
        }
        proceedBtn.isEnabled = true
        mainTableView.reloadData()
    }
}

// MARK: - Extension For URTyreSizeVMDelegate
//===========================
extension URTyreSizeVC: URTyreSizeVMDelegate{
    func getTyreSizeListingDataSuccess(message: String){
        self.mainTableView.reloadData()
    }
    
    func getTyreSizeListingDataFailed(error:String){
        ToastView.shared.showLongToast(self.view, msg: error)
    }
}

//MARK: DZNEmptyDataSetSource and DZNEmptyDataSetDelegate
//================================
extension URTyreSizeVC : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return  nil
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No data Found", attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontTertiaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(18)])
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
    
}
