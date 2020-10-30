//
//  UserChatVC.swift
//  ArabianTyres
//
//  Created by Admin on 27/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import DZNEmptyDataSet
import UIKit

class UserChatVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var searchTextField: ATCTextField!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
     var buttonView = UIButton()
    
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
extension UserChatVC {
    
    private func initialSetup() {
        self.tableViewSetUp()
        self.textFieldSetUp()
    }
    
    private func tableViewSetUp(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.emptyDataSetSource = self
        self.mainTableView.emptyDataSetDelegate = self
        self.mainTableView.registerCell(with: InboxTableViewCell.self)
    }
    
    private func textFieldSetUp(){
        buttonView.isHidden = true
        buttonView.addTarget(self, action: #selector(clear(_:)), for: .touchUpInside)
        buttonView.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        searchTextField.setButtonToRightView(btn: buttonView, selectedImage: #imageLiteral(resourceName: "icon"), normalImage: #imageLiteral(resourceName: "icon"), size: CGSize(width: 20, height: 20))
    }
    
    @objc private func clear(_ sender: UIButton) {
        searchTextField.text = ""
//        viewModel.searchText = searchTextField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
//        self.searchText = searchTextField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
//        isSearchOn = !viewModel.searchText.isEmpty
//        buttonView.isHidden = viewModel.searchText.isEmpty
//        tableView.reloadData()
    }
    
}

// MARK: - Extension For TableView
//===========================
extension UserChatVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: InboxTableViewCell.self, indexPath: indexPath)
        return cell
    }
}


//MARK: DZNEmptyDataSetSource and DZNEmptyDataSetDelegate
//================================
extension UserChatVC : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return  #imageLiteral(resourceName: "layerX00201")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var emptyData = ""
        emptyData =   "No data found"
        return NSAttributedString(string: emptyData , attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontTertiaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansBold.withSize(18)])
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
