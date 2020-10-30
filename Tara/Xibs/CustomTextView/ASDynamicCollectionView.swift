//
//  ASDynamicCollectionView.swift
//  CollViewHeightWithTableView
//
//  Created by Arvind on 04/05/20.
//  Copyright © 2020 Arvind. All rights reserved.
//


import UIKit

class ASDynamicCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
