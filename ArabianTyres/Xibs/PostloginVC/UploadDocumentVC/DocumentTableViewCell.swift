//
//  DocumentTableViewCell.swift
//  ArabianTyres
//
//  Created by Arvind on 12/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var uploadImgView: UIImageView!
    @IBOutlet weak var docImgView: UIImageView!
    @IBOutlet weak var cancelBtn : UIButton!
    
    @IBOutlet weak var uploadCancelBtn : UIButton!

    var cancelBtnTapped: (()->())?
    var uploadCancelBtnTapped: (()->())?

    var uploadDoc: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureOnImage()
        setUpFont()
        setBorder(view: uploadImgView)
        setBorder(view: docImgView)
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        cancelBtnTapped?()
    }
    
    @IBAction func uploadCancelBtnAction(_ sender: Any) {
        uploadCancelBtnTapped?()
    }
    
    private func addGestureOnImage() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnImage(_:)))
        uploadImgView.isUserInteractionEnabled = true
        tapGestureRecognizer.numberOfTouchesRequired = 1
        uploadImgView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapOnImage(_ sender : UITapGestureRecognizer) {
        uploadDoc?()
    }
    
    private func setBorder(view: UIImageView) {
        let layer = CAShapeLayer()
        layer.strokeColor = AppColors.fontTertiaryColor.cgColor
        layer.lineDashPattern = [2, 2]
        layer.frame = view.bounds
        layer.fillColor = nil
        layer.path = UIBezierPath(rect: view.bounds).cgPath
        view.layer.addSublayer(layer)
    }
    
    private func setUpFont() {
        titleLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
    }
    
    func bindData(section: UploadDocumentVC.Section) {
        titleLbl.text = section.text
       
        if section.imgArr.isEmpty {
            docImgView.isHidden = true
            cancelBtn.isHidden = true
            uploadCancelBtn.isHidden = true

        }else {
            docImgView.isHidden = false
            cancelBtn.isHidden = false
            docImgView?.sd_setImage(with: URL(string: section.imgArr[0]), completed: nil)

            if section.imgArr.count == 2 {
            uploadImgView.contentMode = .scaleToFill
            uploadImgView?.sd_setImage(with: URL(string: section.imgArr[1]), completed: nil)
            uploadCancelBtn.isHidden = false

            }else {
            uploadCancelBtn.isHidden = true
            uploadImgView.contentMode = .center
            uploadImgView.image = #imageLiteral(resourceName: "icTopArrow")
            }
        }
    }
}
