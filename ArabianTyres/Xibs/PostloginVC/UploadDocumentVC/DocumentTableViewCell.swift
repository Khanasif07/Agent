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
    
    
    var cancelBtnTapped: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpFont()
        setBorder(view: uploadImgView)
        setBorder(view: docImgView)
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        cancelBtnTapped?()
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
    
    func bindData(text: String) {
        titleLbl.text = text

    }
}
