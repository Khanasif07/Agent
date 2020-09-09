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
    init(image:UIImage,name:String) {
        self.image = image
        self.name = name
    }
}


class HomeVC: BaseVC {
    
    // MARK: - IBOutlets
    //===========================
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
        mainCollView.delegate = self
        mainCollView.dataSource = self
        mainCollView.registerCell(with: HomeCollectionCell.self)
        dataArray = [DataValue(image: #imageLiteral(resourceName: "maskGroup"), name: LocalizedString.tyre.localized),
                     DataValue(image: #imageLiteral(resourceName: "maskGroup"), name: LocalizedString.oil.localized),
                     DataValue(image: #imageLiteral(resourceName: "maskGroup"), name: LocalizedString.battery.localized)]
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
        print(indexPath.row)
    }
    
}
