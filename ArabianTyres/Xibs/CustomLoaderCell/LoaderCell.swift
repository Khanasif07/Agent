//
//  LoaderCell.swift
//  ArabianTyres
//
//  Created by Admin on 21/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

class LoaderCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //=====================================================================
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    // MARK: - Cell lifecycle
    //=====================================================================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.loader.startAnimating()
        self.loader.color = .red
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.loader.startAnimating()
    }
}
