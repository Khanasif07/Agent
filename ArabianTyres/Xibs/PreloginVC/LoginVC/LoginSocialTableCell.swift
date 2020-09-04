//
//  LoginSocialTableCell.swift
//  ArabianTyres
//
//  Created by Admin on 04/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class LoginSocialTableCell: UITableViewCell {

    @IBOutlet weak var appleBtn: UIButton!
    @IBOutlet weak var faceboookBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var loginSocialLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func googleBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func appleBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func fbBtnAction(_ sender: UIButton) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
