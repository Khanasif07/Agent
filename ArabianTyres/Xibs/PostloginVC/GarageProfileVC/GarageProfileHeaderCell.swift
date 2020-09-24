//
//  GarageProfileHeaderCell.swift
//  ArabianTyres
//
//  Created by Admin on 23/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import UIKit

class GarageProfileHeaderCell: UITableViewCell {
    
    
    var phoneVerifyBtnTapped :((UIButton)->())?
    var emailVerifyBtnTapped :((UIButton)->())?
    var categoryNameArray = ["Car Wash","Car Wash","Car Wash","Car Wash","Car Wash"]
    
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var editProfileView: UIImageView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userPhoneNoLbl: UILabel!
    @IBOutlet weak var phoneNoVerifiedView: UIImageView!
    @IBOutlet weak var emailVerifyBtn: UIButton!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var emailVerifiedView: UIImageView!
    @IBOutlet weak var phoneVerifyBtn: UIButton!
    @IBOutlet weak var mainCollView: UICollectionView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var installationLbl: UILabel!
    @IBOutlet weak var collViewHeightConst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainCollView.registerCell(with: FacilityCollectionViewCell.self)
        mainCollView.delegate = self
        mainCollView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.dataContainerView.addShadow(cornerRadius: 4, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 4)
        self.emailVerifyBtn.round(radius: 4.0)
        self.phoneVerifyBtn.round(radius: 4.0)
        self.profileImgView.round()
        self.editProfileView.round(radius: 4.0)
        self.emailVerifiedView.round()
        self.phoneNoVerifiedView.round()
    }
    
    func populateData(model: UserModel){
        profileImgView.setImage_kf(imageString: model.image, placeHolderImage: #imageLiteral(resourceName: "placeHolder"), loader: true)
        userNameLbl.text = model.name.isEmpty ? "N/A" : "\(model.name)"
        userPhoneNoLbl.text = model.phoneNo.isEmpty ? "N/A" : "\(model.countryCode)" + " \(model.phoneNo)"
        userEmailLbl.text = model.email.isEmpty ? "N/A" : model.email
        phoneNoVerifiedView.isHidden = !model.phoneVerified
        phoneVerifyBtn.isHidden = model.phoneVerified || model.phoneNo.isEmpty
        emailVerifiedView.isHidden = !model.emailVerified
        emailVerifyBtn.isHidden = model.emailVerified || model.email.isEmpty
       
    }
    
    @IBAction func phoneVerifyBtnAction(_ sender: UIButton) {
        if let handle = phoneVerifyBtnTapped{
            handle(sender)
        }
    }
    
    @IBAction func emailVerifyBtnAction(_ sender: UIButton) {
        if let handle = emailVerifyBtnTapped{
            handle(sender)
        }
    }
    
}


extension GarageProfileHeaderCell : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  categoryNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: FacilityCollectionViewCell.self, indexPath: indexPath)
        cell.cancelBtn.isHidden = true
        cell.cancelBtnHeightConstraint.constant = 0.0
        cell.skillLbl.contentMode = .center
        cell.skillLbl.text = self.categoryNameArray[indexPath.item]
        cell.layoutSubviews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = self.categoryNameArray[indexPath.row]
        let textSize = text.sizeCount(withFont: AppFonts.NunitoSansSemiBold.withSize(13.0), boundingSize: CGSize(width: 10000.0, height: 32.0))
        return CGSize(width: (textSize.width ) + 16.0, height: 34.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
    }
}
