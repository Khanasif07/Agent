//
//  CustomDashedView.swift
//  ArabianTyres
//
//  Created by Admin on 24/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Foundation

class CustomDashedView: UIView {
    
    //MARK:-IBOutlets
    @IBOutlet weak var leftCircleView: UIView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var rightCircleView: UIView!
   
    var contentView:UIView?
    
    //MARK:- Variables
    
    override func awakeFromNib() {
        super.awakeFromNib()
        arrangeView()
    }
    
    func arrangeView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        contentView = view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        leftCircleView.round()
        rightCircleView.round()
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: CustomDashedView.self), bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first(where: {$0 is UIView}) as? UIView
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        arrangeView()
        contentView?.prepareForInterfaceBuilder()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        arrangeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

