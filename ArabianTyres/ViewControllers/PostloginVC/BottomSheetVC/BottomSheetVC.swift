//
//  BottomSheetVC.swift
//  ArabianTyres
//
//  Created by Admin on 25/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

enum VehicleDetailType{
    case make
    case model
}

import UIKit
import DZNEmptyDataSet

class BottomSheetVC: BaseVC {
    // MARK: - IBOutlets
    //=========================
    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBtn: AppButton!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var transparentView: UIView!
    
    // MARK: - Variables
    //===========================
    var viewModel = BottomSheetVM()
    var vehicleDetailtype : VehicleDetailType = .make
    var searchText: String = ""
    var bottomSheetHeading : String?
    var onSaveBtnAction : (([MakeModel],[ModelData])->(Void))?
    var optionArr : [String] = []
    var buttonView = UIButton()
    var isSearchOn: Bool = false
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        textFieldSetUp()
        hitApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    private func hitApi(){
        if   (vehicleDetailtype == .make) {
            self.headingLbl.text = "Make"
            self.searchTxtField.placeholder = "Select vehicle make"
            self.hitMakeListingApi()
        } else {
            self.headingLbl.text = "Model"
            self.searchTxtField.placeholder = "Select vehicle model"
            self.hitModelListingApi()
        }
    }
    
    private func textFieldSetUp(){
        buttonView.isHidden = true
        buttonView.addTarget(self, action: #selector(clear(_:)), for: .touchUpInside)
        searchTxtField.setButtonToRightView(btn: buttonView, selectedImage: #imageLiteral(resourceName: "cancel"), normalImage: #imageLiteral(resourceName: "cancel"), size: CGSize(width: 20, height: 20))
    }
    
    @objc private func clear(_ sender: UIButton) {
        searchTxtField.text = ""
        viewModel.searchText = searchTxtField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        self.searchText = searchTxtField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        isSearchOn = !viewModel.searchText.isEmpty
        buttonView.isHidden = viewModel.searchText.isEmpty
        tableView.reloadData()
    }
    
    private func hitMakeListingApi(){
        self.viewModel.getMakeListingData(params: ["search": ""],loader: false)
    }
    
    private func hitModelListingApi(){
        self.viewModel.getModelListingData(params: ["search": "",ApiKey.makeId: self.viewModel.makeId],loader: false)
    }
    
    private func initialSetup() {
        tableViewSetUp()
        headingLbl.font = AppFonts.NunitoSansSemiBold.withSize(17.0)
        addTapGesture()
    }
    
    private func tableViewSetUp(){
        self.viewModel.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.registerCell(with: BottomSheetTableCell.self)
        saveBtn.isEnabled = true
    }
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        transparentView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        dismiss(animated: true, completion: {
            self.onSaveBtnAction?(self.viewModel.selectedMakeArr,self.viewModel.selectedModelArr)
        })
    }
    
    @IBAction func txtFieldChanged(_ sender: UITextField) {
        viewModel.searchText = sender.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        isSearchOn = !viewModel.searchText.isEmpty
        buttonView.isHidden = viewModel.searchText.isEmpty
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate - UITableViewDataSource
//===========================

extension BottomSheetVC :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (vehicleDetailtype == .make) ? self.viewModel.searchMakeListing.endIndex : self.viewModel.searchModelListing.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: BottomSheetTableCell.self, indexPath: indexPath)
        cell.makeLbl.text = (vehicleDetailtype == .make) ? self.viewModel.searchMakeListing[indexPath.row].name : self.viewModel.searchModelListing[indexPath.row].model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if vehicleDetailtype == .make{
            if self.viewModel.selectedMakeArr.contains(self.viewModel.searchMakeListing[indexPath.row]) {
                self.viewModel.selectedMakeArr.removeAll{( $0 == self.viewModel.searchMakeListing[indexPath.row])}
            }
            else {
                 self.viewModel.selectedMakeArr.removeAll()
                 self.viewModel.selectedMakeArr.append(self.viewModel.searchMakeListing[indexPath.row])
                }
            } else {
            if self.viewModel.selectedModelArr.contains(self.viewModel.searchModelListing[indexPath.row]) {
                self.viewModel.selectedModelArr.removeAll{( $0 == self.viewModel.searchModelListing[indexPath.row])}
            }
            else
            {
                self.viewModel.selectedModelArr.removeAll()
                self.viewModel.selectedModelArr.append(self.viewModel.searchModelListing[indexPath.row])
            }
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}


// MARK: - BottomSheetVMDelegate
//===========================
extension BottomSheetVC: BottomSheetVMDelegate {
    
    func makeListingSuccess(message: String) {
        tableView.reloadData()
    }
    
    func makeListingFailed(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
    
    func modelListingSuccess(message: String) {
        tableView.reloadData()
    }
    
    func modelListingFailed(error: String) {
        ToastView.shared.showLongToast(self.view, msg: error)
    }
}



//MARK: DZNEmptyDataSetSource and DZNEmptyDataSetDelegate
//================================
extension BottomSheetVC : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return  nil
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No Data Found", attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontTertiaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(18)])
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
