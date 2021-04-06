//
//  CustomTextView.swift
//  Sigma For India
//
//  Created by Arvind on 29/07/20.
//  Copyright © 2020 Sigma. All rights reserved.
//

import UIKit

protocol CustomTextViewDelegate: class {
    func shouldBegin(_ tView : UITextView)
    func didBegin(_ tView : UITextView)
    func endEditing(_ tView : UITextView)
    func textViewValueUpdated(_ tView : UITextView)
    func collViewTapped(listingType: ListingType)
}

extension CustomTextViewDelegate {
    func textViewValueUpdated(_ tView : UITextView){}
    func didBegin(_ tView : UITextView) {}
    func endEditing(_ tView : UITextView) {}
    func collViewTapped(listingType: ListingType) {}
}

class CustomTextView: UIView {
    
    //MARK:-IBOutlets
    
    @IBOutlet var floatLbl: UILabel!
    @IBOutlet var tView: UITextView!
    @IBOutlet var rightImgView: UIImageView!
    @IBOutlet var leftImgView: UIImageView!
    @IBOutlet var outerView: UIView!
    @IBOutlet var rightImgContainerView: UIView!
    @IBOutlet var leftImgContainerView: UIView!
    @IBOutlet var collView: UICollectionView!

    
    //MARK:- Variables
    var txtViewEditable = true
    var isCollViewHidden : Bool = true
    weak var delegate : CustomTextViewDelegate?
    var listingType : ListingType = .brands
    var charLimit : Int = 100
    var placeHolderTxt : String = ""{
        didSet {
            tView.text = placeHolderTxt
            floatLbl.text = placeHolderTxt.uppercased()
        }
    }
    
    // MARK: View Life Cycle
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CustomTextView", owner: self, options: nil)
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        outerView.frame = self.bounds
        addSubview(outerView!)
        setupViews()
        
    }

}

extension CustomTextView : UITextViewDelegate {
    // MARK: Functions
    
    private func setupViews() {
        setupTabGestureOnCollView()
        collView.isHidden = true
        floatLbl.isHidden = true
        tView.delegate = self
        tView.isScrollEnabled = false
        tView.textContainerInset = UIEdgeInsets.zero
        tView.textContainer.lineFragmentPadding = 0
        tView.translatesAutoresizingMaskIntoConstraints = false
        floatLbl.font = AppFonts.NunitoSansRegular.withSize(14.0)
        tView.font =  AppFonts.NunitoSansBold.withSize(14.0)
        tView.textAlignment = AppUserDefaults.value(forKey: .language) == 1 ? .right : .left
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        switch textView {
        case tView:
            delegate?.shouldBegin(tView)
            return txtViewEditable
        default:
            return true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.didBegin(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.endEditing(textView)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return updatedText.count <= charLimit
    }
    
    func setupTabGestureOnCollView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        collView.isUserInteractionEnabled = true
        tap.numberOfTapsRequired = 1
        collView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        delegate?.collViewTapped(listingType: listingType)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewValueUpdated(textView)
    }
  
}


