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
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: - Variables
    //===========================
    var dataArray:[GarageDataValue] = []
    
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
extension GarageHomeVC {
    
    private func initialSetup() {
        self.dataSetUp()
        self.tableViewSetUp()
    }
    
    private func dataSetUp(){
        if isUserLoggedin{
            self.titleLbl.text = "Hi, " + "\(UserModel.main.name)"
        } else {
            self.titleLbl.text = "Hi, User"
        }
        self.dataArray = [GarageDataValue(requestCount: 25, name: "Request Accepted",requestColor: UIColor(r: 230, g: 240, b: 245, alpha: 1.0),backgroundColor: UIColor(r: 253, g: 237, b: 223, alpha: 1.0) ),
                          GarageDataValue(requestCount: 70, name: "New Service Request",requestColor: UIColor(r: 233 , g: 235, b: 239, alpha: 1.0),backgroundColor: UIColor(r: 230, g: 240, b: 245, alpha: 1.0)),
                          GarageDataValue(requestCount: 10, name: "Services Scheduled for Today  ",requestColor: UIColor(r: 253, g: 237, b: 223, alpha: 1.0),backgroundColor: UIColor(r: 233 , g: 235, b: 239, alpha: 1.0))]
    }
    
    private func tableViewSetUp(){
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.registerCell(with: GarageHomeTableCell.self)
    }
    
}

// MARK: - Extension For TableView
//===========================
extension GarageHomeVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.dataArray.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: GarageHomeTableCell.self, indexPath: indexPath)
        cell.populateData(model: self.dataArray[indexPath.row])
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAlert(msg: "Under Development")
    }
}
